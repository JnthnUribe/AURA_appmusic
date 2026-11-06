import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/network/api_exception.dart';
import '../../core/providers.dart';
import '../../data/local/database.dart';
import '../settings/settings_controller.dart';
import 'queue_engine.dart';

@immutable
class PlayerState {
  const PlayerState({
    this.queue = const [],
    this.index = 0,
    this.playing = false,
    this.loading = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.shuffle = false,
    this.repeat = RepeatMode.off,
    this.speed = 1,
    this.volume = 1,
    this.sleepTimer,
    this.error,
  });

  final List<LocalTrack> queue;
  final int index;
  final bool playing;
  final bool loading;
  final Duration position;
  final Duration duration;
  final bool shuffle;
  final RepeatMode repeat;
  final double speed;
  final double volume;
  final Duration? sleepTimer;
  final String? error;

  LocalTrack? get current =>
      queue.isEmpty || index < 0 || index >= queue.length ? null : queue[index];

  double get progress {
    if (duration.inMilliseconds <= 0) return 0;
    return (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }

  PlayerState copyWith({
    List<LocalTrack>? queue,
    int? index,
    bool? playing,
    bool? loading,
    Duration? position,
    Duration? duration,
    bool? shuffle,
    RepeatMode? repeat,
    double? speed,
    double? volume,
    Duration? sleepTimer,
    bool clearSleepTimer = false,
    String? error,
    bool clearError = false,
  }) {
    return PlayerState(
      queue: queue ?? this.queue,
      index: index ?? this.index,
      playing: playing ?? this.playing,
      loading: loading ?? this.loading,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      shuffle: shuffle ?? this.shuffle,
      repeat: repeat ?? this.repeat,
      speed: speed ?? this.speed,
      volume: volume ?? this.volume,
      sleepTimer: clearSleepTimer ? null : (sleepTimer ?? this.sleepTimer),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class PlayerController extends Notifier<PlayerState> {
  final QueueEngine _engine = QueueEngine();
  AudioPlayer? _audio;
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  Timer? _saveTimer;
  Timer? _flushTimer;
  Timer? _sleepTimer;
  Timer? _sleepTicker;
  DateTime? _startedAt;
  bool _reported = false;
  double _baseVolume = 1;
  int? _pendingSeekMs;

  @override
  PlayerState build() {
    ref.onDispose(() {
      for (final subscription in _subscriptions) {
        subscription.cancel();
      }
      _saveTimer?.cancel();
      _flushTimer?.cancel();
      _sleepTimer?.cancel();
      _sleepTicker?.cancel();
      _audio?.dispose();
    });
    Future<void>.microtask(_restore);
    return const PlayerState();
  }

  Future<void> _restore() async {
    final database = ref.read(databaseProvider);
    final saved = await database.readPlayback();
    final ids = await database.readQueue();
    if (ids.isEmpty) return;
    final tracks = <LocalTrack>[];
    for (final id in ids) {
      final track = await database.trackById(id);
      if (track != null) tracks.add(track);
    }
    if (tracks.isEmpty) return;
    _engine.setQueue(
      tracks.map((track) => track.id).toList(),
      index: saved?.queueIndex ?? 0,
      shuffle: saved?.shuffle ?? false,
      repeat: switch (saved?.repeatMode) {
        'all' => RepeatMode.all,
        'one' => RepeatMode.one,
        _ => RepeatMode.off,
      },
    );
    _baseVolume = saved?.volume ?? 1;
    state = state.copyWith(
      queue: tracks,
      index: _engine.index,
      shuffle: _engine.shuffle,
      repeat: _engine.repeat,
      position: Duration(milliseconds: saved?.positionMs ?? 0),
      speed: saved?.speed ?? 1,
      volume: _baseVolume,
    );
    _pendingSeekMs = saved?.positionMs;
    _applyEngineOrder(tracks);
  }

  AudioPlayer _ensurePlayer() {
    final existing = _audio;
    if (existing != null) return existing;
    final player = AudioPlayer();
    _audio = player;
    _subscriptions.add(
      player.positionStream.listen((position) {
        if (!state.loading) {
          state = state.copyWith(position: position);
        }
        _maybeReportPlay(position);
      }),
    );
    _subscriptions.add(
      player.durationStream.listen((duration) {
        if (duration != null) state = state.copyWith(duration: duration);
      }),
    );
    _subscriptions.add(
      player.playerStateStream.listen((playerState) {
        final playing = playerState.playing;
        state = state.copyWith(
          playing: playing,
          loading:
              playerState.processingState == ProcessingState.loading ||
              playerState.processingState == ProcessingState.buffering,
        );
        if (playerState.processingState == ProcessingState.completed) {
          _onCompleted();
        }
      }),
    );
    return player;
  }

  Future<void> playTrack(
    LocalTrack track, {
    List<LocalTrack>? queueOf,
    bool shuffle = false,
  }) async {
    final tracks = queueOf ?? [track];
    var index = tracks.indexWhere((item) => item.id == track.id);
    if (index < 0) index = 0;
    await playQueue(tracks, index: index, shuffle: shuffle);
  }

  Future<void> playQueue(
    List<LocalTrack> tracks, {
    int index = 0,
    bool? shuffle,
  }) async {
    if (tracks.isEmpty) return;
    await _reportPlayIfNeeded();
    _engine.setQueue(
      tracks.map((track) => track.id).toList(),
      index: index,
      shuffle: shuffle ?? state.shuffle,
      repeat: state.repeat,
    );
    _pendingSeekMs = null;
    state = state.copyWith(
      queue: tracks,
      index: _engine.index,
      shuffle: _engine.shuffle,
      position: Duration.zero,
      duration: Duration.zero,
      clearError: true,
    );
    _applyEngineOrder(tracks);
    await _loadCurrent(autoPlay: true);
    await _persist();
  }

  Future<void> _loadCurrent({bool autoPlay = true}) async {
    final track = state.current;
    if (track == null) return;
    state = state.copyWith(loading: true, clearError: true);
    try {
      final player = _ensurePlayer();
      final localPath = track.localAudioPath;
      final AudioSource source;
      if (localPath != null && File(localPath).existsSync()) {
        source = AudioSource.uri(Uri.file(localPath));
      } else {
        final stream = await ref
            .read(libraryRepositoryProvider)
            .streamFor(track.id);
        source = AudioSource.uri(Uri.parse(stream.url));
      }
      await player.setAudioSource(source);
      await player.setSpeed(state.speed);
      await _applyVolume();
      _startedAt = DateTime.now();
      _reported = false;
      final seekMs = _pendingSeekMs;
      _pendingSeekMs = null;
      if (seekMs != null && seekMs > 0) {
        await player.seek(Duration(milliseconds: seekMs));
      }
      if (autoPlay) {
        await player.play();
      }
      state = state.copyWith(
        loading: false,
        playing: autoPlay,
        duration: player.duration ?? track.duration ?? Duration.zero,
      );
      _startTimers();
    } catch (error) {
      state = state.copyWith(
        loading: false,
        playing: false,
        error: error is ApiException ? error.userMessage : 'No se pudo reproducir.',
      );
    }
  }

  Future<void> togglePlay() async {
    final track = state.current;
    if (track == null) return;
    final player = _audio;
    if (player == null || player.audioSource == null) {
      await _loadCurrent();
      return;
    }
    if (player.playing) {
      await player.pause();
      await _reportPlayIfNeeded();
      await _persist();
      await _flushPlays();
    } else {
      await player.play();
      _startedAt ??= DateTime.now();
      _startTimers();
    }
  }

  Future<void> pause() async {
    await _audio?.pause();
    await _reportPlayIfNeeded();
    await _persist();
    await _flushPlays();
  }

  Future<void> seek(Duration position) async {
    final player = _ensurePlayer();
    await player.seek(position);
    state = state.copyWith(position: position);
  }

  Future<void> skipNext({bool automatic = false}) async {
    final next = _engine.next(automatic: automatic);
    if (next == null) {
      if (automatic) {
        await _reportPlayIfNeeded(completed: true);
      }
      await _audio?.pause();
      state = state.copyWith(playing: false);
      return;
    }
    await _reportPlayIfNeeded(completed: automatic);
    state = state.copyWith(
      index: _engine.index,
      position: Duration.zero,
      duration: Duration.zero,
    );
    await _loadCurrent();
    await _persist();
  }

  Future<void> skipPrevious() async {
    if (state.position > const Duration(seconds: 3)) {
      await seek(Duration.zero);
      return;
    }
    final previous = _engine.previous();
    if (previous == null) {
      await seek(Duration.zero);
      return;
    }
    await _reportPlayIfNeeded();
    state = state.copyWith(index: _engine.index, position: Duration.zero);
    await _loadCurrent();
    await _persist();
  }

  Future<void> jumpTo(int index) async {
    _engine.jumpTo(index);
    await _reportPlayIfNeeded();
    state = state.copyWith(index: _engine.index, position: Duration.zero);
    await _loadCurrent();
    await _persist();
  }

  Future<void> jumpToTrack(String trackId) async {
    _engine.jumpToId(trackId);
    state = state.copyWith(index: _engine.index, position: Duration.zero);
    await _loadCurrent();
    await _persist();
  }

  Future<void> toggleShuffle() async {
    _engine.toggleShuffle();
    state = state.copyWith(shuffle: _engine.shuffle);
    await _applyEngineOrder(state.queue);
    await _persist();
  }

  Future<void> cycleRepeat() async {
    _engine.cycleRepeat();
    state = state.copyWith(repeat: _engine.repeat);
    await _persist();
  }

  Future<void> setSpeed(double speed) async {
    state = state.copyWith(speed: speed.clamp(0.5, 2.0));
    await _audio?.setSpeed(state.speed);
  }

  Future<void> setVolume(double volume) async {
    _baseVolume = volume.clamp(0.0, 1.0);
    state = state.copyWith(volume: _baseVolume);
    await _applyVolume();
  }

  Future<void> _applyVolume() async {
    final track = state.current;
    final normalize = ref.read(settingsControllerProvider).normalizeVolume;
    final gain = normalize && track?.replaygainDb != null
        ? math.pow(10, track!.replaygainDb! / 20).toDouble()
        : 1.0;
    final value = (_baseVolume * gain).clamp(0.0, 1.5);
    await _audio?.setVolume(value);
  }

  Future<void> addToQueue(LocalTrack track) async {
    _engine.append(track.id);
    state = state.copyWith(queue: [...state.queue, track]);
    await _persist();
  }

  Future<void> removeFromQueue(int index) async {
    if (index < 0 || index >= state.queue.length) return;
    final wasCurrent = index == state.index;
    final trackId = state.queue[index].id;
    _engine.remove(trackId);
    final remaining = [...state.queue]..removeAt(index);
    _applyEngineOrder(remaining);
    if (wasCurrent) {
      if (remaining.isEmpty) {
        await _audio?.stop();
        state = const PlayerState();
      } else {
        await _loadCurrent();
      }
    }
    await _persist();
  }

  Future<void> reorderQueue(int oldIndex, int newIndex) async {
    if (oldIndex < 0 || oldIndex >= state.queue.length) return;
    final adjusted = newIndex > oldIndex ? newIndex - 1 : newIndex;
    final reordered = [...state.queue];
    final item = reordered.removeAt(oldIndex);
    reordered.insert(adjusted.clamp(0, reordered.length), item);
    _engine.reorder(reordered.map((track) => track.id).toList());
    state = state.copyWith(queue: reordered, index: _engine.index);
    await _persist();
  }

  Future<void> _applyEngineOrder(List<LocalTrack> tracks) async {
    final byId = {for (final track in tracks) track.id: track};
    final ordered = <LocalTrack>[];
    for (final id in _engine.order) {
      final track = byId[id];
      if (track != null) ordered.add(track);
    }
    if (ordered.isNotEmpty) {
      state = state.copyWith(queue: ordered, index: _engine.index);
    }
  }

  void startSleepTimer(Duration duration) {
    _sleepTimer?.cancel();
    state = state.copyWith(sleepTimer: duration);
    _sleepTimer = Timer(duration, () async {
      final player = _audio;
      if (player == null) return;
      final start = player.volume;
      for (var step = 0; step < 10; step++) {
        await Future<void>.delayed(const Duration(seconds: 1));
        await player.setVolume(start * (1 - (step + 1) / 10));
      }
      await player.pause();
      await player.setVolume(start);
      state = state.copyWith(clearSleepTimer: true);
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _sleepTicker = timer;
      final remaining = state.sleepTimer;
      if (remaining == null || remaining <= Duration.zero) {
        timer.cancel();
        return;
      }
      state = state.copyWith(
        sleepTimer: remaining - const Duration(seconds: 1),
      );
      if (state.sleepTimer! <= Duration.zero) timer.cancel();
    });
  }

  Future<void> cancelSleepTimer() async {
    _sleepTimer?.cancel();
    _sleepTicker?.cancel();
    _sleepTimer = null;
    _sleepTicker = null;
    state = state.copyWith(clearSleepTimer: true);
  }

  void _startTimers() {
    _saveTimer ??= Timer.periodic(const Duration(seconds: 5), (_) {
      if (state.playing) _persist();
    });
    _flushTimer ??= Timer.periodic(
      const Duration(minutes: 15),
      (_) => _flushPlays(),
    );
  }

  void _maybeReportPlay(Duration position) {
    if (_reported || _startedAt == null) return;
    final duration = state.duration;
    final threshold = duration.inMilliseconds > 0
        ? math.min(30000, duration.inMilliseconds * 0.5)
        : 30000.0;
    if (position.inMilliseconds >= threshold) {
      _reported = true;
      _queuePlay(completed: false);
    }
  }

  Future<void> _onCompleted() async {
    await _reportPlayIfNeeded(completed: true);
    state = state.copyWith(playing: false);
    await skipNext(automatic: true);
  }

  Future<void> _reportPlayIfNeeded({bool completed = false}) async {
    if (_startedAt == null) return;
    if (_reported) {
      if (completed) {
        _startedAt = null;
        _reported = false;
      }
      return;
    }
    final track = state.current;
    if (track == null) return;
    final position = state.position;
    final duration = state.duration;
    final listened = position.inMilliseconds;
    final threshold = duration.inMilliseconds > 0
        ? math.min(30000, duration.inMilliseconds * 0.5)
        : 30000.0;
    if (listened >= threshold || completed) {
      _reported = true;
      await _queuePlay(completed: completed || state.progress >= 0.95);
    }
    _startedAt = null;
    _reported = false;
  }

  Future<void> _queuePlay({required bool completed}) async {
    final track = state.current;
    final startedAt = _startedAt;
    if (track == null || startedAt == null) return;
    await ref
        .read(databaseProvider)
        .addPlay(
          trackId: track.id,
          startedAt: startedAt,
          msPlayed: state.position.inMilliseconds,
          completed: completed,
          idempotencyKey:
              '${track.id}:${startedAt.millisecondsSinceEpoch}:${completed ? 1 : 0}',
        );
  }

  Future<void> _flushPlays() async {
    final database = ref.read(databaseProvider);
    final pending = await database.pendingPlays();
    if (pending.isEmpty) return;
    try {
      await ref.read(apiClientProvider).post(
        '/v1/plays/batch',
        data: {
          'plays': pending
              .map(
                (play) => {
                  'track_id': play.trackId,
                  'started_at': play.startedAt.toUtc().toIso8601String(),
                  'ms_played': play.msPlayed,
                  'completed': play.completed,
                  'source': 'app',
                  'idempotency_key': play.idempotencyKey,
                },
              )
              .toList(),
        },
      );
      await database.markPlaysSent(pending.map((play) => play.id).toList());
    } catch (_) {
      // Offline: the outbox survives and is retried later.
    }
  }

  Future<void> _persist() async {
    final database = ref.read(databaseProvider);
    await database.replaceQueue(
      state.queue.map((track) => track.id).toList(),
    );
    await database.savePlayback(
      trackId: state.current?.id,
      positionMs: state.position.inMilliseconds,
      queueIndex: state.index,
      repeatMode: state.repeat.name,
      shuffle: state.shuffle,
      speed: state.speed,
      volume: _baseVolume,
    );
  }
}

final playerControllerProvider = NotifierProvider<PlayerController, PlayerState>(
  PlayerController.new,
);

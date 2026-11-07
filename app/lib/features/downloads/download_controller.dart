import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/network/api_exception.dart';
import '../../core/providers.dart';
import '../../data/local/database.dart';

enum DownloadStatus { queued, downloading, completed, failed }

@immutable
class DownloadTask {
  const DownloadTask({
    required this.trackId,
    required this.status,
    this.progress = 0,
    this.error,
  });

  final String trackId;
  final DownloadStatus status;

  /// 0..1 for the current file.
  final double progress;
  final String? error;

  bool get isBusy =>
      status == DownloadStatus.queued ||
      status == DownloadStatus.downloading;
}

@immutable
class DownloadState {
  const DownloadState({this.tasks = const {}});

  final Map<String, DownloadTask> tasks;

  DownloadTask? forTrack(String trackId) => tasks[trackId];

  bool isDownloaded(String trackId) =>
      tasks[trackId]?.status == DownloadStatus.completed;

  bool get hasActiveDownloads =>
      tasks.values.any((task) => task.isBusy);
}

/// True when the Drift row has a local audio path (fast, no disk I/O).
bool hasLocalAudio(LocalTrack track) {
  final path = track.localAudioPath;
  return path != null && path.isNotEmpty;
}

/// True when the Drift row points at a file that still exists on disk.
bool isLocallyAvailable(LocalTrack track) {
  if (!hasLocalAudio(track)) return false;
  return File(track.localAudioPath!).existsSync();
}

/// Downloads audio from short-lived signed URLs into the app support
/// directory. Two transfers run at once; the rest wait in memory. A finished
/// download is recorded in `local_tracks.local_audio_path`, which the player
/// already prefers over streaming.
class DownloadController extends Notifier<DownloadState> {
  static const maxConcurrent = 2;

  final Map<String, CancelToken> _tokens = {};
  final List<LocalTrack> _waiting = [];
  int _active = 0;

  @override
  DownloadState build() {
    ref.onDispose(() {
      for (final token in _tokens.values) {
        token.cancel('disposed');
      }
    });
    return const DownloadState();
  }

  Future<void> download(LocalTrack track) async {
    if (isLocallyAvailable(track)) {
      _put(track.id, DownloadStatus.completed, 1);
      return;
    }
    final current = state.forTrack(track.id);
    if (current != null && current.isBusy) return;
    if (_active >= maxConcurrent) {
      _waiting.add(track);
      _put(track.id, DownloadStatus.queued, 0);
      return;
    }
    await _run(track);
  }

  void cancel(String trackId) {
    _tokens.remove(trackId)?.cancel('cancelled');
    _waiting.removeWhere((track) => track.id == trackId);
    _remove(trackId);
  }

  Future<void> removeDownload(LocalTrack track) async {
    _tokens.remove(track.id)?.cancel('removed');
    _waiting.removeWhere((item) => item.id == track.id);
    _remove(track.id);
    await ref.read(databaseProvider).setLocalAudioPath(track.id, null);
    final path = track.localAudioPath;
    if (path == null) return;
    final file = File(path);
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } on FileSystemException {
      // Windows may keep the file locked while it is playing. The Drift row is
      // already cleared, so the track falls back to streaming and the orphan
      // file is removed by the OS cleanup or a later attempt.
    }
  }

  Future<void> _run(LocalTrack track) async {
    _active += 1;
    _put(track.id, DownloadStatus.downloading, 0);
    final cancelToken = CancelToken();
    _tokens[track.id] = cancelToken;
    try {
      final stream = await ref
          .read(libraryRepositoryProvider)
          .streamFor(track.id);
      final directory = await _downloadDirectory();
      final destination = File(p.join(directory.path, '${track.id}.m4a'));
      await ref
          .read(apiClientProvider)
          .download(
            stream.url,
            destination.path,
            cancelToken: cancelToken,
            onProgress: (received, total) {
              if (total > 0 && !cancelToken.isCancelled) {
                _put(
                  track.id,
                  DownloadStatus.downloading,
                  received / total,
                );
              }
            },
          );
      await ref
          .read(databaseProvider)
          .setLocalAudioPath(track.id, destination.path);
      _put(track.id, DownloadStatus.completed, 1);
    } on ApiException catch (error) {
      _put(track.id, DownloadStatus.failed, 0, error.userMessage);
    } catch (_) {
      _put(track.id, DownloadStatus.failed, 0, 'Download failed');
    } finally {
      _tokens.remove(track.id);
      _active -= 1;
      _drain();
    }
  }

  void _drain() {
    if (_waiting.isEmpty || _active >= maxConcurrent) return;
    final next = _waiting.removeAt(0);
    unawaited(_run(next));
  }

  Future<Directory> _downloadDirectory() async {
    final root = await getApplicationSupportDirectory();
    final directory = Directory(p.join(root.path, 'audio'));
    await directory.create(recursive: true);
    return directory;
  }

  void _put(
    String trackId,
    DownloadStatus status,
    double progress, [
    String? error,
  ]) {
    final tasks = Map<String, DownloadTask>.from(state.tasks);
    tasks[trackId] = DownloadTask(
      trackId: trackId,
      status: status,
      progress: progress.clamp(0.0, 1.0),
      error: error,
    );
    state = DownloadState(tasks: tasks);
  }

  void _remove(String trackId) {
    if (!state.tasks.containsKey(trackId)) return;
    final tasks = Map<String, DownloadTask>.from(state.tasks)
      ..remove(trackId);
    state = DownloadState(tasks: tasks);
  }
}

final downloadControllerProvider =
    NotifierProvider<DownloadController, DownloadState>(
      DownloadController.new,
    );

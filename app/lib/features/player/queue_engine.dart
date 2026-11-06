import 'dart:math';

enum RepeatMode { off, all, one }

/// Pure queue logic, independent from audio so it can be unit-tested.
/// Shuffle does not repeat a track until the bag is exhausted.
class QueueEngine {
  QueueEngine({
    List<String> tracks = const [],
    int index = 0,
    bool shuffle = false,
    RepeatMode repeat = RepeatMode.off,
    Random? random,
  }) : _random = random ?? Random() {
    setQueue(tracks, index: index, shuffle: shuffle, repeat: repeat);
  }

  final Random _random;
  List<String> _original = const [];
  List<String> _order = const [];
  int _index = 0;
  bool _shuffle = false;
  RepeatMode _repeat = RepeatMode.off;

  List<String> get order => List.unmodifiable(_order);
  List<String> get original => List.unmodifiable(_original);
  int get index => _index;
  bool get shuffle => _shuffle;
  RepeatMode get repeat => _repeat;
  bool get isEmpty => _order.isEmpty;
  String? get current => _order.isEmpty ? null : _order[_index];
  bool get hasNext =>
      _repeat == RepeatMode.all || _repeat == RepeatMode.one || _index < _order.length - 1;
  bool get hasPrevious => _repeat == RepeatMode.all || _index > 0;

  void setQueue(
    List<String> tracks, {
    int index = 0,
    bool? shuffle,
    RepeatMode? repeat,
  }) {
    _original = List<String>.of(tracks);
    _shuffle = shuffle ?? _shuffle;
    _repeat = repeat ?? _repeat;
    if (_shuffle) {
      _order = _shuffledWithCurrentFirst(_original, index);
      _index = _original.isEmpty ? 0 : 0;
    } else {
      _order = List<String>.of(_original);
      _index = _order.isEmpty ? 0 : index.clamp(0, _order.length - 1);
    }
  }

  /// Adds a track at the end without disturbing the current one.
  void append(String trackId) {
    _original = [..._original, trackId];
    _order = [..._order, trackId];
  }

  void remove(String trackId) {
    final currentId = current;
    _original = _original.where((id) => id != trackId).toList();
    _order = _order.where((id) => id != trackId).toList();
    if (_order.isEmpty) {
      _index = 0;
      return;
    }
    final position = currentId == null ? -1 : _order.indexOf(currentId);
    _index = position >= 0 ? position : _index.clamp(0, _order.length - 1);
  }

  String? next({bool automatic = false}) {
    if (_order.isEmpty) return null;
    if (automatic && _repeat == RepeatMode.one) return current;
    if (_index + 1 < _order.length) {
      _index += 1;
      return current;
    }
    if (_repeat == RepeatMode.all) {
      _index = 0;
      return current;
    }
    return null;
  }

  String? previous() {
    if (_order.isEmpty) return null;
    if (_index > 0) {
      _index -= 1;
      return current;
    }
    if (_repeat == RepeatMode.all) {
      _index = _order.length - 1;
      return current;
    }
    return null;
  }

  void jumpTo(int index) {
    if (_order.isEmpty) return;
    _index = index.clamp(0, _order.length - 1);
  }

  /// Jumps to a track, using the original order as a fallback.
  void jumpToId(String trackId) {
    final position = _order.indexOf(trackId);
    if (position >= 0) {
      _index = position;
      return;
    }
    if (_original.contains(trackId)) {
      toggleShuffle(enabled: false);
      _index = _order.indexOf(trackId);
    }
  }

  void toggleShuffle({bool? enabled}) {
    final target = enabled ?? !_shuffle;
    if (target == _shuffle) return;
    final currentId = current;
    _shuffle = target;
    if (_shuffle) {
      final remaining = _original.where((id) => id != currentId).toList()
        ..shuffle(_random);
      _order = currentId == null ? remaining : [currentId, ...remaining];
      _index = 0;
    } else {
      _order = List<String>.of(_original);
      _index = currentId == null ? 0 : _order.indexOf(currentId);
      if (_index < 0) _index = 0;
    }
  }

  void setRepeat(RepeatMode mode) => _repeat = mode;

  RepeatMode cycleRepeat() {
    _repeat = switch (_repeat) {
      RepeatMode.off => RepeatMode.all,
      RepeatMode.all => RepeatMode.one,
      RepeatMode.one => RepeatMode.off,
    };
    return _repeat;
  }

  /// Replaces a queue without losing the currently playing track, when it is
  /// part of the new set.
  void reorder(List<String> ids) {
    final currentId = current;
    _original = List<String>.of(ids);
    _order = List<String>.of(ids);
    final position = currentId == null ? -1 : _order.indexOf(currentId);
    _index = position >= 0 ? position : 0;
    if (_shuffle && currentId != null) {
      final remaining = _order.where((id) => id != currentId).toList()
        ..shuffle(_random);
      _order = [currentId, ...remaining];
      _index = 0;
    }
  }

  List<String> _shuffledWithCurrentFirst(List<String> tracks, int index) {
    if (tracks.isEmpty) return const [];
    final current = tracks[index.clamp(0, tracks.length - 1)];
    final rest = tracks.where((id) => id != current).toList()..shuffle(_random);
    return [current, ...rest];
  }
}

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/network/api_exception.dart';
import '../../core/providers.dart';
import '../../data/local/database.dart';

class SearchState {
  const SearchState({
    this.query = '',
    this.local = const [],
    this.remote,
    this.loading = false,
    this.error,
  });

  final String query;
  final List<LocalTrack> local;
  final SearchResults? remote;
  final bool loading;
  final String? error;

  List<LocalTrack> get tracks {
    final merged = <String, LocalTrack>{
      for (final track in local) track.id: track,
      for (final track in remote?.tracks ?? const <Track>[]) track.id: _fromApi(track),
    };
    return merged.values.toList(growable: false);
  }

  bool get isEmpty =>
      query.isNotEmpty &&
      tracks.isEmpty &&
      (remote?.albums.isEmpty ?? true) &&
      (remote?.artists.isEmpty ?? true);

  static LocalTrack _fromApi(Track track) {
    // Remote-only rows are shown through the album/artist sections; the local
    // cache is updated in the background by the repository.
    return LocalTrack(
      id: track.id,
      title: track.title,
      titleNorm: track.titleNorm,
      version: track.version,
      albumId: track.album?.id,
      albumTitle: track.album?.title,
      coverAssetId: track.album?.coverAssetId,
      artistNames: track.artistNames,
      artistIds: track.artists.map((artist) => artist.id).join(','),
      trackNo: track.trackNo,
      discNo: track.discNo,
      durationMs: track.durationMs,
      sourceProvider: track.sourceProvider,
      sourceRef: track.sourceRef,
      audioAssetId: track.audioAssetId,
      loudnessLufs: track.loudnessLufs,
      replaygainDb: track.replaygainDb,
      bpm: track.bpm,
      energy: track.energy,
      status: track.status,
      explicit: track.explicit,
      favorite: false,
      addedAt: track.addedAt,
      updatedAt: track.updatedAt,
      deletedAt: track.deletedAt,
      localAudioPath: null,
      cachedAt: DateTime.now(),
    );
  }
}

class SearchController extends Notifier<SearchState> {
  Timer? _debounce;
  StreamSubscription<List<LocalTrack>>? _localSubscription;

  @override
  SearchState build() {
    ref.onDispose(() {
      _debounce?.cancel();
      _localSubscription?.cancel();
    });
    return const SearchState();
  }

  void setQuery(String query) {
    final trimmed = query.trim();
    state = SearchState(query: trimmed, local: state.local);
    _debounce?.cancel();
    _localSubscription?.cancel();
    if (trimmed.isEmpty) {
      state = const SearchState();
      return;
    }
    _localSubscription = ref
        .read(libraryRepositoryProvider)
        .searchLocal(trimmed)
        .listen((tracks) {
          state = SearchState(
            query: state.query,
            local: tracks,
            remote: state.remote,
            loading: state.loading,
            error: state.error,
          );
        });
    if (trimmed.length < 2) return;
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _searchRemote(trimmed);
    });
  }

  Future<void> _searchRemote(String query) async {
    state = SearchState(
      query: state.query,
      local: state.local,
      remote: state.remote,
      loading: true,
    );
    try {
      final results = await ref
          .read(libraryRepositoryProvider)
          .searchRemote(query);
      if (state.query != query) return;
      state = SearchState(
        query: query,
        local: state.local,
        remote: results,
        loading: false,
      );
    } catch (error) {
      if (state.query != query) return;
      state = SearchState(
        query: query,
        local: state.local,
        remote: state.remote,
        loading: false,
        error: error is ApiException ? error.userMessage : null,
      );
    }
  }

  Future<void> retry() async {
    if (state.query.length >= 2) await _searchRemote(state.query);
  }

  void clear() {
    _debounce?.cancel();
    _localSubscription?.cancel();
    state = const SearchState();
  }
}

final searchControllerProvider =
    NotifierProvider<SearchController, SearchState>(SearchController.new);

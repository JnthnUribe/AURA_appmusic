import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_exception.dart';
import '../../core/providers.dart';
import '../../data/local/database.dart';

final tracksProvider = StreamProvider<List<LocalTrack>>((ref) {
  return ref.watch(libraryRepositoryProvider).watchTracks();
});

final favoritesProvider = StreamProvider<List<LocalTrack>>((ref) {
  return ref
      .watch(libraryRepositoryProvider)
      .watchTracks(favoritesOnly: true);
});

final albumsProvider = StreamProvider<List<LocalAlbum>>((ref) {
  return ref.watch(libraryRepositoryProvider).watchAlbums();
});

final artistsProvider = StreamProvider<List<LocalArtist>>((ref) {
  return ref.watch(libraryRepositoryProvider).watchArtists();
});

final playlistsProvider = StreamProvider<List<LocalPlaylist>>((ref) {
  return ref.watch(libraryRepositoryProvider).watchPlaylists();
});

final albumTracksProvider = StreamProvider.family<List<LocalTrack>, String>((
  ref,
  albumId,
) {
  return ref.watch(libraryRepositoryProvider).watchTracks(albumId: albumId);
});

final albumProvider = FutureProvider.family<LocalAlbum?, String>((
  ref,
  albumId,
) {
  return ref.read(databaseProvider).albumById(albumId);
});

final artistProvider = FutureProvider.family<LocalArtist?, String>((
  ref,
  artistId,
) {
  return ref.read(databaseProvider).artistById(artistId);
});

final artistTracksProvider =
    StreamProvider.family<List<LocalTrack>, String>((ref, artistId) {
      return ref
          .watch(libraryRepositoryProvider)
          .watchTracks(artistId: artistId);
    });

class SyncState {
  const SyncState({
    this.syncing = false,
    this.lastSyncedAt,
    this.error,
  });

  final bool syncing;
  final DateTime? lastSyncedAt;
  final String? error;

  SyncState copyWith({
    bool? syncing,
    DateTime? lastSyncedAt,
    String? error,
    bool clearError = false,
  }) {
    return SyncState(
      syncing: syncing ?? this.syncing,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class SyncController extends Notifier<SyncState> {
  @override
  SyncState build() => const SyncState();

  Future<void> sync({bool full = false}) async {
    if (state.syncing) return;
    state = state.copyWith(syncing: true, clearError: true);
    try {
      await ref.read(libraryRepositoryProvider).sync(full: full);
      state = state.copyWith(
        syncing: false,
        lastSyncedAt: DateTime.now(),
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        syncing: false,
        error: error is ApiException ? error.userMessage : 'No se pudo sincronizar.',
      );
    }
  }

  Future<void> syncIfStale() async {
    final last = state.lastSyncedAt;
    if (last == null || DateTime.now().difference(last).inMinutes > 15) {
      await sync();
    }
  }
}

final syncControllerProvider = NotifierProvider<SyncController, SyncState>(
  SyncController.new,
);

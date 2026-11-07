import '../../core/models/models.dart';
import '../../core/network/api_client.dart';
import '../local/database.dart';

/// Offline-first library: writes every remote page to Drift and exposes
/// reactive local queries to the UI.
class LibraryRepository {
  LibraryRepository({required ApiClient api, required AuraDatabase database})
    : _api = api,
      _db = database;

  final ApiClient _api;
  final AuraDatabase _db;

  Stream<List<LocalTrack>> watchTracks({
    String? albumId,
    String? artistId,
    bool favoritesOnly = false,
  }) => _db.watchTracks(
    albumId: albumId,
    artistId: artistId,
    favoritesOnly: favoritesOnly,
  );

  Stream<List<LocalAlbum>> watchAlbums() => _db.watchAlbums();

  Stream<List<LocalArtist>> watchArtists() => _db.watchArtists();

  Stream<List<LocalPlaylist>> watchPlaylists() => _db.watchPlaylists();

  Future<LocalTrack?> trackById(String id) => _db.trackById(id);

  Future<void> sync({bool full = false}) async {
    final since = full ? null : await _db.meta('tracks.updated_since');
    final favorites = await _db.favoriteIds();
    String? cursor;
    var latest = since == null ? null : DateTime.tryParse(since);
    var pages = 0;

    do {
      final query = <String, dynamic>{
        'limit': 200,
        'include_deleted': true,
      };
      if (cursor != null) query['cursor'] = cursor;
      if (since != null) query['updated_since'] = since;
      final data =
          await _api.get(
                '/v1/tracks',
                query: query,
              )
              as Map<String, dynamic>;
      final page = Page.fromJson(data, Track.fromJson);
      await _db.upsertTracks(page.items);
      for (final track in page.items) {
        if (latest == null || track.updatedAt.isAfter(latest)) {
          latest = track.updatedAt;
        }
        if (favorites.contains(track.id)) {
          await _db.setFavorite(track.id, true);
        }
      }
      cursor = page.nextCursor;
      pages += 1;
    } while (cursor != null && pages < 25);

    if (latest != null) {
      await _db.setMeta('tracks.updated_since', latest.toUtc().toIso8601String());
    }

    final albums = await _api.get('/v1/albums', query: {'limit': 200});
    if (albums is List<dynamic>) {
      await _db.upsertAlbums(
        albums
            .whereType<Map<String, dynamic>>()
            .map(Album.fromJson)
            .toList(growable: false),
      );
    }

    final artists = await _api.get('/v1/artists', query: {'limit': 200});
    if (artists is List<dynamic>) {
      await _db.upsertArtists(
        artists
            .whereType<Map<String, dynamic>>()
            .map(Artist.fromJson)
            .toList(growable: false),
      );
    }

    await _syncPlaylists();
  }

  Future<void> _syncPlaylists() async {
    final data = await _api.get('/v1/playlists');
    if (data is! List<dynamic>) return;
    final playlists = data
        .whereType<Map<String, dynamic>>()
        .map(Playlist.fromJson)
        .toList(growable: false);
    final tracksByPlaylist = <String, List<String>>{};
    for (final playlist in playlists) {
      final detail = await _api.get('/v1/playlists/${playlist.id}');
      if (detail is Map<String, dynamic>) {
        final tracks = (detail['tracks'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(Track.fromJson)
            .toList(growable: false);
        await _db.upsertTracks(tracks);
        tracksByPlaylist[playlist.id] = tracks
            .map((track) => track.id)
            .toList(growable: false);
      }
    }
    await _db.replacePlaylists(playlists, tracksByPlaylist);
  }

  Future<SearchResults> searchRemote(String query) async {
    final data = await _api.get(
      '/v1/search',
      query: {'q': query, 'limit': 20},
    );
    if (data is! Map<String, dynamic>) return const SearchResults();
    final results = SearchResults.fromJson(data);
    await _db.upsertTracks(results.tracks);
    await _db.upsertAlbums(results.albums);
    await _db.upsertArtists(results.artists);
    return results;
  }

  Stream<List<LocalTrack>> searchLocal(String query) =>
      _db.searchLocal(query);

  Future<void> setFavorite(String trackId, bool favorite) async {
    final previous = (await _db.trackById(trackId))?.favorite ?? false;
    await _db.setFavorite(trackId, favorite);
    try {
      if (favorite) {
        await _api.put('/v1/favorites/$trackId');
      } else {
        await _api.delete('/v1/favorites/$trackId');
      }
    } catch (_) {
      await _db.setFavorite(trackId, previous);
      rethrow;
    }
  }

  Future<CoverInfo> coverForAlbum(String albumId) async {
    final data = await _api.get('/v1/albums/$albumId/cover');
    return CoverInfo.fromJson(data as Map<String, dynamic>);
  }

  Future<StatsOverview> statsOverview({String range = '30d'}) async {
    final data = await _api.get(
      '/v1/stats/overview',
      query: {'range': range},
    );
    return StatsOverview.fromJson(data as Map<String, dynamic>);
  }

  Future<StreamInfo> streamFor(String trackId) async {
    final data = await _api.get('/v1/tracks/$trackId/stream');
    return StreamInfo.fromJson(data as Map<String, dynamic>);
  }

  Future<LyricsDocument?> lyricsFor(String trackId) async {
    try {
      final data =
          await _api.get('/v1/tracks/$trackId/lyrics') as Map<String, dynamic>;
      final document = LyricsDocument.fromJson(data);
      await _db.putLyrics(trackId, document);
      return document;
    } catch (_) {
      final cached = await _db.lyricsFor(trackId);
      return cached?.toDocument();
    }
  }

  Future<void> setLyricsOffset(String trackId, int offsetMs) async {
    await _api.patch(
      '/v1/tracks/$trackId/lyrics/offset',
      data: {'offset_ms': offsetMs},
    );
    final cached = await _db.lyricsFor(trackId);
    if (cached != null) {
      final document = cached.toDocument();
      await _db.putLyrics(
        trackId,
        LyricsDocument(
          lines: document.lines,
          kind: document.kind,
          source: document.source,
          offsetMs: offsetMs,
          plainText: document.plainText,
        ),
      );
    }
  }

  Future<void> clearCache() => _db.clearLibrary();
}

import 'package:aura/core/models/models.dart';
import 'package:aura/data/local/database.dart';
import 'package:flutter_test/flutter_test.dart';

Track _track(
  String id, {
  String? title,
  String? albumId,
  String? albumTitle,
  List<ArtistRef> artists = const [],
  int? durationMs,
  bool explicit = false,
  DateTime? deletedAt,
}) {
  final stamp = DateTime.utc(2026, 1, 2, 3, 4, 5);
  return Track(
    id: id,
    title: title ?? 'Track $id',
    titleNorm: (title ?? 'Track $id').toLowerCase(),
    album: albumId == null
        ? null
        : AlbumRef(id: albumId, title: albumTitle ?? 'Album', year: 2026),
    artists: artists,
    durationMs: durationMs,
    explicit: explicit,
    sourceProvider: 'local',
    sourceRef: '/music/$id.flac',
    status: 'ready',
    addedAt: stamp,
    updatedAt: stamp,
    deletedAt: deletedAt,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuraDatabase db;

  setUp(() {
    db = AuraDatabase.memory();
  });

  tearDown(() async {
    await db.close();
  });

  group('library cache', () {
    test('upserts tracks and keeps local state when re-syncing', () async {
      await db.upsertTracks([
        _track(
          't1',
          title: 'Canción',
          albumId: 'a1',
          albumTitle: 'Álbum',
          artists: const [ArtistRef(id: 'ar1', name: 'Artista')],
          durationMs: 183000,
        ),
      ]);
      await db.setFavorite('t1', true);
      await db.setLocalAudioPath('t1', r'C:\cache\t1.m4a');

      expect(await db.countTracks(), 1);
      final cached = await db.trackById('t1');
      expect(cached!.title, 'Canción');
      expect(cached.artistIds, 'ar1');
      expect(cached.duration, const Duration(minutes: 3, seconds: 3));
      expect(cached.favorite, isTrue);

      // A later server sync must not wipe favorite or the downloaded file.
      await db.upsertTracks([_track('t1', title: 'Canción (Remastered)')]);
      final refreshed = await db.trackById('t1');
      expect(refreshed!.title, 'Canción (Remastered)');
      expect(refreshed.favorite, isTrue);
      expect(refreshed.localAudioPath, r'C:\cache\t1.m4a');
    });

    test('hides soft-deleted tracks and filters by album and artist', () async {
      await db.upsertTracks([
        _track('t1', albumId: 'a1', artists: const [
          ArtistRef(id: 'ar1', name: 'Uno'),
        ]),
        _track('t2', albumId: 'a2', artists: const [
          ArtistRef(id: 'ar2', name: 'Dos'),
        ]),
        _track('t3', albumId: 'a1', deletedAt: DateTime.utc(2026, 2, 1)),
      ]);

      expect(
        (await db.watchTracks().first).map((row) => row.id),
        ['t2', 't1'],
        reason: 'newest addedAt first, then id descending',
      );
      expect(
        (await db.watchTracks(albumId: 'a1').first).map((row) => row.id),
        ['t1'],
      );
      expect(
        (await db.watchTracks(artistId: 'ar2').first).map((row) => row.id),
        ['t2'],
      );
    });

    test('search matches normalized titles, artists and album names', () async {
      await db.upsertTracks([
        _track(
          't1',
          title: 'Luz de luna',
          albumId: 'a1',
          albumTitle: 'Nocturno',
          artists: const [ArtistRef(id: 'ar1', name: 'Marina')],
        ),
        _track('t2', title: 'Otro tema'),
      ]);

      expect((await db.searchLocal('LUZ').first).single.id, 't1');
      expect((await db.searchLocal('marina').first).single.id, 't1');
      expect((await db.searchLocal('nocturno').first).single.id, 't1');
      expect(await db.searchLocal('inexistente').first, isEmpty);
    });

    test('albums and artists are ordered by normalized name', () async {
      await db.upsertAlbums(const [
        Album(id: 'a2', title: 'Zeta'),
        Album(id: 'a1', title: 'alfa'),
      ]);
      await db.upsertArtists(const [
        Artist(id: 'ar2', name: 'Zoe'),
        Artist(id: 'ar1', name: 'ana'),
      ]);

      expect((await db.watchAlbums().first).map((row) => row.title), [
        'alfa',
        'Zeta',
      ]);
      expect((await db.watchArtists().first).map((row) => row.name), [
        'ana',
        'Zoe',
      ]);
    });

    test('favorites survive and clearLibrary resets the cache', () async {
      await db.upsertTracks([_track('t1'), _track('t2')]);
      await db.setFavorite('t1', true);
      expect(await db.favoriteIds(), {'t1'});

      await db.clearLibrary();
      expect(await db.countTracks(), 0);
      expect(await db.favoriteIds(), isEmpty);
    });
  });

  group('playlists', () {
    test('replaces playlists and keeps track order', () async {
      await db.replacePlaylists(
        const [
          Playlist(id: 'p1', name: 'Favoritas', kind: 'manual'),
          Playlist(id: 'p2', name: 'Noche', kind: 'smart'),
        ],
        {
          'p1': ['t3', 't1', 't2'],
          'p2': ['t2'],
        },
      );

      final playlists = await db.watchPlaylists().first;
      expect(playlists.map((row) => row.id), ['p1', 'p2']);

      final rows = await db.select(db.localPlaylistTracks).get();
      final p1 = rows.where((row) => row.playlistId == 'p1').toList()
        ..sort((a, b) => a.position.compareTo(b.position));
      expect(p1.map((row) => row.trackId), ['t3', 't1', 't2']);

      await db.replacePlaylists(const [], const {});
      expect(await db.watchPlaylists().first, isEmpty);
      expect(await db.select(db.localPlaylistTracks).get(), isEmpty);
    });
  });

  group('queue and playback state', () {
    test('queue survives a restart in insertion order', () async {
      await db.replaceQueue(['t2', 't1', 't3']);
      expect(await db.readQueue(), ['t2', 't1', 't3']);

      await db.replaceQueue(['t3']);
      expect(await db.readQueue(), ['t3']);
    });

    test('playback state round-trips with defaults', () async {
      expect(await db.readPlayback(), isNull);

      await db.savePlayback(
        trackId: 't1',
        positionMs: 42000,
        queueIndex: 2,
        repeatMode: 'all',
        shuffle: true,
        speed: 1.25,
        volume: 0.8,
      );
      final state = await db.readPlayback();
      expect(state!.trackId, 't1');
      expect(state.positionMs, 42000);
      expect(state.queueIndex, 2);
      expect(state.repeatMode, 'all');
      expect(state.shuffle, isTrue);
      expect(state.speed, 1.25);
      expect(state.volume, 0.8);

      await db.savePlayback(
        trackId: null,
        positionMs: 0,
        queueIndex: 0,
        repeatMode: 'off',
        shuffle: false,
      );
      final reset = await db.readPlayback();
      expect(reset!.trackId, isNull);
      expect(reset.speed, 1);
      expect(
        await db.select(db.playbackStates).get(),
        hasLength(1),
        reason: 'a single row keyed by "current"',
      );
    });
  });

  group('play outbox', () {
    test('deduplicates by idempotency key and marks batches as sent', () async {
      final started = DateTime.utc(2026, 3, 1, 12);
      await db.addPlay(
        trackId: 't1',
        startedAt: started,
        msPlayed: 30000,
        completed: false,
        idempotencyKey: 'play-1',
      );
      await db.addPlay(
        trackId: 't1',
        startedAt: started,
        msPlayed: 30000,
        completed: false,
        idempotencyKey: 'play-1',
      );
      await db.addPlay(
        trackId: 't2',
        startedAt: started.add(const Duration(minutes: 4)),
        msPlayed: 180000,
        completed: true,
        idempotencyKey: 'play-2',
      );

      final pending = await db.pendingPlays();
      expect(pending.map((row) => row.idempotencyKey), ['play-1', 'play-2']);

      await db.markPlaysSent(pending.map((row) => row.id).toList());
      expect(await db.pendingPlays(), isEmpty);
    });
  });

  group('lyrics cache', () {
    test('round-trips word timings and escapes JSON strings', () async {
      const document = LyricsDocument(
        kind: 'synced',
        source: 'lrclib',
        offsetMs: -250,
        plainText: 'hola "mundo"',
        lines: [
          LyricLine(
            t: 0,
            end: 1500,
            text: 'hola "mundo"',
            words: [
              LyricWord(t: 0, text: 'hola'),
              LyricWord(t: 600, text: 'mundo'),
            ],
          ),
          LyricLine(t: 1500, end: 0, text: 'línea\\dos'),
        ],
      );

      await db.putLyrics('t1', document);
      final cached = await db.lyricsFor('t1');
      expect(cached, isNotNull);

      final restored = cached!.toDocument();
      expect(restored.kind, 'synced');
      expect(restored.isSynced, isTrue);
      expect(restored.offsetMs, -250);
      expect(restored.lines, hasLength(2));
      expect(restored.lines.first.words.map((word) => word.text), [
        'hola',
        'mundo',
      ]);
      expect(restored.lines.first.text, 'hola "mundo"');
      expect(restored.lines.last.text, 'línea\\dos');

      await db.putLyrics(
        't1',
        const LyricsDocument(lines: [], plainText: 'nueva'),
      );
      expect((await db.lyricsFor('t1'))!.plainText, 'nueva');
      expect(await db.lyricsFor('missing'), isNull);
    });

    test('clearLibrary also drops cached lyrics', () async {
      await db.putLyrics(
        't1',
        const LyricsDocument(lines: [], plainText: 'letra'),
      );
      await db.clearLibrary();
      expect(await db.lyricsFor('t1'), isNull);
    });
  });

  test('sync metadata stores the last cursor', () async {
    expect(await db.meta('library.cursor'), isNull);
    await db.setMeta('library.cursor', 'abc');
    await db.setMeta('library.cursor', 'def');
    expect(await db.meta('library.cursor'), 'def');
  });
}

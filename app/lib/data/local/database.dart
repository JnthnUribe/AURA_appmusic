import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/models/models.dart';

part 'database.g.dart';

class LocalTracks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get titleNorm => text().withDefault(const Constant(''))();
  TextColumn get version => text().nullable()();
  TextColumn get albumId => text().nullable()();
  TextColumn get albumTitle => text().nullable()();
  TextColumn get coverAssetId => text().nullable()();
  TextColumn get artistNames => text().withDefault(const Constant(''))();
  TextColumn get artistIds => text().withDefault(const Constant(''))();
  IntColumn get trackNo => integer().nullable()();
  IntColumn get discNo => integer().nullable()();
  IntColumn get durationMs => integer().nullable()();
  TextColumn get sourceProvider => text().withDefault(const Constant(''))();
  TextColumn get sourceRef => text().withDefault(const Constant(''))();
  TextColumn get audioAssetId => text().nullable()();
  RealColumn get loudnessLufs => real().nullable()();
  RealColumn get replaygainDb => real().nullable()();
  RealColumn get bpm => real().nullable()();
  RealColumn get energy => real().nullable()();
  TextColumn get status => text().withDefault(const Constant('ready'))();
  BoolColumn get explicit => boolean().withDefault(const Constant(false))();
  BoolColumn get favorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get addedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get localAudioPath => text().nullable()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class LocalAlbums extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get titleNorm => text().withDefault(const Constant(''))();
  IntColumn get year => integer().nullable()();
  TextColumn get coverAssetId => text().nullable()();
  TextColumn get albumArtistId => text().nullable()();
  TextColumn get albumArtistName => text().nullable()();
  IntColumn get totalTracks => integer().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class LocalArtists extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get nameNorm => text().withDefault(const Constant(''))();
  TextColumn get sortName => text().nullable()();
  TextColumn get imageAssetId => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class LocalPlaylists extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get kind => text().withDefault(const Constant('manual'))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class LocalPlaylistTracks extends Table {
  TextColumn get playlistId => text()();
  TextColumn get trackId => text()();
  IntColumn get position => integer()();

  @override
  Set<Column<Object>> get primaryKey => {playlistId, trackId};
}

class QueueEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get trackId => text()();
  IntColumn get position => integer()();
}

class PlaybackStates extends Table {
  TextColumn get key => text().withDefault(const Constant('current'))();
  TextColumn get trackId => text().nullable()();
  IntColumn get positionMs => integer().withDefault(const Constant(0))();
  IntColumn get queueIndex => integer().withDefault(const Constant(0))();
  TextColumn get repeatMode =>
      text().withDefault(const Constant('off'))();
  BoolColumn get shuffle => boolean().withDefault(const Constant(false))();
  RealColumn get speed => real().withDefault(const Constant(1))();
  RealColumn get volume => real().withDefault(const Constant(1))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

class OutboxPlays extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get trackId => text()();
  DateTimeColumn get startedAt => dateTime()();
  IntColumn get msPlayed => integer()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  TextColumn get idempotencyKey => text().unique()();
  BoolColumn get sent => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class CachedLyrics extends Table {
  TextColumn get trackId => text()();
  TextColumn get kind => text().withDefault(const Constant('plain'))();
  TextColumn get source => text().withDefault(const Constant('manual'))();
  IntColumn get offsetMs => integer().withDefault(const Constant(0))();
  TextColumn get plainText => text().withDefault(const Constant(''))();
  TextColumn get linesJson => text().withDefault(const Constant('[]'))();
  DateTimeColumn get fetchedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {trackId};
}

class SyncMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    LocalTracks,
    LocalAlbums,
    LocalArtists,
    LocalPlaylists,
    LocalPlaylistTracks,
    QueueEntries,
    PlaybackStates,
    OutboxPlays,
    CachedLyrics,
    SyncMeta,
  ],
)
class AuraDatabase extends _$AuraDatabase {
  AuraDatabase(super.e);

  AuraDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  static QueryExecutor openConnection() {
    return LazyDatabase(() async {
      final directory = await getApplicationSupportDirectory();
      await directory.create(recursive: true);
      return NativeDatabase.createInBackground(
        File(p.join(directory.path, 'aura.sqlite')),
      );
    });
  }

  // ── library ──────────────────────────────────────────────────────────────

  Future<void> upsertTracks(List<Track> tracks, {Map<String, String>? localPaths}) async {
    if (tracks.isEmpty) return;
    await batch((batch) {
      for (final track in tracks) {
        final companion = LocalTracksCompanion.insert(
          id: track.id,
          title: track.title,
          titleNorm: Value(track.titleNorm),
          version: Value(track.version),
          albumId: Value(track.album?.id),
          albumTitle: Value(track.album?.title),
          coverAssetId: Value(track.album?.coverAssetId),
          artistNames: Value(track.artistNames),
          artistIds: Value(track.artists.map((artist) => artist.id).join(',')),
          trackNo: Value(track.trackNo),
          discNo: Value(track.discNo),
          durationMs: Value(track.durationMs),
          sourceProvider: Value(track.sourceProvider),
          sourceRef: Value(track.sourceRef),
          audioAssetId: Value(track.audioAssetId),
          loudnessLufs: Value(track.loudnessLufs),
          replaygainDb: Value(track.replaygainDb),
          bpm: Value(track.bpm),
          energy: Value(track.energy),
          status: Value(track.status),
          explicit: Value(track.explicit),
          addedAt: track.addedAt,
          updatedAt: track.updatedAt,
          deletedAt: Value(track.deletedAt),
          localAudioPath: localPaths?[track.id] == null
              ? const Value.absent()
              : Value(localPaths![track.id]),
          cachedAt: Value(DateTime.now()),
        );
        batch.insert(
          localTracks,
          companion,
          onConflict: DoUpdate((_) => companion),
        );
      }
    });
  }

  Future<void> upsertAlbums(List<Album> albums) async {
    if (albums.isEmpty) return;
    await batch((batch) {
      for (final album in albums) {
        batch.insert(
          localAlbums,
          LocalAlbumsCompanion.insert(
            id: album.id,
            title: album.title,
            titleNorm: Value(_norm(album.title)),
            year: Value(album.year),
            coverAssetId: Value(album.coverAssetId),
            albumArtistId: Value(album.albumArtist?.id),
            albumArtistName: Value(album.albumArtist?.name),
            totalTracks: Value(album.totalTracks),
            updatedAt: Value(album.updatedAt ?? DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<void> upsertArtists(List<Artist> artists) async {
    if (artists.isEmpty) return;
    await batch((batch) {
      for (final artist in artists) {
        batch.insert(
          localArtists,
          LocalArtistsCompanion.insert(
            id: artist.id,
            name: artist.name,
            nameNorm: Value(_norm(artist.name)),
            sortName: Value(artist.sortName),
            imageAssetId: Value(artist.imageAssetId),
            updatedAt: Value(artist.updatedAt ?? DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Stream<List<LocalTrack>> watchTracks({
    String? albumId,
    String? artistId,
    bool favoritesOnly = false,
  }) {
    final query = select(localTracks)
      ..where((row) => row.deletedAt.isNull())
      ..orderBy([
        (row) => OrderingTerm.desc(row.addedAt),
        (row) => OrderingTerm.desc(row.id),
      ]);
    if (albumId != null) {
      query.where((row) => row.albumId.equals(albumId));
    }
    if (artistId != null) {
      query.where((row) => row.artistIds.like('%$artistId%'));
    }
    if (favoritesOnly) {
      query.where((row) => row.favorite.equals(true));
    }
    return query.watch();
  }

  Stream<List<LocalTrack>> searchLocal(String term) {
    final needle = '%${_norm(term)}%';
    return (select(localTracks)
          ..where(
            (row) =>
                row.titleNorm.like(needle) |
                row.artistNames.lower().like(needle) |
                row.albumTitle.lower().like(needle),
          )
          ..where((row) => row.deletedAt.isNull())
          ..orderBy([(row) => OrderingTerm.desc(row.addedAt)])
          ..limit(60))
        .watch();
  }

  Stream<List<LocalAlbum>> watchAlbums() {
    return (select(localAlbums)
          ..orderBy([(row) => OrderingTerm.asc(row.titleNorm)]))
        .watch();
  }

  Stream<List<LocalArtist>> watchArtists() {
    return (select(localArtists)
          ..orderBy([(row) => OrderingTerm.asc(row.nameNorm)]))
        .watch();
  }

  Future<LocalTrack?> trackById(String id) {
    return (select(localTracks)..where((row) => row.id.equals(id)))
        .getSingleOrNull();
  }

  Future<LocalAlbum?> albumById(String id) {
    return (select(localAlbums)..where((row) => row.id.equals(id)))
        .getSingleOrNull();
  }

  Future<LocalArtist?> artistById(String id) {
    return (select(localArtists)..where((row) => row.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> setFavorite(String trackId, bool favorite) {
    return (update(localTracks)..where((row) => row.id.equals(trackId))).write(
      LocalTracksCompanion(
        favorite: Value(favorite),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> setLocalAudioPath(String trackId, String? path) {
    return (update(localTracks)..where((row) => row.id.equals(trackId))).write(
      LocalTracksCompanion(localAudioPath: Value(path)),
    );
  }

  Future<Set<String>> favoriteIds() async {
    final rows = await (select(localTracks)..where((row) => row.favorite.equals(true))).get();
    return rows.map((row) => row.id).toSet();
  }

  Future<void> clearLibrary() async {
    await transaction(() async {
      await delete(localPlaylists).go();
      await delete(localPlaylistTracks).go();
      await delete(localTracks).go();
      await delete(localAlbums).go();
      await delete(localArtists).go();
      await delete(cachedLyrics).go();
    });
  }

  Future<int> countTracks() async {
    final expression = localTracks.id.count();
    final query = selectOnly(localTracks)..addColumns([expression]);
    return (await query.getSingle()).read(expression) ?? 0;
  }

  // ── playlists ────────────────────────────────────────────────────────────

  Future<void> replacePlaylists(
    List<Playlist> playlists,
    Map<String, List<String>> tracksByPlaylist,
  ) async {
    await transaction(() async {
      await delete(localPlaylistTracks).go();
      await delete(localPlaylists).go();
      for (final playlist in playlists) {
        await into(localPlaylists).insert(
          LocalPlaylistsCompanion.insert(
            id: playlist.id,
            name: playlist.name,
            description: Value(playlist.description),
            kind: Value(playlist.kind),
            updatedAt: Value(playlist.updatedAt ?? DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
        final ids = tracksByPlaylist[playlist.id] ?? const <String>[];
        for (var index = 0; index < ids.length; index++) {
          await into(localPlaylistTracks).insert(
            LocalPlaylistTracksCompanion.insert(
              playlistId: playlist.id,
              trackId: ids[index],
              position: index,
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      }
    });
  }

  Stream<List<LocalPlaylist>> watchPlaylists() {
    return (select(localPlaylists)
          ..orderBy([(row) => OrderingTerm.asc(row.name)]))
        .watch();
  }

  // ── queue and playback state ─────────────────────────────────────────────

  Future<void> replaceQueue(List<String> trackIds) async {
    await transaction(() async {
      await delete(queueEntries).go();
      for (var index = 0; index < trackIds.length; index++) {
        await into(queueEntries).insert(
          QueueEntriesCompanion.insert(trackId: trackIds[index], position: index),
        );
      }
    });
  }

  Future<List<String>> readQueue() async {
    final rows = await (select(queueEntries)
          ..orderBy([(row) => OrderingTerm.asc(row.position)]))
        .get();
    return rows.map((row) => row.trackId).toList(growable: false);
  }

  Future<void> savePlayback({
    required String? trackId,
    required int positionMs,
    required int queueIndex,
    required String repeatMode,
    required bool shuffle,
    double speed = 1,
    double volume = 1,
  }) {
    return into(playbackStates).insertOnConflictUpdate(
      PlaybackStatesCompanion.insert(
        trackId: Value(trackId),
        positionMs: Value(positionMs),
        queueIndex: Value(queueIndex),
        repeatMode: Value(repeatMode),
        shuffle: Value(shuffle),
        speed: Value(speed),
        volume: Value(volume),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<PlaybackState?> readPlayback() {
    return (select(playbackStates)
          ..where((row) => row.key.equals('current')))
        .getSingleOrNull();
  }

  // ── play outbox ──────────────────────────────────────────────────────────

  Future<void> addPlay({
    required String trackId,
    required DateTime startedAt,
    required int msPlayed,
    required bool completed,
    required String idempotencyKey,
  }) async {
    await into(outboxPlays).insert(
      OutboxPlaysCompanion.insert(
        trackId: trackId,
        startedAt: startedAt,
        msPlayed: msPlayed,
        completed: Value(completed),
        idempotencyKey: idempotencyKey,
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<List<OutboxPlay>> pendingPlays({int limit = 200}) {
    return (select(outboxPlays)
          ..where((row) => row.sent.equals(false))
          ..orderBy([(row) => OrderingTerm.asc(row.id)])
          ..limit(limit))
        .get();
  }

  Future<void> markPlaysSent(List<int> ids) async {
    if (ids.isEmpty) return;
    await (update(outboxPlays)..where((row) => row.id.isIn(ids))).write(
      const OutboxPlaysCompanion(sent: Value(true)),
    );
  }

  // ── lyrics ───────────────────────────────────────────────────────────────

  Future<void> putLyrics(String trackId, LyricsDocument document) {
    return into(cachedLyrics).insertOnConflictUpdate(
      CachedLyricsCompanion.insert(
        trackId: trackId,
        kind: Value(document.kind),
        source: Value(document.source),
        offsetMs: Value(document.offsetMs),
        plainText: Value(document.plainText),
        linesJson: Value(_linesToJson(document)),
        fetchedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<CachedLyric?> lyricsFor(String trackId) {
    return (select(cachedLyrics)..where((row) => row.trackId.equals(trackId)))
        .getSingleOrNull();
  }

  // ── sync metadata ────────────────────────────────────────────────────────

  Future<String?> meta(String key) async {
    final row = await (select(syncMeta)..where((row) => row.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setMeta(String key, String value) {
    return into(syncMeta).insertOnConflictUpdate(
      SyncMetaCompanion.insert(key: key, value: value),
    );
  }

  static String _norm(String value) => value.toLowerCase().trim();

  static String _linesToJson(LyricsDocument document) {
    final buffer = StringBuffer('[');
    for (var index = 0; index < document.lines.length; index++) {
      if (index > 0) buffer.write(',');
      final line = document.lines[index];
      buffer.write('{"t":${line.t},"end":${line.end},"text":');
      buffer.write(_jsonString(line.text));
      if (line.words.isNotEmpty) {
        buffer.write(',"words":[');
        for (var wordIndex = 0; wordIndex < line.words.length; wordIndex++) {
          if (wordIndex > 0) buffer.write(',');
          final word = line.words[wordIndex];
          buffer.write('{"t":${word.t},"text":${_jsonString(word.text)}}');
        }
        buffer.write(']');
      }
      buffer.write('}');
    }
    buffer.write(']');
    return buffer.toString();
  }

  static String _jsonString(String value) {
    return '"${value.replaceAll('\\', '\\\\').replaceAll('"', '\\"').replaceAll('\n', '\\n')}"';
  }
}

extension LocalTrackX on LocalTrack {
  Duration? get duration =>
      durationMs == null ? null : Duration(milliseconds: durationMs!);

  String get displayTitle => version == null ? title : '$title ($version)';
}

extension CachedLyricsMapper on CachedLyric {
  LyricsDocument toDocument() {
    return LyricsDocument.fromJson({
      'kind': kind,
      'source': source,
      'offset_ms': offsetMs,
      'plain_text': plainText,
      'lines': _decodeLines(linesJson),
    });
  }

  static List<dynamic> _decodeLines(String raw) {
    try {
      final decoded = jsonDecode(raw);
      return decoded is List<dynamic> ? decoded : const [];
    } on FormatException {
      return const [];
    }
  }
}

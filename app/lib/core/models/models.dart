/// API response models. Hand-written (no build step) but explicit so a
/// backend contract change fails loudly in one place.
library;

class ArtistRef {
  const ArtistRef({required this.id, required this.name});

  factory ArtistRef.fromJson(Map<String, dynamic> json) => ArtistRef(
    id: json['id'] as String,
    name: json['name'] as String,
  );

  final String id;
  final String name;

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class AlbumRef {
  const AlbumRef({
    required this.id,
    required this.title,
    this.year,
    this.coverAssetId,
  });

  factory AlbumRef.fromJson(Map<String, dynamic> json) => AlbumRef(
    id: json['id'] as String,
    title: json['title'] as String,
    year: (json['year'] as num?)?.toInt(),
    coverAssetId: json['cover_asset_id'] as String?,
  );

  final String id;
  final String title;
  final int? year;
  final String? coverAssetId;
}

class Album {
  const Album({
    required this.id,
    required this.title,
    this.year,
    this.coverAssetId,
    this.albumArtist,
    this.totalTracks,
    this.releaseDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
    id: json['id'] as String,
    title: json['title'] as String,
    year: (json['year'] as num?)?.toInt(),
    coverAssetId: json['cover_asset_id'] as String?,
    albumArtist: json['album_artist'] == null
        ? null
        : ArtistRef.fromJson(json['album_artist'] as Map<String, dynamic>),
    totalTracks: (json['total_tracks'] as num?)?.toInt(),
    releaseDate: json['release_date'] as String?,
    createdAt: _date(json['created_at']),
    updatedAt: _date(json['updated_at']),
  );

  final String id;
  final String title;
  final int? year;
  final String? coverAssetId;
  final ArtistRef? albumArtist;
  final int? totalTracks;
  final String? releaseDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

class Artist {
  const Artist({
    required this.id,
    required this.name,
    this.sortName,
    this.imageAssetId,
    this.createdAt,
    this.updatedAt,
  });

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
    id: json['id'] as String,
    name: json['name'] as String,
    sortName: json['sort_name'] as String?,
    imageAssetId: json['image_asset_id'] as String?,
    createdAt: _date(json['created_at']),
    updatedAt: _date(json['updated_at']),
  );

  final String id;
  final String name;
  final String? sortName;
  final String? imageAssetId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

class Track {
  const Track({
    required this.id,
    required this.title,
    required this.titleNorm,
    required this.sourceProvider,
    required this.sourceRef,
    required this.status,
    required this.addedAt,
    required this.updatedAt,
    this.version,
    this.album,
    this.artists = const [],
    this.trackNo,
    this.discNo,
    this.durationMs,
    this.isrc,
    this.language,
    this.explicit = false,
    this.audioAssetId,
    this.loudnessLufs,
    this.replaygainDb,
    this.bpm,
    this.energy,
    this.needsReview = false,
    this.deletedAt,
  });

  factory Track.fromJson(Map<String, dynamic> json) => Track(
    id: json['id'] as String,
    title: json['title'] as String,
    titleNorm: (json['title_norm'] as String?) ?? '',
    version: json['version'] as String?,
    album: json['album'] == null
        ? null
        : AlbumRef.fromJson(json['album'] as Map<String, dynamic>),
    artists: (json['artists'] as List<dynamic>? ?? const [])
        .map((item) => ArtistRef.fromJson(item as Map<String, dynamic>))
        .toList(growable: false),
    trackNo: (json['track_no'] as num?)?.toInt(),
    discNo: (json['disc_no'] as num?)?.toInt(),
    durationMs: (json['duration_ms'] as num?)?.toInt(),
    isrc: json['isrc'] as String?,
    language: json['language'] as String?,
    explicit: (json['explicit'] as bool?) ?? false,
    sourceProvider: (json['source_provider'] as String?) ?? 'unknown',
    sourceRef: (json['source_ref'] as String?) ?? '',
    audioAssetId: json['audio_asset_id'] as String?,
    loudnessLufs: (json['loudness_lufs'] as num?)?.toDouble(),
    replaygainDb: (json['replaygain_db'] as num?)?.toDouble(),
    bpm: (json['bpm'] as num?)?.toDouble(),
    energy: (json['energy'] as num?)?.toDouble(),
    status: (json['status'] as String?) ?? 'ready',
    needsReview: (json['needs_review'] as bool?) ?? false,
    addedAt: _date(json['added_at']) ?? DateTime.now(),
    updatedAt: _date(json['updated_at']) ?? DateTime.now(),
    deletedAt: _date(json['deleted_at']),
  );

  final String id;
  final String title;
  final String titleNorm;
  final String? version;
  final AlbumRef? album;
  final List<ArtistRef> artists;
  final int? trackNo;
  final int? discNo;
  final int? durationMs;
  final String? isrc;
  final String? language;
  final bool explicit;
  final String sourceProvider;
  final String sourceRef;
  final String? audioAssetId;
  final double? loudnessLufs;
  final double? replaygainDb;
  final double? bpm;
  final double? energy;
  final String status;
  final bool needsReview;
  final DateTime addedAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  String get artistNames =>
      artists.isEmpty ? '' : artists.map((artist) => artist.name).join(', ');

  String get displayTitle => version == null ? title : '$title ($version)';

  Duration? get duration =>
      durationMs == null ? null : Duration(milliseconds: durationMs!);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'title_norm': titleNorm,
    'version': version,
    'album': album == null
        ? null
        : {
            'id': album!.id,
            'title': album!.title,
            'year': album!.year,
            'cover_asset_id': album!.coverAssetId,
          },
    'artists': artists.map((artist) => artist.toJson()).toList(),
    'track_no': trackNo,
    'disc_no': discNo,
    'duration_ms': durationMs,
    'isrc': isrc,
    'language': language,
    'explicit': explicit,
    'source_provider': sourceProvider,
    'source_ref': sourceRef,
    'audio_asset_id': audioAssetId,
    'loudness_lufs': loudnessLufs,
    'replaygain_db': replaygainDb,
    'bpm': bpm,
    'energy': energy,
    'status': status,
    'needs_review': needsReview,
    'added_at': addedAt.toUtc().toIso8601String(),
    'updated_at': updatedAt.toUtc().toIso8601String(),
    'deleted_at': deletedAt?.toUtc().toIso8601String(),
  };
}

class Page<T> {
  const Page({required this.items, this.nextCursor});

  factory Page.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) parse,
  ) {
    return Page(
      items: (json['items'] as List<dynamic>? ?? const [])
          .map((item) => parse(item as Map<String, dynamic>))
          .toList(growable: false),
      nextCursor: json['next_cursor'] as String?,
    );
  }

  final List<T> items;
  final String? nextCursor;
}

class User {
  const User({
    required this.id,
    required this.email,
    required this.timezone,
    this.displayName,
    this.settings = const {},
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    email: json['email'] as String,
    displayName: json['display_name'] as String?,
    timezone: (json['timezone'] as String?) ?? 'UTC',
    settings: (json['settings'] as Map<String, dynamic>?) ?? const {},
  );

  final String id;
  final String email;
  final String? displayName;
  final String timezone;
  final Map<String, dynamic> settings;
}

class TokenPair {
  const TokenPair({
    required this.accessToken,
    required this.refreshToken,
    required this.accessExpiresAt,
    required this.refreshExpiresAt,
  });

  factory TokenPair.fromJson(Map<String, dynamic> json) => TokenPair(
    accessToken: json['access_token'] as String,
    refreshToken: json['refresh_token'] as String,
    accessExpiresAt:
        DateTime.tryParse(json['access_expires_at'] as String? ?? '') ??
        DateTime.now().add(const Duration(minutes: 14)),
    refreshExpiresAt:
        DateTime.tryParse(json['refresh_expires_at'] as String? ?? '') ??
        DateTime.now().add(const Duration(days: 30)),
  );

  final String accessToken;
  final String refreshToken;
  final DateTime accessExpiresAt;
  final DateTime refreshExpiresAt;

  bool get isAccessExpired =>
      DateTime.now().isAfter(accessExpiresAt.subtract(const Duration(seconds: 30)));
}

class LyricWord {
  const LyricWord({required this.t, required this.text});

  factory LyricWord.fromJson(Map<String, dynamic> json) => LyricWord(
    t: (json['t'] as num?)?.toInt() ?? 0,
    text: (json['text'] as String?) ?? '',
  );

  final int t;
  final String text;
}

class LyricLine {
  const LyricLine({
    required this.t,
    required this.text,
    this.end = 0,
    this.words = const [],
  });

  factory LyricLine.fromJson(Map<String, dynamic> json) => LyricLine(
    t: (json['t'] as num?)?.toInt() ?? 0,
    end: (json['end'] as num?)?.toInt() ?? 0,
    text: (json['text'] as String?) ?? '',
    words: (json['words'] as List<dynamic>? ?? const [])
        .map((item) => LyricWord.fromJson(item as Map<String, dynamic>))
        .toList(growable: false),
  );

  final int t;
  final int end;
  final String text;
  final List<LyricWord> words;
}

class LyricsDocument {
  const LyricsDocument({
    required this.lines,
    this.kind = 'plain',
    this.source = 'manual',
    this.offsetMs = 0,
    this.plainText = '',
  });

  factory LyricsDocument.fromJson(Map<String, dynamic> json) => LyricsDocument(
    lines: (json['lines'] as List<dynamic>? ?? const [])
        .map((item) => LyricLine.fromJson(item as Map<String, dynamic>))
        .toList(growable: false),
    kind: (json['kind'] as String?) ?? 'plain',
    source: (json['source'] as String?) ?? 'manual',
    offsetMs: (json['offset_ms'] as num?)?.toInt() ?? 0,
    plainText: (json['plain_text'] as String?) ?? '',
  );

  final List<LyricLine> lines;
  final String kind;
  final String source;
  final int offsetMs;
  final String plainText;

  bool get isSynced => kind == 'synced' && lines.isNotEmpty;

  Map<String, dynamic> toJson() => {
    'kind': kind,
    'source': source,
    'offset_ms': offsetMs,
    'plain_text': plainText,
    'lines': lines
        .map(
          (line) => {
            't': line.t,
            'end': line.end,
            'text': line.text,
            if (line.words.isNotEmpty)
              'words': line.words
                  .map((word) => {'t': word.t, 'text': word.text})
                  .toList(),
          },
        )
        .toList(),
  };
}

class CoverInfo {
  const CoverInfo({
    required this.url,
    this.palette,
    this.thumbhash,
    this.expiresIn = 900,
  });

  factory CoverInfo.fromJson(Map<String, dynamic> json) => CoverInfo(
    url: json['url'] as String,
    palette: (json['palette'] as Map<String, dynamic>?)?['colors']
        ?.whereType<String>()
        .toList(growable: false),
    thumbhash: json['thumbhash'] as String?,
    expiresIn: (json['expires_in'] as num?)?.toInt() ?? 900,
  );

  final String url;
  final List<String>? palette;
  final String? thumbhash;
  final int expiresIn;
}

class StreamInfo {
  const StreamInfo({required this.url, required this.mime, this.bytes});

  factory StreamInfo.fromJson(Map<String, dynamic> json) => StreamInfo(
    url: json['url'] as String,
    mime: (json['mime'] as String?) ?? 'audio/mp4',
    bytes: (json['bytes'] as num?)?.toInt(),
  );

  final String url;
  final String mime;
  final int? bytes;
}

class Playlist {
  const Playlist({
    required this.id,
    required this.name,
    required this.kind,
    this.description,
    this.updatedAt,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String?,
    kind: (json['kind'] as String?) ?? 'manual',
    updatedAt: _date(json['updated_at']),
  );

  final String id;
  final String name;
  final String? description;
  final String kind;
  final DateTime? updatedAt;
}

class SearchResults {
  const SearchResults({
    this.tracks = const [],
    this.albums = const [],
    this.artists = const [],
  });

  factory SearchResults.fromJson(Map<String, dynamic> json) => SearchResults(
    tracks: (json['tracks'] as List<dynamic>? ?? const [])
        .map((item) => Track.fromJson(item as Map<String, dynamic>))
        .toList(growable: false),
    albums: (json['albums'] as List<dynamic>? ?? const [])
        .map((item) => Album.fromJson(item as Map<String, dynamic>))
        .toList(growable: false),
    artists: (json['artists'] as List<dynamic>? ?? const [])
        .map((item) => Artist.fromJson(item as Map<String, dynamic>))
        .toList(growable: false),
  );

  final List<Track> tracks;
  final List<Album> albums;
  final List<Artist> artists;

  bool get isEmpty => tracks.isEmpty && albums.isEmpty && artists.isEmpty;
}

DateTime? _date(Object? value) {
  if (value == null) return null;
  return DateTime.tryParse(value as String);
}

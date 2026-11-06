// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LocalTracksTable extends LocalTracks
    with TableInfo<$LocalTracksTable, LocalTrack> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalTracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleNormMeta = const VerificationMeta(
    'titleNorm',
  );
  @override
  late final GeneratedColumn<String> titleNorm = GeneratedColumn<String>(
    'title_norm',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _albumIdMeta = const VerificationMeta(
    'albumId',
  );
  @override
  late final GeneratedColumn<String> albumId = GeneratedColumn<String>(
    'album_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _albumTitleMeta = const VerificationMeta(
    'albumTitle',
  );
  @override
  late final GeneratedColumn<String> albumTitle = GeneratedColumn<String>(
    'album_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverAssetIdMeta = const VerificationMeta(
    'coverAssetId',
  );
  @override
  late final GeneratedColumn<String> coverAssetId = GeneratedColumn<String>(
    'cover_asset_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _artistNamesMeta = const VerificationMeta(
    'artistNames',
  );
  @override
  late final GeneratedColumn<String> artistNames = GeneratedColumn<String>(
    'artist_names',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _artistIdsMeta = const VerificationMeta(
    'artistIds',
  );
  @override
  late final GeneratedColumn<String> artistIds = GeneratedColumn<String>(
    'artist_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _trackNoMeta = const VerificationMeta(
    'trackNo',
  );
  @override
  late final GeneratedColumn<int> trackNo = GeneratedColumn<int>(
    'track_no',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discNoMeta = const VerificationMeta('discNo');
  @override
  late final GeneratedColumn<int> discNo = GeneratedColumn<int>(
    'disc_no',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceProviderMeta = const VerificationMeta(
    'sourceProvider',
  );
  @override
  late final GeneratedColumn<String> sourceProvider = GeneratedColumn<String>(
    'source_provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sourceRefMeta = const VerificationMeta(
    'sourceRef',
  );
  @override
  late final GeneratedColumn<String> sourceRef = GeneratedColumn<String>(
    'source_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _audioAssetIdMeta = const VerificationMeta(
    'audioAssetId',
  );
  @override
  late final GeneratedColumn<String> audioAssetId = GeneratedColumn<String>(
    'audio_asset_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loudnessLufsMeta = const VerificationMeta(
    'loudnessLufs',
  );
  @override
  late final GeneratedColumn<double> loudnessLufs = GeneratedColumn<double>(
    'loudness_lufs',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _replaygainDbMeta = const VerificationMeta(
    'replaygainDb',
  );
  @override
  late final GeneratedColumn<double> replaygainDb = GeneratedColumn<double>(
    'replaygain_db',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bpmMeta = const VerificationMeta('bpm');
  @override
  late final GeneratedColumn<double> bpm = GeneratedColumn<double>(
    'bpm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _energyMeta = const VerificationMeta('energy');
  @override
  late final GeneratedColumn<double> energy = GeneratedColumn<double>(
    'energy',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ready'),
  );
  static const VerificationMeta _explicitMeta = const VerificationMeta(
    'explicit',
  );
  @override
  late final GeneratedColumn<bool> explicit = GeneratedColumn<bool>(
    'explicit',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("explicit" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _favoriteMeta = const VerificationMeta(
    'favorite',
  );
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localAudioPathMeta = const VerificationMeta(
    'localAudioPath',
  );
  @override
  late final GeneratedColumn<String> localAudioPath = GeneratedColumn<String>(
    'local_audio_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    titleNorm,
    version,
    albumId,
    albumTitle,
    coverAssetId,
    artistNames,
    artistIds,
    trackNo,
    discNo,
    durationMs,
    sourceProvider,
    sourceRef,
    audioAssetId,
    loudnessLufs,
    replaygainDb,
    bpm,
    energy,
    status,
    explicit,
    favorite,
    addedAt,
    updatedAt,
    deletedAt,
    localAudioPath,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_tracks';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalTrack> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('title_norm')) {
      context.handle(
        _titleNormMeta,
        titleNorm.isAcceptableOrUnknown(data['title_norm']!, _titleNormMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('album_id')) {
      context.handle(
        _albumIdMeta,
        albumId.isAcceptableOrUnknown(data['album_id']!, _albumIdMeta),
      );
    }
    if (data.containsKey('album_title')) {
      context.handle(
        _albumTitleMeta,
        albumTitle.isAcceptableOrUnknown(data['album_title']!, _albumTitleMeta),
      );
    }
    if (data.containsKey('cover_asset_id')) {
      context.handle(
        _coverAssetIdMeta,
        coverAssetId.isAcceptableOrUnknown(
          data['cover_asset_id']!,
          _coverAssetIdMeta,
        ),
      );
    }
    if (data.containsKey('artist_names')) {
      context.handle(
        _artistNamesMeta,
        artistNames.isAcceptableOrUnknown(
          data['artist_names']!,
          _artistNamesMeta,
        ),
      );
    }
    if (data.containsKey('artist_ids')) {
      context.handle(
        _artistIdsMeta,
        artistIds.isAcceptableOrUnknown(data['artist_ids']!, _artistIdsMeta),
      );
    }
    if (data.containsKey('track_no')) {
      context.handle(
        _trackNoMeta,
        trackNo.isAcceptableOrUnknown(data['track_no']!, _trackNoMeta),
      );
    }
    if (data.containsKey('disc_no')) {
      context.handle(
        _discNoMeta,
        discNo.isAcceptableOrUnknown(data['disc_no']!, _discNoMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('source_provider')) {
      context.handle(
        _sourceProviderMeta,
        sourceProvider.isAcceptableOrUnknown(
          data['source_provider']!,
          _sourceProviderMeta,
        ),
      );
    }
    if (data.containsKey('source_ref')) {
      context.handle(
        _sourceRefMeta,
        sourceRef.isAcceptableOrUnknown(data['source_ref']!, _sourceRefMeta),
      );
    }
    if (data.containsKey('audio_asset_id')) {
      context.handle(
        _audioAssetIdMeta,
        audioAssetId.isAcceptableOrUnknown(
          data['audio_asset_id']!,
          _audioAssetIdMeta,
        ),
      );
    }
    if (data.containsKey('loudness_lufs')) {
      context.handle(
        _loudnessLufsMeta,
        loudnessLufs.isAcceptableOrUnknown(
          data['loudness_lufs']!,
          _loudnessLufsMeta,
        ),
      );
    }
    if (data.containsKey('replaygain_db')) {
      context.handle(
        _replaygainDbMeta,
        replaygainDb.isAcceptableOrUnknown(
          data['replaygain_db']!,
          _replaygainDbMeta,
        ),
      );
    }
    if (data.containsKey('bpm')) {
      context.handle(
        _bpmMeta,
        bpm.isAcceptableOrUnknown(data['bpm']!, _bpmMeta),
      );
    }
    if (data.containsKey('energy')) {
      context.handle(
        _energyMeta,
        energy.isAcceptableOrUnknown(data['energy']!, _energyMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('explicit')) {
      context.handle(
        _explicitMeta,
        explicit.isAcceptableOrUnknown(data['explicit']!, _explicitMeta),
      );
    }
    if (data.containsKey('favorite')) {
      context.handle(
        _favoriteMeta,
        favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('local_audio_path')) {
      context.handle(
        _localAudioPathMeta,
        localAudioPath.isAcceptableOrUnknown(
          data['local_audio_path']!,
          _localAudioPathMeta,
        ),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalTrack map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalTrack(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      titleNorm: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_norm'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      ),
      albumId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album_id'],
      ),
      albumTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album_title'],
      ),
      coverAssetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_asset_id'],
      ),
      artistNames: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist_names'],
      )!,
      artistIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist_ids'],
      )!,
      trackNo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_no'],
      ),
      discNo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}disc_no'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      sourceProvider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_provider'],
      )!,
      sourceRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_ref'],
      )!,
      audioAssetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_asset_id'],
      ),
      loudnessLufs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}loudness_lufs'],
      ),
      replaygainDb: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}replaygain_db'],
      ),
      bpm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bpm'],
      ),
      energy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}energy'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      explicit: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}explicit'],
      )!,
      favorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}favorite'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      localAudioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_audio_path'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $LocalTracksTable createAlias(String alias) {
    return $LocalTracksTable(attachedDatabase, alias);
  }
}

class LocalTrack extends DataClass implements Insertable<LocalTrack> {
  final String id;
  final String title;
  final String titleNorm;
  final String? version;
  final String? albumId;
  final String? albumTitle;
  final String? coverAssetId;
  final String artistNames;
  final String artistIds;
  final int? trackNo;
  final int? discNo;
  final int? durationMs;
  final String sourceProvider;
  final String sourceRef;
  final String? audioAssetId;
  final double? loudnessLufs;
  final double? replaygainDb;
  final double? bpm;
  final double? energy;
  final String status;
  final bool explicit;
  final bool favorite;
  final DateTime addedAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? localAudioPath;
  final DateTime cachedAt;
  const LocalTrack({
    required this.id,
    required this.title,
    required this.titleNorm,
    this.version,
    this.albumId,
    this.albumTitle,
    this.coverAssetId,
    required this.artistNames,
    required this.artistIds,
    this.trackNo,
    this.discNo,
    this.durationMs,
    required this.sourceProvider,
    required this.sourceRef,
    this.audioAssetId,
    this.loudnessLufs,
    this.replaygainDb,
    this.bpm,
    this.energy,
    required this.status,
    required this.explicit,
    required this.favorite,
    required this.addedAt,
    required this.updatedAt,
    this.deletedAt,
    this.localAudioPath,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['title_norm'] = Variable<String>(titleNorm);
    if (!nullToAbsent || version != null) {
      map['version'] = Variable<String>(version);
    }
    if (!nullToAbsent || albumId != null) {
      map['album_id'] = Variable<String>(albumId);
    }
    if (!nullToAbsent || albumTitle != null) {
      map['album_title'] = Variable<String>(albumTitle);
    }
    if (!nullToAbsent || coverAssetId != null) {
      map['cover_asset_id'] = Variable<String>(coverAssetId);
    }
    map['artist_names'] = Variable<String>(artistNames);
    map['artist_ids'] = Variable<String>(artistIds);
    if (!nullToAbsent || trackNo != null) {
      map['track_no'] = Variable<int>(trackNo);
    }
    if (!nullToAbsent || discNo != null) {
      map['disc_no'] = Variable<int>(discNo);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    map['source_provider'] = Variable<String>(sourceProvider);
    map['source_ref'] = Variable<String>(sourceRef);
    if (!nullToAbsent || audioAssetId != null) {
      map['audio_asset_id'] = Variable<String>(audioAssetId);
    }
    if (!nullToAbsent || loudnessLufs != null) {
      map['loudness_lufs'] = Variable<double>(loudnessLufs);
    }
    if (!nullToAbsent || replaygainDb != null) {
      map['replaygain_db'] = Variable<double>(replaygainDb);
    }
    if (!nullToAbsent || bpm != null) {
      map['bpm'] = Variable<double>(bpm);
    }
    if (!nullToAbsent || energy != null) {
      map['energy'] = Variable<double>(energy);
    }
    map['status'] = Variable<String>(status);
    map['explicit'] = Variable<bool>(explicit);
    map['favorite'] = Variable<bool>(favorite);
    map['added_at'] = Variable<DateTime>(addedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || localAudioPath != null) {
      map['local_audio_path'] = Variable<String>(localAudioPath);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  LocalTracksCompanion toCompanion(bool nullToAbsent) {
    return LocalTracksCompanion(
      id: Value(id),
      title: Value(title),
      titleNorm: Value(titleNorm),
      version: version == null && nullToAbsent
          ? const Value.absent()
          : Value(version),
      albumId: albumId == null && nullToAbsent
          ? const Value.absent()
          : Value(albumId),
      albumTitle: albumTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(albumTitle),
      coverAssetId: coverAssetId == null && nullToAbsent
          ? const Value.absent()
          : Value(coverAssetId),
      artistNames: Value(artistNames),
      artistIds: Value(artistIds),
      trackNo: trackNo == null && nullToAbsent
          ? const Value.absent()
          : Value(trackNo),
      discNo: discNo == null && nullToAbsent
          ? const Value.absent()
          : Value(discNo),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      sourceProvider: Value(sourceProvider),
      sourceRef: Value(sourceRef),
      audioAssetId: audioAssetId == null && nullToAbsent
          ? const Value.absent()
          : Value(audioAssetId),
      loudnessLufs: loudnessLufs == null && nullToAbsent
          ? const Value.absent()
          : Value(loudnessLufs),
      replaygainDb: replaygainDb == null && nullToAbsent
          ? const Value.absent()
          : Value(replaygainDb),
      bpm: bpm == null && nullToAbsent ? const Value.absent() : Value(bpm),
      energy: energy == null && nullToAbsent
          ? const Value.absent()
          : Value(energy),
      status: Value(status),
      explicit: Value(explicit),
      favorite: Value(favorite),
      addedAt: Value(addedAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      localAudioPath: localAudioPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localAudioPath),
      cachedAt: Value(cachedAt),
    );
  }

  factory LocalTrack.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalTrack(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      titleNorm: serializer.fromJson<String>(json['titleNorm']),
      version: serializer.fromJson<String?>(json['version']),
      albumId: serializer.fromJson<String?>(json['albumId']),
      albumTitle: serializer.fromJson<String?>(json['albumTitle']),
      coverAssetId: serializer.fromJson<String?>(json['coverAssetId']),
      artistNames: serializer.fromJson<String>(json['artistNames']),
      artistIds: serializer.fromJson<String>(json['artistIds']),
      trackNo: serializer.fromJson<int?>(json['trackNo']),
      discNo: serializer.fromJson<int?>(json['discNo']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      sourceProvider: serializer.fromJson<String>(json['sourceProvider']),
      sourceRef: serializer.fromJson<String>(json['sourceRef']),
      audioAssetId: serializer.fromJson<String?>(json['audioAssetId']),
      loudnessLufs: serializer.fromJson<double?>(json['loudnessLufs']),
      replaygainDb: serializer.fromJson<double?>(json['replaygainDb']),
      bpm: serializer.fromJson<double?>(json['bpm']),
      energy: serializer.fromJson<double?>(json['energy']),
      status: serializer.fromJson<String>(json['status']),
      explicit: serializer.fromJson<bool>(json['explicit']),
      favorite: serializer.fromJson<bool>(json['favorite']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      localAudioPath: serializer.fromJson<String?>(json['localAudioPath']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'titleNorm': serializer.toJson<String>(titleNorm),
      'version': serializer.toJson<String?>(version),
      'albumId': serializer.toJson<String?>(albumId),
      'albumTitle': serializer.toJson<String?>(albumTitle),
      'coverAssetId': serializer.toJson<String?>(coverAssetId),
      'artistNames': serializer.toJson<String>(artistNames),
      'artistIds': serializer.toJson<String>(artistIds),
      'trackNo': serializer.toJson<int?>(trackNo),
      'discNo': serializer.toJson<int?>(discNo),
      'durationMs': serializer.toJson<int?>(durationMs),
      'sourceProvider': serializer.toJson<String>(sourceProvider),
      'sourceRef': serializer.toJson<String>(sourceRef),
      'audioAssetId': serializer.toJson<String?>(audioAssetId),
      'loudnessLufs': serializer.toJson<double?>(loudnessLufs),
      'replaygainDb': serializer.toJson<double?>(replaygainDb),
      'bpm': serializer.toJson<double?>(bpm),
      'energy': serializer.toJson<double?>(energy),
      'status': serializer.toJson<String>(status),
      'explicit': serializer.toJson<bool>(explicit),
      'favorite': serializer.toJson<bool>(favorite),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'localAudioPath': serializer.toJson<String?>(localAudioPath),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  LocalTrack copyWith({
    String? id,
    String? title,
    String? titleNorm,
    Value<String?> version = const Value.absent(),
    Value<String?> albumId = const Value.absent(),
    Value<String?> albumTitle = const Value.absent(),
    Value<String?> coverAssetId = const Value.absent(),
    String? artistNames,
    String? artistIds,
    Value<int?> trackNo = const Value.absent(),
    Value<int?> discNo = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    String? sourceProvider,
    String? sourceRef,
    Value<String?> audioAssetId = const Value.absent(),
    Value<double?> loudnessLufs = const Value.absent(),
    Value<double?> replaygainDb = const Value.absent(),
    Value<double?> bpm = const Value.absent(),
    Value<double?> energy = const Value.absent(),
    String? status,
    bool? explicit,
    bool? favorite,
    DateTime? addedAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> localAudioPath = const Value.absent(),
    DateTime? cachedAt,
  }) => LocalTrack(
    id: id ?? this.id,
    title: title ?? this.title,
    titleNorm: titleNorm ?? this.titleNorm,
    version: version.present ? version.value : this.version,
    albumId: albumId.present ? albumId.value : this.albumId,
    albumTitle: albumTitle.present ? albumTitle.value : this.albumTitle,
    coverAssetId: coverAssetId.present ? coverAssetId.value : this.coverAssetId,
    artistNames: artistNames ?? this.artistNames,
    artistIds: artistIds ?? this.artistIds,
    trackNo: trackNo.present ? trackNo.value : this.trackNo,
    discNo: discNo.present ? discNo.value : this.discNo,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    sourceProvider: sourceProvider ?? this.sourceProvider,
    sourceRef: sourceRef ?? this.sourceRef,
    audioAssetId: audioAssetId.present ? audioAssetId.value : this.audioAssetId,
    loudnessLufs: loudnessLufs.present ? loudnessLufs.value : this.loudnessLufs,
    replaygainDb: replaygainDb.present ? replaygainDb.value : this.replaygainDb,
    bpm: bpm.present ? bpm.value : this.bpm,
    energy: energy.present ? energy.value : this.energy,
    status: status ?? this.status,
    explicit: explicit ?? this.explicit,
    favorite: favorite ?? this.favorite,
    addedAt: addedAt ?? this.addedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    localAudioPath: localAudioPath.present
        ? localAudioPath.value
        : this.localAudioPath,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  LocalTrack copyWithCompanion(LocalTracksCompanion data) {
    return LocalTrack(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      titleNorm: data.titleNorm.present ? data.titleNorm.value : this.titleNorm,
      version: data.version.present ? data.version.value : this.version,
      albumId: data.albumId.present ? data.albumId.value : this.albumId,
      albumTitle: data.albumTitle.present
          ? data.albumTitle.value
          : this.albumTitle,
      coverAssetId: data.coverAssetId.present
          ? data.coverAssetId.value
          : this.coverAssetId,
      artistNames: data.artistNames.present
          ? data.artistNames.value
          : this.artistNames,
      artistIds: data.artistIds.present ? data.artistIds.value : this.artistIds,
      trackNo: data.trackNo.present ? data.trackNo.value : this.trackNo,
      discNo: data.discNo.present ? data.discNo.value : this.discNo,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      sourceProvider: data.sourceProvider.present
          ? data.sourceProvider.value
          : this.sourceProvider,
      sourceRef: data.sourceRef.present ? data.sourceRef.value : this.sourceRef,
      audioAssetId: data.audioAssetId.present
          ? data.audioAssetId.value
          : this.audioAssetId,
      loudnessLufs: data.loudnessLufs.present
          ? data.loudnessLufs.value
          : this.loudnessLufs,
      replaygainDb: data.replaygainDb.present
          ? data.replaygainDb.value
          : this.replaygainDb,
      bpm: data.bpm.present ? data.bpm.value : this.bpm,
      energy: data.energy.present ? data.energy.value : this.energy,
      status: data.status.present ? data.status.value : this.status,
      explicit: data.explicit.present ? data.explicit.value : this.explicit,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      localAudioPath: data.localAudioPath.present
          ? data.localAudioPath.value
          : this.localAudioPath,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalTrack(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleNorm: $titleNorm, ')
          ..write('version: $version, ')
          ..write('albumId: $albumId, ')
          ..write('albumTitle: $albumTitle, ')
          ..write('coverAssetId: $coverAssetId, ')
          ..write('artistNames: $artistNames, ')
          ..write('artistIds: $artistIds, ')
          ..write('trackNo: $trackNo, ')
          ..write('discNo: $discNo, ')
          ..write('durationMs: $durationMs, ')
          ..write('sourceProvider: $sourceProvider, ')
          ..write('sourceRef: $sourceRef, ')
          ..write('audioAssetId: $audioAssetId, ')
          ..write('loudnessLufs: $loudnessLufs, ')
          ..write('replaygainDb: $replaygainDb, ')
          ..write('bpm: $bpm, ')
          ..write('energy: $energy, ')
          ..write('status: $status, ')
          ..write('explicit: $explicit, ')
          ..write('favorite: $favorite, ')
          ..write('addedAt: $addedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('localAudioPath: $localAudioPath, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    title,
    titleNorm,
    version,
    albumId,
    albumTitle,
    coverAssetId,
    artistNames,
    artistIds,
    trackNo,
    discNo,
    durationMs,
    sourceProvider,
    sourceRef,
    audioAssetId,
    loudnessLufs,
    replaygainDb,
    bpm,
    energy,
    status,
    explicit,
    favorite,
    addedAt,
    updatedAt,
    deletedAt,
    localAudioPath,
    cachedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalTrack &&
          other.id == this.id &&
          other.title == this.title &&
          other.titleNorm == this.titleNorm &&
          other.version == this.version &&
          other.albumId == this.albumId &&
          other.albumTitle == this.albumTitle &&
          other.coverAssetId == this.coverAssetId &&
          other.artistNames == this.artistNames &&
          other.artistIds == this.artistIds &&
          other.trackNo == this.trackNo &&
          other.discNo == this.discNo &&
          other.durationMs == this.durationMs &&
          other.sourceProvider == this.sourceProvider &&
          other.sourceRef == this.sourceRef &&
          other.audioAssetId == this.audioAssetId &&
          other.loudnessLufs == this.loudnessLufs &&
          other.replaygainDb == this.replaygainDb &&
          other.bpm == this.bpm &&
          other.energy == this.energy &&
          other.status == this.status &&
          other.explicit == this.explicit &&
          other.favorite == this.favorite &&
          other.addedAt == this.addedAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.localAudioPath == this.localAudioPath &&
          other.cachedAt == this.cachedAt);
}

class LocalTracksCompanion extends UpdateCompanion<LocalTrack> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> titleNorm;
  final Value<String?> version;
  final Value<String?> albumId;
  final Value<String?> albumTitle;
  final Value<String?> coverAssetId;
  final Value<String> artistNames;
  final Value<String> artistIds;
  final Value<int?> trackNo;
  final Value<int?> discNo;
  final Value<int?> durationMs;
  final Value<String> sourceProvider;
  final Value<String> sourceRef;
  final Value<String?> audioAssetId;
  final Value<double?> loudnessLufs;
  final Value<double?> replaygainDb;
  final Value<double?> bpm;
  final Value<double?> energy;
  final Value<String> status;
  final Value<bool> explicit;
  final Value<bool> favorite;
  final Value<DateTime> addedAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> localAudioPath;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const LocalTracksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.titleNorm = const Value.absent(),
    this.version = const Value.absent(),
    this.albumId = const Value.absent(),
    this.albumTitle = const Value.absent(),
    this.coverAssetId = const Value.absent(),
    this.artistNames = const Value.absent(),
    this.artistIds = const Value.absent(),
    this.trackNo = const Value.absent(),
    this.discNo = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.sourceProvider = const Value.absent(),
    this.sourceRef = const Value.absent(),
    this.audioAssetId = const Value.absent(),
    this.loudnessLufs = const Value.absent(),
    this.replaygainDb = const Value.absent(),
    this.bpm = const Value.absent(),
    this.energy = const Value.absent(),
    this.status = const Value.absent(),
    this.explicit = const Value.absent(),
    this.favorite = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.localAudioPath = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalTracksCompanion.insert({
    required String id,
    required String title,
    this.titleNorm = const Value.absent(),
    this.version = const Value.absent(),
    this.albumId = const Value.absent(),
    this.albumTitle = const Value.absent(),
    this.coverAssetId = const Value.absent(),
    this.artistNames = const Value.absent(),
    this.artistIds = const Value.absent(),
    this.trackNo = const Value.absent(),
    this.discNo = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.sourceProvider = const Value.absent(),
    this.sourceRef = const Value.absent(),
    this.audioAssetId = const Value.absent(),
    this.loudnessLufs = const Value.absent(),
    this.replaygainDb = const Value.absent(),
    this.bpm = const Value.absent(),
    this.energy = const Value.absent(),
    this.status = const Value.absent(),
    this.explicit = const Value.absent(),
    this.favorite = const Value.absent(),
    required DateTime addedAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.localAudioPath = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       addedAt = Value(addedAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalTrack> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? titleNorm,
    Expression<String>? version,
    Expression<String>? albumId,
    Expression<String>? albumTitle,
    Expression<String>? coverAssetId,
    Expression<String>? artistNames,
    Expression<String>? artistIds,
    Expression<int>? trackNo,
    Expression<int>? discNo,
    Expression<int>? durationMs,
    Expression<String>? sourceProvider,
    Expression<String>? sourceRef,
    Expression<String>? audioAssetId,
    Expression<double>? loudnessLufs,
    Expression<double>? replaygainDb,
    Expression<double>? bpm,
    Expression<double>? energy,
    Expression<String>? status,
    Expression<bool>? explicit,
    Expression<bool>? favorite,
    Expression<DateTime>? addedAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? localAudioPath,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (titleNorm != null) 'title_norm': titleNorm,
      if (version != null) 'version': version,
      if (albumId != null) 'album_id': albumId,
      if (albumTitle != null) 'album_title': albumTitle,
      if (coverAssetId != null) 'cover_asset_id': coverAssetId,
      if (artistNames != null) 'artist_names': artistNames,
      if (artistIds != null) 'artist_ids': artistIds,
      if (trackNo != null) 'track_no': trackNo,
      if (discNo != null) 'disc_no': discNo,
      if (durationMs != null) 'duration_ms': durationMs,
      if (sourceProvider != null) 'source_provider': sourceProvider,
      if (sourceRef != null) 'source_ref': sourceRef,
      if (audioAssetId != null) 'audio_asset_id': audioAssetId,
      if (loudnessLufs != null) 'loudness_lufs': loudnessLufs,
      if (replaygainDb != null) 'replaygain_db': replaygainDb,
      if (bpm != null) 'bpm': bpm,
      if (energy != null) 'energy': energy,
      if (status != null) 'status': status,
      if (explicit != null) 'explicit': explicit,
      if (favorite != null) 'favorite': favorite,
      if (addedAt != null) 'added_at': addedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (localAudioPath != null) 'local_audio_path': localAudioPath,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalTracksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? titleNorm,
    Value<String?>? version,
    Value<String?>? albumId,
    Value<String?>? albumTitle,
    Value<String?>? coverAssetId,
    Value<String>? artistNames,
    Value<String>? artistIds,
    Value<int?>? trackNo,
    Value<int?>? discNo,
    Value<int?>? durationMs,
    Value<String>? sourceProvider,
    Value<String>? sourceRef,
    Value<String?>? audioAssetId,
    Value<double?>? loudnessLufs,
    Value<double?>? replaygainDb,
    Value<double?>? bpm,
    Value<double?>? energy,
    Value<String>? status,
    Value<bool>? explicit,
    Value<bool>? favorite,
    Value<DateTime>? addedAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? localAudioPath,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return LocalTracksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      titleNorm: titleNorm ?? this.titleNorm,
      version: version ?? this.version,
      albumId: albumId ?? this.albumId,
      albumTitle: albumTitle ?? this.albumTitle,
      coverAssetId: coverAssetId ?? this.coverAssetId,
      artistNames: artistNames ?? this.artistNames,
      artistIds: artistIds ?? this.artistIds,
      trackNo: trackNo ?? this.trackNo,
      discNo: discNo ?? this.discNo,
      durationMs: durationMs ?? this.durationMs,
      sourceProvider: sourceProvider ?? this.sourceProvider,
      sourceRef: sourceRef ?? this.sourceRef,
      audioAssetId: audioAssetId ?? this.audioAssetId,
      loudnessLufs: loudnessLufs ?? this.loudnessLufs,
      replaygainDb: replaygainDb ?? this.replaygainDb,
      bpm: bpm ?? this.bpm,
      energy: energy ?? this.energy,
      status: status ?? this.status,
      explicit: explicit ?? this.explicit,
      favorite: favorite ?? this.favorite,
      addedAt: addedAt ?? this.addedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      localAudioPath: localAudioPath ?? this.localAudioPath,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (titleNorm.present) {
      map['title_norm'] = Variable<String>(titleNorm.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (albumId.present) {
      map['album_id'] = Variable<String>(albumId.value);
    }
    if (albumTitle.present) {
      map['album_title'] = Variable<String>(albumTitle.value);
    }
    if (coverAssetId.present) {
      map['cover_asset_id'] = Variable<String>(coverAssetId.value);
    }
    if (artistNames.present) {
      map['artist_names'] = Variable<String>(artistNames.value);
    }
    if (artistIds.present) {
      map['artist_ids'] = Variable<String>(artistIds.value);
    }
    if (trackNo.present) {
      map['track_no'] = Variable<int>(trackNo.value);
    }
    if (discNo.present) {
      map['disc_no'] = Variable<int>(discNo.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (sourceProvider.present) {
      map['source_provider'] = Variable<String>(sourceProvider.value);
    }
    if (sourceRef.present) {
      map['source_ref'] = Variable<String>(sourceRef.value);
    }
    if (audioAssetId.present) {
      map['audio_asset_id'] = Variable<String>(audioAssetId.value);
    }
    if (loudnessLufs.present) {
      map['loudness_lufs'] = Variable<double>(loudnessLufs.value);
    }
    if (replaygainDb.present) {
      map['replaygain_db'] = Variable<double>(replaygainDb.value);
    }
    if (bpm.present) {
      map['bpm'] = Variable<double>(bpm.value);
    }
    if (energy.present) {
      map['energy'] = Variable<double>(energy.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (explicit.present) {
      map['explicit'] = Variable<bool>(explicit.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (localAudioPath.present) {
      map['local_audio_path'] = Variable<String>(localAudioPath.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalTracksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleNorm: $titleNorm, ')
          ..write('version: $version, ')
          ..write('albumId: $albumId, ')
          ..write('albumTitle: $albumTitle, ')
          ..write('coverAssetId: $coverAssetId, ')
          ..write('artistNames: $artistNames, ')
          ..write('artistIds: $artistIds, ')
          ..write('trackNo: $trackNo, ')
          ..write('discNo: $discNo, ')
          ..write('durationMs: $durationMs, ')
          ..write('sourceProvider: $sourceProvider, ')
          ..write('sourceRef: $sourceRef, ')
          ..write('audioAssetId: $audioAssetId, ')
          ..write('loudnessLufs: $loudnessLufs, ')
          ..write('replaygainDb: $replaygainDb, ')
          ..write('bpm: $bpm, ')
          ..write('energy: $energy, ')
          ..write('status: $status, ')
          ..write('explicit: $explicit, ')
          ..write('favorite: $favorite, ')
          ..write('addedAt: $addedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('localAudioPath: $localAudioPath, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalAlbumsTable extends LocalAlbums
    with TableInfo<$LocalAlbumsTable, LocalAlbum> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalAlbumsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleNormMeta = const VerificationMeta(
    'titleNorm',
  );
  @override
  late final GeneratedColumn<String> titleNorm = GeneratedColumn<String>(
    'title_norm',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverAssetIdMeta = const VerificationMeta(
    'coverAssetId',
  );
  @override
  late final GeneratedColumn<String> coverAssetId = GeneratedColumn<String>(
    'cover_asset_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _albumArtistIdMeta = const VerificationMeta(
    'albumArtistId',
  );
  @override
  late final GeneratedColumn<String> albumArtistId = GeneratedColumn<String>(
    'album_artist_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _albumArtistNameMeta = const VerificationMeta(
    'albumArtistName',
  );
  @override
  late final GeneratedColumn<String> albumArtistName = GeneratedColumn<String>(
    'album_artist_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalTracksMeta = const VerificationMeta(
    'totalTracks',
  );
  @override
  late final GeneratedColumn<int> totalTracks = GeneratedColumn<int>(
    'total_tracks',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    titleNorm,
    year,
    coverAssetId,
    albumArtistId,
    albumArtistName,
    totalTracks,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_albums';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalAlbum> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('title_norm')) {
      context.handle(
        _titleNormMeta,
        titleNorm.isAcceptableOrUnknown(data['title_norm']!, _titleNormMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('cover_asset_id')) {
      context.handle(
        _coverAssetIdMeta,
        coverAssetId.isAcceptableOrUnknown(
          data['cover_asset_id']!,
          _coverAssetIdMeta,
        ),
      );
    }
    if (data.containsKey('album_artist_id')) {
      context.handle(
        _albumArtistIdMeta,
        albumArtistId.isAcceptableOrUnknown(
          data['album_artist_id']!,
          _albumArtistIdMeta,
        ),
      );
    }
    if (data.containsKey('album_artist_name')) {
      context.handle(
        _albumArtistNameMeta,
        albumArtistName.isAcceptableOrUnknown(
          data['album_artist_name']!,
          _albumArtistNameMeta,
        ),
      );
    }
    if (data.containsKey('total_tracks')) {
      context.handle(
        _totalTracksMeta,
        totalTracks.isAcceptableOrUnknown(
          data['total_tracks']!,
          _totalTracksMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalAlbum map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalAlbum(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      titleNorm: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_norm'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      coverAssetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_asset_id'],
      ),
      albumArtistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album_artist_id'],
      ),
      albumArtistName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album_artist_name'],
      ),
      totalTracks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_tracks'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalAlbumsTable createAlias(String alias) {
    return $LocalAlbumsTable(attachedDatabase, alias);
  }
}

class LocalAlbum extends DataClass implements Insertable<LocalAlbum> {
  final String id;
  final String title;
  final String titleNorm;
  final int? year;
  final String? coverAssetId;
  final String? albumArtistId;
  final String? albumArtistName;
  final int? totalTracks;
  final DateTime updatedAt;
  const LocalAlbum({
    required this.id,
    required this.title,
    required this.titleNorm,
    this.year,
    this.coverAssetId,
    this.albumArtistId,
    this.albumArtistName,
    this.totalTracks,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['title_norm'] = Variable<String>(titleNorm);
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || coverAssetId != null) {
      map['cover_asset_id'] = Variable<String>(coverAssetId);
    }
    if (!nullToAbsent || albumArtistId != null) {
      map['album_artist_id'] = Variable<String>(albumArtistId);
    }
    if (!nullToAbsent || albumArtistName != null) {
      map['album_artist_name'] = Variable<String>(albumArtistName);
    }
    if (!nullToAbsent || totalTracks != null) {
      map['total_tracks'] = Variable<int>(totalTracks);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalAlbumsCompanion toCompanion(bool nullToAbsent) {
    return LocalAlbumsCompanion(
      id: Value(id),
      title: Value(title),
      titleNorm: Value(titleNorm),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      coverAssetId: coverAssetId == null && nullToAbsent
          ? const Value.absent()
          : Value(coverAssetId),
      albumArtistId: albumArtistId == null && nullToAbsent
          ? const Value.absent()
          : Value(albumArtistId),
      albumArtistName: albumArtistName == null && nullToAbsent
          ? const Value.absent()
          : Value(albumArtistName),
      totalTracks: totalTracks == null && nullToAbsent
          ? const Value.absent()
          : Value(totalTracks),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalAlbum.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalAlbum(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      titleNorm: serializer.fromJson<String>(json['titleNorm']),
      year: serializer.fromJson<int?>(json['year']),
      coverAssetId: serializer.fromJson<String?>(json['coverAssetId']),
      albumArtistId: serializer.fromJson<String?>(json['albumArtistId']),
      albumArtistName: serializer.fromJson<String?>(json['albumArtistName']),
      totalTracks: serializer.fromJson<int?>(json['totalTracks']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'titleNorm': serializer.toJson<String>(titleNorm),
      'year': serializer.toJson<int?>(year),
      'coverAssetId': serializer.toJson<String?>(coverAssetId),
      'albumArtistId': serializer.toJson<String?>(albumArtistId),
      'albumArtistName': serializer.toJson<String?>(albumArtistName),
      'totalTracks': serializer.toJson<int?>(totalTracks),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalAlbum copyWith({
    String? id,
    String? title,
    String? titleNorm,
    Value<int?> year = const Value.absent(),
    Value<String?> coverAssetId = const Value.absent(),
    Value<String?> albumArtistId = const Value.absent(),
    Value<String?> albumArtistName = const Value.absent(),
    Value<int?> totalTracks = const Value.absent(),
    DateTime? updatedAt,
  }) => LocalAlbum(
    id: id ?? this.id,
    title: title ?? this.title,
    titleNorm: titleNorm ?? this.titleNorm,
    year: year.present ? year.value : this.year,
    coverAssetId: coverAssetId.present ? coverAssetId.value : this.coverAssetId,
    albumArtistId: albumArtistId.present
        ? albumArtistId.value
        : this.albumArtistId,
    albumArtistName: albumArtistName.present
        ? albumArtistName.value
        : this.albumArtistName,
    totalTracks: totalTracks.present ? totalTracks.value : this.totalTracks,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalAlbum copyWithCompanion(LocalAlbumsCompanion data) {
    return LocalAlbum(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      titleNorm: data.titleNorm.present ? data.titleNorm.value : this.titleNorm,
      year: data.year.present ? data.year.value : this.year,
      coverAssetId: data.coverAssetId.present
          ? data.coverAssetId.value
          : this.coverAssetId,
      albumArtistId: data.albumArtistId.present
          ? data.albumArtistId.value
          : this.albumArtistId,
      albumArtistName: data.albumArtistName.present
          ? data.albumArtistName.value
          : this.albumArtistName,
      totalTracks: data.totalTracks.present
          ? data.totalTracks.value
          : this.totalTracks,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalAlbum(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleNorm: $titleNorm, ')
          ..write('year: $year, ')
          ..write('coverAssetId: $coverAssetId, ')
          ..write('albumArtistId: $albumArtistId, ')
          ..write('albumArtistName: $albumArtistName, ')
          ..write('totalTracks: $totalTracks, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    titleNorm,
    year,
    coverAssetId,
    albumArtistId,
    albumArtistName,
    totalTracks,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalAlbum &&
          other.id == this.id &&
          other.title == this.title &&
          other.titleNorm == this.titleNorm &&
          other.year == this.year &&
          other.coverAssetId == this.coverAssetId &&
          other.albumArtistId == this.albumArtistId &&
          other.albumArtistName == this.albumArtistName &&
          other.totalTracks == this.totalTracks &&
          other.updatedAt == this.updatedAt);
}

class LocalAlbumsCompanion extends UpdateCompanion<LocalAlbum> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> titleNorm;
  final Value<int?> year;
  final Value<String?> coverAssetId;
  final Value<String?> albumArtistId;
  final Value<String?> albumArtistName;
  final Value<int?> totalTracks;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalAlbumsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.titleNorm = const Value.absent(),
    this.year = const Value.absent(),
    this.coverAssetId = const Value.absent(),
    this.albumArtistId = const Value.absent(),
    this.albumArtistName = const Value.absent(),
    this.totalTracks = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalAlbumsCompanion.insert({
    required String id,
    required String title,
    this.titleNorm = const Value.absent(),
    this.year = const Value.absent(),
    this.coverAssetId = const Value.absent(),
    this.albumArtistId = const Value.absent(),
    this.albumArtistName = const Value.absent(),
    this.totalTracks = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title);
  static Insertable<LocalAlbum> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? titleNorm,
    Expression<int>? year,
    Expression<String>? coverAssetId,
    Expression<String>? albumArtistId,
    Expression<String>? albumArtistName,
    Expression<int>? totalTracks,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (titleNorm != null) 'title_norm': titleNorm,
      if (year != null) 'year': year,
      if (coverAssetId != null) 'cover_asset_id': coverAssetId,
      if (albumArtistId != null) 'album_artist_id': albumArtistId,
      if (albumArtistName != null) 'album_artist_name': albumArtistName,
      if (totalTracks != null) 'total_tracks': totalTracks,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalAlbumsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? titleNorm,
    Value<int?>? year,
    Value<String?>? coverAssetId,
    Value<String?>? albumArtistId,
    Value<String?>? albumArtistName,
    Value<int?>? totalTracks,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalAlbumsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      titleNorm: titleNorm ?? this.titleNorm,
      year: year ?? this.year,
      coverAssetId: coverAssetId ?? this.coverAssetId,
      albumArtistId: albumArtistId ?? this.albumArtistId,
      albumArtistName: albumArtistName ?? this.albumArtistName,
      totalTracks: totalTracks ?? this.totalTracks,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (titleNorm.present) {
      map['title_norm'] = Variable<String>(titleNorm.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (coverAssetId.present) {
      map['cover_asset_id'] = Variable<String>(coverAssetId.value);
    }
    if (albumArtistId.present) {
      map['album_artist_id'] = Variable<String>(albumArtistId.value);
    }
    if (albumArtistName.present) {
      map['album_artist_name'] = Variable<String>(albumArtistName.value);
    }
    if (totalTracks.present) {
      map['total_tracks'] = Variable<int>(totalTracks.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalAlbumsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleNorm: $titleNorm, ')
          ..write('year: $year, ')
          ..write('coverAssetId: $coverAssetId, ')
          ..write('albumArtistId: $albumArtistId, ')
          ..write('albumArtistName: $albumArtistName, ')
          ..write('totalTracks: $totalTracks, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalArtistsTable extends LocalArtists
    with TableInfo<$LocalArtistsTable, LocalArtist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalArtistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameNormMeta = const VerificationMeta(
    'nameNorm',
  );
  @override
  late final GeneratedColumn<String> nameNorm = GeneratedColumn<String>(
    'name_norm',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sortNameMeta = const VerificationMeta(
    'sortName',
  );
  @override
  late final GeneratedColumn<String> sortName = GeneratedColumn<String>(
    'sort_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageAssetIdMeta = const VerificationMeta(
    'imageAssetId',
  );
  @override
  late final GeneratedColumn<String> imageAssetId = GeneratedColumn<String>(
    'image_asset_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameNorm,
    sortName,
    imageAssetId,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_artists';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalArtist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_norm')) {
      context.handle(
        _nameNormMeta,
        nameNorm.isAcceptableOrUnknown(data['name_norm']!, _nameNormMeta),
      );
    }
    if (data.containsKey('sort_name')) {
      context.handle(
        _sortNameMeta,
        sortName.isAcceptableOrUnknown(data['sort_name']!, _sortNameMeta),
      );
    }
    if (data.containsKey('image_asset_id')) {
      context.handle(
        _imageAssetIdMeta,
        imageAssetId.isAcceptableOrUnknown(
          data['image_asset_id']!,
          _imageAssetIdMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalArtist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalArtist(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameNorm: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_norm'],
      )!,
      sortName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sort_name'],
      ),
      imageAssetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_asset_id'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalArtistsTable createAlias(String alias) {
    return $LocalArtistsTable(attachedDatabase, alias);
  }
}

class LocalArtist extends DataClass implements Insertable<LocalArtist> {
  final String id;
  final String name;
  final String nameNorm;
  final String? sortName;
  final String? imageAssetId;
  final DateTime updatedAt;
  const LocalArtist({
    required this.id,
    required this.name,
    required this.nameNorm,
    this.sortName,
    this.imageAssetId,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['name_norm'] = Variable<String>(nameNorm);
    if (!nullToAbsent || sortName != null) {
      map['sort_name'] = Variable<String>(sortName);
    }
    if (!nullToAbsent || imageAssetId != null) {
      map['image_asset_id'] = Variable<String>(imageAssetId);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalArtistsCompanion toCompanion(bool nullToAbsent) {
    return LocalArtistsCompanion(
      id: Value(id),
      name: Value(name),
      nameNorm: Value(nameNorm),
      sortName: sortName == null && nullToAbsent
          ? const Value.absent()
          : Value(sortName),
      imageAssetId: imageAssetId == null && nullToAbsent
          ? const Value.absent()
          : Value(imageAssetId),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalArtist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalArtist(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameNorm: serializer.fromJson<String>(json['nameNorm']),
      sortName: serializer.fromJson<String?>(json['sortName']),
      imageAssetId: serializer.fromJson<String?>(json['imageAssetId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'nameNorm': serializer.toJson<String>(nameNorm),
      'sortName': serializer.toJson<String?>(sortName),
      'imageAssetId': serializer.toJson<String?>(imageAssetId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalArtist copyWith({
    String? id,
    String? name,
    String? nameNorm,
    Value<String?> sortName = const Value.absent(),
    Value<String?> imageAssetId = const Value.absent(),
    DateTime? updatedAt,
  }) => LocalArtist(
    id: id ?? this.id,
    name: name ?? this.name,
    nameNorm: nameNorm ?? this.nameNorm,
    sortName: sortName.present ? sortName.value : this.sortName,
    imageAssetId: imageAssetId.present ? imageAssetId.value : this.imageAssetId,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalArtist copyWithCompanion(LocalArtistsCompanion data) {
    return LocalArtist(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameNorm: data.nameNorm.present ? data.nameNorm.value : this.nameNorm,
      sortName: data.sortName.present ? data.sortName.value : this.sortName,
      imageAssetId: data.imageAssetId.present
          ? data.imageAssetId.value
          : this.imageAssetId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalArtist(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameNorm: $nameNorm, ')
          ..write('sortName: $sortName, ')
          ..write('imageAssetId: $imageAssetId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, nameNorm, sortName, imageAssetId, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalArtist &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameNorm == this.nameNorm &&
          other.sortName == this.sortName &&
          other.imageAssetId == this.imageAssetId &&
          other.updatedAt == this.updatedAt);
}

class LocalArtistsCompanion extends UpdateCompanion<LocalArtist> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> nameNorm;
  final Value<String?> sortName;
  final Value<String?> imageAssetId;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalArtistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameNorm = const Value.absent(),
    this.sortName = const Value.absent(),
    this.imageAssetId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalArtistsCompanion.insert({
    required String id,
    required String name,
    this.nameNorm = const Value.absent(),
    this.sortName = const Value.absent(),
    this.imageAssetId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<LocalArtist> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? nameNorm,
    Expression<String>? sortName,
    Expression<String>? imageAssetId,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameNorm != null) 'name_norm': nameNorm,
      if (sortName != null) 'sort_name': sortName,
      if (imageAssetId != null) 'image_asset_id': imageAssetId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalArtistsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? nameNorm,
    Value<String?>? sortName,
    Value<String?>? imageAssetId,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalArtistsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameNorm: nameNorm ?? this.nameNorm,
      sortName: sortName ?? this.sortName,
      imageAssetId: imageAssetId ?? this.imageAssetId,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameNorm.present) {
      map['name_norm'] = Variable<String>(nameNorm.value);
    }
    if (sortName.present) {
      map['sort_name'] = Variable<String>(sortName.value);
    }
    if (imageAssetId.present) {
      map['image_asset_id'] = Variable<String>(imageAssetId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalArtistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameNorm: $nameNorm, ')
          ..write('sortName: $sortName, ')
          ..write('imageAssetId: $imageAssetId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPlaylistsTable extends LocalPlaylists
    with TableInfo<$LocalPlaylistsTable, LocalPlaylist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPlaylistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    kind,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_playlists';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPlaylist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPlaylist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPlaylist(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalPlaylistsTable createAlias(String alias) {
    return $LocalPlaylistsTable(attachedDatabase, alias);
  }
}

class LocalPlaylist extends DataClass implements Insertable<LocalPlaylist> {
  final String id;
  final String name;
  final String? description;
  final String kind;
  final DateTime updatedAt;
  const LocalPlaylist({
    required this.id,
    required this.name,
    this.description,
    required this.kind,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['kind'] = Variable<String>(kind);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalPlaylistsCompanion toCompanion(bool nullToAbsent) {
    return LocalPlaylistsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      kind: Value(kind),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalPlaylist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPlaylist(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      kind: serializer.fromJson<String>(json['kind']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'kind': serializer.toJson<String>(kind),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalPlaylist copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    String? kind,
    DateTime? updatedAt,
  }) => LocalPlaylist(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    kind: kind ?? this.kind,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalPlaylist copyWithCompanion(LocalPlaylistsCompanion data) {
    return LocalPlaylist(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      kind: data.kind.present ? data.kind.value : this.kind,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPlaylist(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('kind: $kind, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, kind, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPlaylist &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.kind == this.kind &&
          other.updatedAt == this.updatedAt);
}

class LocalPlaylistsCompanion extends UpdateCompanion<LocalPlaylist> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> kind;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalPlaylistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.kind = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPlaylistsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.kind = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<LocalPlaylist> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? kind,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (kind != null) 'kind': kind,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPlaylistsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? kind,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalPlaylistsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      kind: kind ?? this.kind,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPlaylistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('kind: $kind, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPlaylistTracksTable extends LocalPlaylistTracks
    with TableInfo<$LocalPlaylistTracksTable, LocalPlaylistTrack> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPlaylistTracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _playlistIdMeta = const VerificationMeta(
    'playlistId',
  );
  @override
  late final GeneratedColumn<String> playlistId = GeneratedColumn<String>(
    'playlist_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackIdMeta = const VerificationMeta(
    'trackId',
  );
  @override
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [playlistId, trackId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_playlist_tracks';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPlaylistTrack> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('playlist_id')) {
      context.handle(
        _playlistIdMeta,
        playlistId.isAcceptableOrUnknown(data['playlist_id']!, _playlistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    if (data.containsKey('track_id')) {
      context.handle(
        _trackIdMeta,
        trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {playlistId, trackId};
  @override
  LocalPlaylistTrack map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPlaylistTrack(
      playlistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}playlist_id'],
      )!,
      trackId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}track_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $LocalPlaylistTracksTable createAlias(String alias) {
    return $LocalPlaylistTracksTable(attachedDatabase, alias);
  }
}

class LocalPlaylistTrack extends DataClass
    implements Insertable<LocalPlaylistTrack> {
  final String playlistId;
  final String trackId;
  final int position;
  const LocalPlaylistTrack({
    required this.playlistId,
    required this.trackId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['playlist_id'] = Variable<String>(playlistId);
    map['track_id'] = Variable<String>(trackId);
    map['position'] = Variable<int>(position);
    return map;
  }

  LocalPlaylistTracksCompanion toCompanion(bool nullToAbsent) {
    return LocalPlaylistTracksCompanion(
      playlistId: Value(playlistId),
      trackId: Value(trackId),
      position: Value(position),
    );
  }

  factory LocalPlaylistTrack.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPlaylistTrack(
      playlistId: serializer.fromJson<String>(json['playlistId']),
      trackId: serializer.fromJson<String>(json['trackId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'playlistId': serializer.toJson<String>(playlistId),
      'trackId': serializer.toJson<String>(trackId),
      'position': serializer.toJson<int>(position),
    };
  }

  LocalPlaylistTrack copyWith({
    String? playlistId,
    String? trackId,
    int? position,
  }) => LocalPlaylistTrack(
    playlistId: playlistId ?? this.playlistId,
    trackId: trackId ?? this.trackId,
    position: position ?? this.position,
  );
  LocalPlaylistTrack copyWithCompanion(LocalPlaylistTracksCompanion data) {
    return LocalPlaylistTrack(
      playlistId: data.playlistId.present
          ? data.playlistId.value
          : this.playlistId,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPlaylistTrack(')
          ..write('playlistId: $playlistId, ')
          ..write('trackId: $trackId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(playlistId, trackId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPlaylistTrack &&
          other.playlistId == this.playlistId &&
          other.trackId == this.trackId &&
          other.position == this.position);
}

class LocalPlaylistTracksCompanion extends UpdateCompanion<LocalPlaylistTrack> {
  final Value<String> playlistId;
  final Value<String> trackId;
  final Value<int> position;
  final Value<int> rowid;
  const LocalPlaylistTracksCompanion({
    this.playlistId = const Value.absent(),
    this.trackId = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPlaylistTracksCompanion.insert({
    required String playlistId,
    required String trackId,
    required int position,
    this.rowid = const Value.absent(),
  }) : playlistId = Value(playlistId),
       trackId = Value(trackId),
       position = Value(position);
  static Insertable<LocalPlaylistTrack> custom({
    Expression<String>? playlistId,
    Expression<String>? trackId,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (playlistId != null) 'playlist_id': playlistId,
      if (trackId != null) 'track_id': trackId,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPlaylistTracksCompanion copyWith({
    Value<String>? playlistId,
    Value<String>? trackId,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return LocalPlaylistTracksCompanion(
      playlistId: playlistId ?? this.playlistId,
      trackId: trackId ?? this.trackId,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (playlistId.present) {
      map['playlist_id'] = Variable<String>(playlistId.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<String>(trackId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPlaylistTracksCompanion(')
          ..write('playlistId: $playlistId, ')
          ..write('trackId: $trackId, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QueueEntriesTable extends QueueEntries
    with TableInfo<$QueueEntriesTable, QueueEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QueueEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _trackIdMeta = const VerificationMeta(
    'trackId',
  );
  @override
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, trackId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'queue_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<QueueEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('track_id')) {
      context.handle(
        _trackIdMeta,
        trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QueueEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QueueEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      trackId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}track_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $QueueEntriesTable createAlias(String alias) {
    return $QueueEntriesTable(attachedDatabase, alias);
  }
}

class QueueEntry extends DataClass implements Insertable<QueueEntry> {
  final int id;
  final String trackId;
  final int position;
  const QueueEntry({
    required this.id,
    required this.trackId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['track_id'] = Variable<String>(trackId);
    map['position'] = Variable<int>(position);
    return map;
  }

  QueueEntriesCompanion toCompanion(bool nullToAbsent) {
    return QueueEntriesCompanion(
      id: Value(id),
      trackId: Value(trackId),
      position: Value(position),
    );
  }

  factory QueueEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QueueEntry(
      id: serializer.fromJson<int>(json['id']),
      trackId: serializer.fromJson<String>(json['trackId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'trackId': serializer.toJson<String>(trackId),
      'position': serializer.toJson<int>(position),
    };
  }

  QueueEntry copyWith({int? id, String? trackId, int? position}) => QueueEntry(
    id: id ?? this.id,
    trackId: trackId ?? this.trackId,
    position: position ?? this.position,
  );
  QueueEntry copyWithCompanion(QueueEntriesCompanion data) {
    return QueueEntry(
      id: data.id.present ? data.id.value : this.id,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QueueEntry(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, trackId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QueueEntry &&
          other.id == this.id &&
          other.trackId == this.trackId &&
          other.position == this.position);
}

class QueueEntriesCompanion extends UpdateCompanion<QueueEntry> {
  final Value<int> id;
  final Value<String> trackId;
  final Value<int> position;
  const QueueEntriesCompanion({
    this.id = const Value.absent(),
    this.trackId = const Value.absent(),
    this.position = const Value.absent(),
  });
  QueueEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String trackId,
    required int position,
  }) : trackId = Value(trackId),
       position = Value(position);
  static Insertable<QueueEntry> custom({
    Expression<int>? id,
    Expression<String>? trackId,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackId != null) 'track_id': trackId,
      if (position != null) 'position': position,
    });
  }

  QueueEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? trackId,
    Value<int>? position,
  }) {
    return QueueEntriesCompanion(
      id: id ?? this.id,
      trackId: trackId ?? this.trackId,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<String>(trackId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QueueEntriesCompanion(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $PlaybackStatesTable extends PlaybackStates
    with TableInfo<$PlaybackStatesTable, PlaybackState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaybackStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('current'),
  );
  static const VerificationMeta _trackIdMeta = const VerificationMeta(
    'trackId',
  );
  @override
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
    'track_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _positionMsMeta = const VerificationMeta(
    'positionMs',
  );
  @override
  late final GeneratedColumn<int> positionMs = GeneratedColumn<int>(
    'position_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _queueIndexMeta = const VerificationMeta(
    'queueIndex',
  );
  @override
  late final GeneratedColumn<int> queueIndex = GeneratedColumn<int>(
    'queue_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _repeatModeMeta = const VerificationMeta(
    'repeatMode',
  );
  @override
  late final GeneratedColumn<String> repeatMode = GeneratedColumn<String>(
    'repeat_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('off'),
  );
  static const VerificationMeta _shuffleMeta = const VerificationMeta(
    'shuffle',
  );
  @override
  late final GeneratedColumn<bool> shuffle = GeneratedColumn<bool>(
    'shuffle',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("shuffle" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _speedMeta = const VerificationMeta('speed');
  @override
  late final GeneratedColumn<double> speed = GeneratedColumn<double>(
    'speed',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _volumeMeta = const VerificationMeta('volume');
  @override
  late final GeneratedColumn<double> volume = GeneratedColumn<double>(
    'volume',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    key,
    trackId,
    positionMs,
    queueIndex,
    repeatMode,
    shuffle,
    speed,
    volume,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playback_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaybackState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    }
    if (data.containsKey('track_id')) {
      context.handle(
        _trackIdMeta,
        trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
      );
    }
    if (data.containsKey('position_ms')) {
      context.handle(
        _positionMsMeta,
        positionMs.isAcceptableOrUnknown(data['position_ms']!, _positionMsMeta),
      );
    }
    if (data.containsKey('queue_index')) {
      context.handle(
        _queueIndexMeta,
        queueIndex.isAcceptableOrUnknown(data['queue_index']!, _queueIndexMeta),
      );
    }
    if (data.containsKey('repeat_mode')) {
      context.handle(
        _repeatModeMeta,
        repeatMode.isAcceptableOrUnknown(data['repeat_mode']!, _repeatModeMeta),
      );
    }
    if (data.containsKey('shuffle')) {
      context.handle(
        _shuffleMeta,
        shuffle.isAcceptableOrUnknown(data['shuffle']!, _shuffleMeta),
      );
    }
    if (data.containsKey('speed')) {
      context.handle(
        _speedMeta,
        speed.isAcceptableOrUnknown(data['speed']!, _speedMeta),
      );
    }
    if (data.containsKey('volume')) {
      context.handle(
        _volumeMeta,
        volume.isAcceptableOrUnknown(data['volume']!, _volumeMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  PlaybackState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaybackState(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      trackId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}track_id'],
      ),
      positionMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position_ms'],
      )!,
      queueIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}queue_index'],
      )!,
      repeatMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_mode'],
      )!,
      shuffle: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}shuffle'],
      )!,
      speed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed'],
      )!,
      volume: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}volume'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PlaybackStatesTable createAlias(String alias) {
    return $PlaybackStatesTable(attachedDatabase, alias);
  }
}

class PlaybackState extends DataClass implements Insertable<PlaybackState> {
  final String key;
  final String? trackId;
  final int positionMs;
  final int queueIndex;
  final String repeatMode;
  final bool shuffle;
  final double speed;
  final double volume;
  final DateTime updatedAt;
  const PlaybackState({
    required this.key,
    this.trackId,
    required this.positionMs,
    required this.queueIndex,
    required this.repeatMode,
    required this.shuffle,
    required this.speed,
    required this.volume,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || trackId != null) {
      map['track_id'] = Variable<String>(trackId);
    }
    map['position_ms'] = Variable<int>(positionMs);
    map['queue_index'] = Variable<int>(queueIndex);
    map['repeat_mode'] = Variable<String>(repeatMode);
    map['shuffle'] = Variable<bool>(shuffle);
    map['speed'] = Variable<double>(speed);
    map['volume'] = Variable<double>(volume);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlaybackStatesCompanion toCompanion(bool nullToAbsent) {
    return PlaybackStatesCompanion(
      key: Value(key),
      trackId: trackId == null && nullToAbsent
          ? const Value.absent()
          : Value(trackId),
      positionMs: Value(positionMs),
      queueIndex: Value(queueIndex),
      repeatMode: Value(repeatMode),
      shuffle: Value(shuffle),
      speed: Value(speed),
      volume: Value(volume),
      updatedAt: Value(updatedAt),
    );
  }

  factory PlaybackState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaybackState(
      key: serializer.fromJson<String>(json['key']),
      trackId: serializer.fromJson<String?>(json['trackId']),
      positionMs: serializer.fromJson<int>(json['positionMs']),
      queueIndex: serializer.fromJson<int>(json['queueIndex']),
      repeatMode: serializer.fromJson<String>(json['repeatMode']),
      shuffle: serializer.fromJson<bool>(json['shuffle']),
      speed: serializer.fromJson<double>(json['speed']),
      volume: serializer.fromJson<double>(json['volume']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'trackId': serializer.toJson<String?>(trackId),
      'positionMs': serializer.toJson<int>(positionMs),
      'queueIndex': serializer.toJson<int>(queueIndex),
      'repeatMode': serializer.toJson<String>(repeatMode),
      'shuffle': serializer.toJson<bool>(shuffle),
      'speed': serializer.toJson<double>(speed),
      'volume': serializer.toJson<double>(volume),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PlaybackState copyWith({
    String? key,
    Value<String?> trackId = const Value.absent(),
    int? positionMs,
    int? queueIndex,
    String? repeatMode,
    bool? shuffle,
    double? speed,
    double? volume,
    DateTime? updatedAt,
  }) => PlaybackState(
    key: key ?? this.key,
    trackId: trackId.present ? trackId.value : this.trackId,
    positionMs: positionMs ?? this.positionMs,
    queueIndex: queueIndex ?? this.queueIndex,
    repeatMode: repeatMode ?? this.repeatMode,
    shuffle: shuffle ?? this.shuffle,
    speed: speed ?? this.speed,
    volume: volume ?? this.volume,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PlaybackState copyWithCompanion(PlaybackStatesCompanion data) {
    return PlaybackState(
      key: data.key.present ? data.key.value : this.key,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      positionMs: data.positionMs.present
          ? data.positionMs.value
          : this.positionMs,
      queueIndex: data.queueIndex.present
          ? data.queueIndex.value
          : this.queueIndex,
      repeatMode: data.repeatMode.present
          ? data.repeatMode.value
          : this.repeatMode,
      shuffle: data.shuffle.present ? data.shuffle.value : this.shuffle,
      speed: data.speed.present ? data.speed.value : this.speed,
      volume: data.volume.present ? data.volume.value : this.volume,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaybackState(')
          ..write('key: $key, ')
          ..write('trackId: $trackId, ')
          ..write('positionMs: $positionMs, ')
          ..write('queueIndex: $queueIndex, ')
          ..write('repeatMode: $repeatMode, ')
          ..write('shuffle: $shuffle, ')
          ..write('speed: $speed, ')
          ..write('volume: $volume, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    key,
    trackId,
    positionMs,
    queueIndex,
    repeatMode,
    shuffle,
    speed,
    volume,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaybackState &&
          other.key == this.key &&
          other.trackId == this.trackId &&
          other.positionMs == this.positionMs &&
          other.queueIndex == this.queueIndex &&
          other.repeatMode == this.repeatMode &&
          other.shuffle == this.shuffle &&
          other.speed == this.speed &&
          other.volume == this.volume &&
          other.updatedAt == this.updatedAt);
}

class PlaybackStatesCompanion extends UpdateCompanion<PlaybackState> {
  final Value<String> key;
  final Value<String?> trackId;
  final Value<int> positionMs;
  final Value<int> queueIndex;
  final Value<String> repeatMode;
  final Value<bool> shuffle;
  final Value<double> speed;
  final Value<double> volume;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PlaybackStatesCompanion({
    this.key = const Value.absent(),
    this.trackId = const Value.absent(),
    this.positionMs = const Value.absent(),
    this.queueIndex = const Value.absent(),
    this.repeatMode = const Value.absent(),
    this.shuffle = const Value.absent(),
    this.speed = const Value.absent(),
    this.volume = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaybackStatesCompanion.insert({
    this.key = const Value.absent(),
    this.trackId = const Value.absent(),
    this.positionMs = const Value.absent(),
    this.queueIndex = const Value.absent(),
    this.repeatMode = const Value.absent(),
    this.shuffle = const Value.absent(),
    this.speed = const Value.absent(),
    this.volume = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<PlaybackState> custom({
    Expression<String>? key,
    Expression<String>? trackId,
    Expression<int>? positionMs,
    Expression<int>? queueIndex,
    Expression<String>? repeatMode,
    Expression<bool>? shuffle,
    Expression<double>? speed,
    Expression<double>? volume,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (trackId != null) 'track_id': trackId,
      if (positionMs != null) 'position_ms': positionMs,
      if (queueIndex != null) 'queue_index': queueIndex,
      if (repeatMode != null) 'repeat_mode': repeatMode,
      if (shuffle != null) 'shuffle': shuffle,
      if (speed != null) 'speed': speed,
      if (volume != null) 'volume': volume,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaybackStatesCompanion copyWith({
    Value<String>? key,
    Value<String?>? trackId,
    Value<int>? positionMs,
    Value<int>? queueIndex,
    Value<String>? repeatMode,
    Value<bool>? shuffle,
    Value<double>? speed,
    Value<double>? volume,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PlaybackStatesCompanion(
      key: key ?? this.key,
      trackId: trackId ?? this.trackId,
      positionMs: positionMs ?? this.positionMs,
      queueIndex: queueIndex ?? this.queueIndex,
      repeatMode: repeatMode ?? this.repeatMode,
      shuffle: shuffle ?? this.shuffle,
      speed: speed ?? this.speed,
      volume: volume ?? this.volume,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<String>(trackId.value);
    }
    if (positionMs.present) {
      map['position_ms'] = Variable<int>(positionMs.value);
    }
    if (queueIndex.present) {
      map['queue_index'] = Variable<int>(queueIndex.value);
    }
    if (repeatMode.present) {
      map['repeat_mode'] = Variable<String>(repeatMode.value);
    }
    if (shuffle.present) {
      map['shuffle'] = Variable<bool>(shuffle.value);
    }
    if (speed.present) {
      map['speed'] = Variable<double>(speed.value);
    }
    if (volume.present) {
      map['volume'] = Variable<double>(volume.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaybackStatesCompanion(')
          ..write('key: $key, ')
          ..write('trackId: $trackId, ')
          ..write('positionMs: $positionMs, ')
          ..write('queueIndex: $queueIndex, ')
          ..write('repeatMode: $repeatMode, ')
          ..write('shuffle: $shuffle, ')
          ..write('speed: $speed, ')
          ..write('volume: $volume, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxPlaysTable extends OutboxPlays
    with TableInfo<$OutboxPlaysTable, OutboxPlay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxPlaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _trackIdMeta = const VerificationMeta(
    'trackId',
  );
  @override
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _msPlayedMeta = const VerificationMeta(
    'msPlayed',
  );
  @override
  late final GeneratedColumn<int> msPlayed = GeneratedColumn<int>(
    'ms_played',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _sentMeta = const VerificationMeta('sent');
  @override
  late final GeneratedColumn<bool> sent = GeneratedColumn<bool>(
    'sent',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sent" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    trackId,
    startedAt,
    msPlayed,
    completed,
    idempotencyKey,
    sent,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_plays';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxPlay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('track_id')) {
      context.handle(
        _trackIdMeta,
        trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ms_played')) {
      context.handle(
        _msPlayedMeta,
        msPlayed.isAcceptableOrUnknown(data['ms_played']!, _msPlayedMeta),
      );
    } else if (isInserting) {
      context.missing(_msPlayedMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('sent')) {
      context.handle(
        _sentMeta,
        sent.isAcceptableOrUnknown(data['sent']!, _sentMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxPlay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxPlay(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      trackId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}track_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      msPlayed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ms_played'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      sent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sent'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $OutboxPlaysTable createAlias(String alias) {
    return $OutboxPlaysTable(attachedDatabase, alias);
  }
}

class OutboxPlay extends DataClass implements Insertable<OutboxPlay> {
  final int id;
  final String trackId;
  final DateTime startedAt;
  final int msPlayed;
  final bool completed;
  final String idempotencyKey;
  final bool sent;
  final DateTime createdAt;
  const OutboxPlay({
    required this.id,
    required this.trackId,
    required this.startedAt,
    required this.msPlayed,
    required this.completed,
    required this.idempotencyKey,
    required this.sent,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['track_id'] = Variable<String>(trackId);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ms_played'] = Variable<int>(msPlayed);
    map['completed'] = Variable<bool>(completed);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['sent'] = Variable<bool>(sent);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OutboxPlaysCompanion toCompanion(bool nullToAbsent) {
    return OutboxPlaysCompanion(
      id: Value(id),
      trackId: Value(trackId),
      startedAt: Value(startedAt),
      msPlayed: Value(msPlayed),
      completed: Value(completed),
      idempotencyKey: Value(idempotencyKey),
      sent: Value(sent),
      createdAt: Value(createdAt),
    );
  }

  factory OutboxPlay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxPlay(
      id: serializer.fromJson<int>(json['id']),
      trackId: serializer.fromJson<String>(json['trackId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      msPlayed: serializer.fromJson<int>(json['msPlayed']),
      completed: serializer.fromJson<bool>(json['completed']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      sent: serializer.fromJson<bool>(json['sent']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'trackId': serializer.toJson<String>(trackId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'msPlayed': serializer.toJson<int>(msPlayed),
      'completed': serializer.toJson<bool>(completed),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'sent': serializer.toJson<bool>(sent),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OutboxPlay copyWith({
    int? id,
    String? trackId,
    DateTime? startedAt,
    int? msPlayed,
    bool? completed,
    String? idempotencyKey,
    bool? sent,
    DateTime? createdAt,
  }) => OutboxPlay(
    id: id ?? this.id,
    trackId: trackId ?? this.trackId,
    startedAt: startedAt ?? this.startedAt,
    msPlayed: msPlayed ?? this.msPlayed,
    completed: completed ?? this.completed,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    sent: sent ?? this.sent,
    createdAt: createdAt ?? this.createdAt,
  );
  OutboxPlay copyWithCompanion(OutboxPlaysCompanion data) {
    return OutboxPlay(
      id: data.id.present ? data.id.value : this.id,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      msPlayed: data.msPlayed.present ? data.msPlayed.value : this.msPlayed,
      completed: data.completed.present ? data.completed.value : this.completed,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      sent: data.sent.present ? data.sent.value : this.sent,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxPlay(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('startedAt: $startedAt, ')
          ..write('msPlayed: $msPlayed, ')
          ..write('completed: $completed, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('sent: $sent, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    trackId,
    startedAt,
    msPlayed,
    completed,
    idempotencyKey,
    sent,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxPlay &&
          other.id == this.id &&
          other.trackId == this.trackId &&
          other.startedAt == this.startedAt &&
          other.msPlayed == this.msPlayed &&
          other.completed == this.completed &&
          other.idempotencyKey == this.idempotencyKey &&
          other.sent == this.sent &&
          other.createdAt == this.createdAt);
}

class OutboxPlaysCompanion extends UpdateCompanion<OutboxPlay> {
  final Value<int> id;
  final Value<String> trackId;
  final Value<DateTime> startedAt;
  final Value<int> msPlayed;
  final Value<bool> completed;
  final Value<String> idempotencyKey;
  final Value<bool> sent;
  final Value<DateTime> createdAt;
  const OutboxPlaysCompanion({
    this.id = const Value.absent(),
    this.trackId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.msPlayed = const Value.absent(),
    this.completed = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.sent = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  OutboxPlaysCompanion.insert({
    this.id = const Value.absent(),
    required String trackId,
    required DateTime startedAt,
    required int msPlayed,
    this.completed = const Value.absent(),
    required String idempotencyKey,
    this.sent = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : trackId = Value(trackId),
       startedAt = Value(startedAt),
       msPlayed = Value(msPlayed),
       idempotencyKey = Value(idempotencyKey);
  static Insertable<OutboxPlay> custom({
    Expression<int>? id,
    Expression<String>? trackId,
    Expression<DateTime>? startedAt,
    Expression<int>? msPlayed,
    Expression<bool>? completed,
    Expression<String>? idempotencyKey,
    Expression<bool>? sent,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackId != null) 'track_id': trackId,
      if (startedAt != null) 'started_at': startedAt,
      if (msPlayed != null) 'ms_played': msPlayed,
      if (completed != null) 'completed': completed,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (sent != null) 'sent': sent,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  OutboxPlaysCompanion copyWith({
    Value<int>? id,
    Value<String>? trackId,
    Value<DateTime>? startedAt,
    Value<int>? msPlayed,
    Value<bool>? completed,
    Value<String>? idempotencyKey,
    Value<bool>? sent,
    Value<DateTime>? createdAt,
  }) {
    return OutboxPlaysCompanion(
      id: id ?? this.id,
      trackId: trackId ?? this.trackId,
      startedAt: startedAt ?? this.startedAt,
      msPlayed: msPlayed ?? this.msPlayed,
      completed: completed ?? this.completed,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      sent: sent ?? this.sent,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<String>(trackId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (msPlayed.present) {
      map['ms_played'] = Variable<int>(msPlayed.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (sent.present) {
      map['sent'] = Variable<bool>(sent.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxPlaysCompanion(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('startedAt: $startedAt, ')
          ..write('msPlayed: $msPlayed, ')
          ..write('completed: $completed, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('sent: $sent, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CachedLyricsTable extends CachedLyrics
    with TableInfo<$CachedLyricsTable, CachedLyric> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedLyricsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _trackIdMeta = const VerificationMeta(
    'trackId',
  );
  @override
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('plain'),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _offsetMsMeta = const VerificationMeta(
    'offsetMs',
  );
  @override
  late final GeneratedColumn<int> offsetMs = GeneratedColumn<int>(
    'offset_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _plainTextMeta = const VerificationMeta(
    'plainText',
  );
  @override
  late final GeneratedColumn<String> plainText = GeneratedColumn<String>(
    'plain_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _linesJsonMeta = const VerificationMeta(
    'linesJson',
  );
  @override
  late final GeneratedColumn<String> linesJson = GeneratedColumn<String>(
    'lines_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    trackId,
    kind,
    source,
    offsetMs,
    plainText,
    linesJson,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_lyrics';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedLyric> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('track_id')) {
      context.handle(
        _trackIdMeta,
        trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('offset_ms')) {
      context.handle(
        _offsetMsMeta,
        offsetMs.isAcceptableOrUnknown(data['offset_ms']!, _offsetMsMeta),
      );
    }
    if (data.containsKey('plain_text')) {
      context.handle(
        _plainTextMeta,
        plainText.isAcceptableOrUnknown(data['plain_text']!, _plainTextMeta),
      );
    }
    if (data.containsKey('lines_json')) {
      context.handle(
        _linesJsonMeta,
        linesJson.isAcceptableOrUnknown(data['lines_json']!, _linesJsonMeta),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {trackId};
  @override
  CachedLyric map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedLyric(
      trackId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}track_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      offsetMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}offset_ms'],
      )!,
      plainText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plain_text'],
      )!,
      linesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lines_json'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $CachedLyricsTable createAlias(String alias) {
    return $CachedLyricsTable(attachedDatabase, alias);
  }
}

class CachedLyric extends DataClass implements Insertable<CachedLyric> {
  final String trackId;
  final String kind;
  final String source;
  final int offsetMs;
  final String plainText;
  final String linesJson;
  final DateTime fetchedAt;
  const CachedLyric({
    required this.trackId,
    required this.kind,
    required this.source,
    required this.offsetMs,
    required this.plainText,
    required this.linesJson,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['track_id'] = Variable<String>(trackId);
    map['kind'] = Variable<String>(kind);
    map['source'] = Variable<String>(source);
    map['offset_ms'] = Variable<int>(offsetMs);
    map['plain_text'] = Variable<String>(plainText);
    map['lines_json'] = Variable<String>(linesJson);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  CachedLyricsCompanion toCompanion(bool nullToAbsent) {
    return CachedLyricsCompanion(
      trackId: Value(trackId),
      kind: Value(kind),
      source: Value(source),
      offsetMs: Value(offsetMs),
      plainText: Value(plainText),
      linesJson: Value(linesJson),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory CachedLyric.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedLyric(
      trackId: serializer.fromJson<String>(json['trackId']),
      kind: serializer.fromJson<String>(json['kind']),
      source: serializer.fromJson<String>(json['source']),
      offsetMs: serializer.fromJson<int>(json['offsetMs']),
      plainText: serializer.fromJson<String>(json['plainText']),
      linesJson: serializer.fromJson<String>(json['linesJson']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'trackId': serializer.toJson<String>(trackId),
      'kind': serializer.toJson<String>(kind),
      'source': serializer.toJson<String>(source),
      'offsetMs': serializer.toJson<int>(offsetMs),
      'plainText': serializer.toJson<String>(plainText),
      'linesJson': serializer.toJson<String>(linesJson),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  CachedLyric copyWith({
    String? trackId,
    String? kind,
    String? source,
    int? offsetMs,
    String? plainText,
    String? linesJson,
    DateTime? fetchedAt,
  }) => CachedLyric(
    trackId: trackId ?? this.trackId,
    kind: kind ?? this.kind,
    source: source ?? this.source,
    offsetMs: offsetMs ?? this.offsetMs,
    plainText: plainText ?? this.plainText,
    linesJson: linesJson ?? this.linesJson,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  CachedLyric copyWithCompanion(CachedLyricsCompanion data) {
    return CachedLyric(
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      kind: data.kind.present ? data.kind.value : this.kind,
      source: data.source.present ? data.source.value : this.source,
      offsetMs: data.offsetMs.present ? data.offsetMs.value : this.offsetMs,
      plainText: data.plainText.present ? data.plainText.value : this.plainText,
      linesJson: data.linesJson.present ? data.linesJson.value : this.linesJson,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedLyric(')
          ..write('trackId: $trackId, ')
          ..write('kind: $kind, ')
          ..write('source: $source, ')
          ..write('offsetMs: $offsetMs, ')
          ..write('plainText: $plainText, ')
          ..write('linesJson: $linesJson, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    trackId,
    kind,
    source,
    offsetMs,
    plainText,
    linesJson,
    fetchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedLyric &&
          other.trackId == this.trackId &&
          other.kind == this.kind &&
          other.source == this.source &&
          other.offsetMs == this.offsetMs &&
          other.plainText == this.plainText &&
          other.linesJson == this.linesJson &&
          other.fetchedAt == this.fetchedAt);
}

class CachedLyricsCompanion extends UpdateCompanion<CachedLyric> {
  final Value<String> trackId;
  final Value<String> kind;
  final Value<String> source;
  final Value<int> offsetMs;
  final Value<String> plainText;
  final Value<String> linesJson;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const CachedLyricsCompanion({
    this.trackId = const Value.absent(),
    this.kind = const Value.absent(),
    this.source = const Value.absent(),
    this.offsetMs = const Value.absent(),
    this.plainText = const Value.absent(),
    this.linesJson = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedLyricsCompanion.insert({
    required String trackId,
    this.kind = const Value.absent(),
    this.source = const Value.absent(),
    this.offsetMs = const Value.absent(),
    this.plainText = const Value.absent(),
    this.linesJson = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : trackId = Value(trackId);
  static Insertable<CachedLyric> custom({
    Expression<String>? trackId,
    Expression<String>? kind,
    Expression<String>? source,
    Expression<int>? offsetMs,
    Expression<String>? plainText,
    Expression<String>? linesJson,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (trackId != null) 'track_id': trackId,
      if (kind != null) 'kind': kind,
      if (source != null) 'source': source,
      if (offsetMs != null) 'offset_ms': offsetMs,
      if (plainText != null) 'plain_text': plainText,
      if (linesJson != null) 'lines_json': linesJson,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedLyricsCompanion copyWith({
    Value<String>? trackId,
    Value<String>? kind,
    Value<String>? source,
    Value<int>? offsetMs,
    Value<String>? plainText,
    Value<String>? linesJson,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return CachedLyricsCompanion(
      trackId: trackId ?? this.trackId,
      kind: kind ?? this.kind,
      source: source ?? this.source,
      offsetMs: offsetMs ?? this.offsetMs,
      plainText: plainText ?? this.plainText,
      linesJson: linesJson ?? this.linesJson,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (trackId.present) {
      map['track_id'] = Variable<String>(trackId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (offsetMs.present) {
      map['offset_ms'] = Variable<int>(offsetMs.value);
    }
    if (plainText.present) {
      map['plain_text'] = Variable<String>(plainText.value);
    }
    if (linesJson.present) {
      map['lines_json'] = Variable<String>(linesJson.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedLyricsCompanion(')
          ..write('trackId: $trackId, ')
          ..write('kind: $kind, ')
          ..write('source: $source, ')
          ..write('offsetMs: $offsetMs, ')
          ..write('plainText: $plainText, ')
          ..write('linesJson: $linesJson, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetaTable extends SyncMeta
    with TableInfo<$SyncMetaTable, SyncMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetaData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SyncMetaTable createAlias(String alias) {
    return $SyncMetaTable(attachedDatabase, alias);
  }
}

class SyncMetaData extends DataClass implements Insertable<SyncMetaData> {
  final String key;
  final String value;
  const SyncMetaData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SyncMetaCompanion toCompanion(bool nullToAbsent) {
    return SyncMetaCompanion(key: Value(key), value: Value(value));
  }

  factory SyncMetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetaData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SyncMetaData copyWith({String? key, String? value}) =>
      SyncMetaData(key: key ?? this.key, value: value ?? this.value);
  SyncMetaData copyWithCompanion(SyncMetaCompanion data) {
    return SyncMetaData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetaData &&
          other.key == this.key &&
          other.value == this.value);
}

class SyncMetaCompanion extends UpdateCompanion<SyncMetaData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SyncMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SyncMetaData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetaCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SyncMetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AuraDatabase extends GeneratedDatabase {
  _$AuraDatabase(QueryExecutor e) : super(e);
  $AuraDatabaseManager get managers => $AuraDatabaseManager(this);
  late final $LocalTracksTable localTracks = $LocalTracksTable(this);
  late final $LocalAlbumsTable localAlbums = $LocalAlbumsTable(this);
  late final $LocalArtistsTable localArtists = $LocalArtistsTable(this);
  late final $LocalPlaylistsTable localPlaylists = $LocalPlaylistsTable(this);
  late final $LocalPlaylistTracksTable localPlaylistTracks =
      $LocalPlaylistTracksTable(this);
  late final $QueueEntriesTable queueEntries = $QueueEntriesTable(this);
  late final $PlaybackStatesTable playbackStates = $PlaybackStatesTable(this);
  late final $OutboxPlaysTable outboxPlays = $OutboxPlaysTable(this);
  late final $CachedLyricsTable cachedLyrics = $CachedLyricsTable(this);
  late final $SyncMetaTable syncMeta = $SyncMetaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localTracks,
    localAlbums,
    localArtists,
    localPlaylists,
    localPlaylistTracks,
    queueEntries,
    playbackStates,
    outboxPlays,
    cachedLyrics,
    syncMeta,
  ];
}

typedef $$LocalTracksTableCreateCompanionBuilder =
    LocalTracksCompanion Function({
      required String id,
      required String title,
      Value<String> titleNorm,
      Value<String?> version,
      Value<String?> albumId,
      Value<String?> albumTitle,
      Value<String?> coverAssetId,
      Value<String> artistNames,
      Value<String> artistIds,
      Value<int?> trackNo,
      Value<int?> discNo,
      Value<int?> durationMs,
      Value<String> sourceProvider,
      Value<String> sourceRef,
      Value<String?> audioAssetId,
      Value<double?> loudnessLufs,
      Value<double?> replaygainDb,
      Value<double?> bpm,
      Value<double?> energy,
      Value<String> status,
      Value<bool> explicit,
      Value<bool> favorite,
      required DateTime addedAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> localAudioPath,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });
typedef $$LocalTracksTableUpdateCompanionBuilder =
    LocalTracksCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> titleNorm,
      Value<String?> version,
      Value<String?> albumId,
      Value<String?> albumTitle,
      Value<String?> coverAssetId,
      Value<String> artistNames,
      Value<String> artistIds,
      Value<int?> trackNo,
      Value<int?> discNo,
      Value<int?> durationMs,
      Value<String> sourceProvider,
      Value<String> sourceRef,
      Value<String?> audioAssetId,
      Value<double?> loudnessLufs,
      Value<double?> replaygainDb,
      Value<double?> bpm,
      Value<double?> energy,
      Value<String> status,
      Value<bool> explicit,
      Value<bool> favorite,
      Value<DateTime> addedAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> localAudioPath,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$LocalTracksTableFilterComposer
    extends Composer<_$AuraDatabase, $LocalTracksTable> {
  $$LocalTracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleNorm => $composableBuilder(
    column: $table.titleNorm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get albumId => $composableBuilder(
    column: $table.albumId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get albumTitle => $composableBuilder(
    column: $table.albumTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverAssetId => $composableBuilder(
    column: $table.coverAssetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artistNames => $composableBuilder(
    column: $table.artistNames,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artistIds => $composableBuilder(
    column: $table.artistIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trackNo => $composableBuilder(
    column: $table.trackNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discNo => $composableBuilder(
    column: $table.discNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceProvider => $composableBuilder(
    column: $table.sourceProvider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceRef => $composableBuilder(
    column: $table.sourceRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioAssetId => $composableBuilder(
    column: $table.audioAssetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get loudnessLufs => $composableBuilder(
    column: $table.loudnessLufs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get replaygainDb => $composableBuilder(
    column: $table.replaygainDb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bpm => $composableBuilder(
    column: $table.bpm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get energy => $composableBuilder(
    column: $table.energy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get explicit => $composableBuilder(
    column: $table.explicit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localAudioPath => $composableBuilder(
    column: $table.localAudioPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalTracksTableOrderingComposer
    extends Composer<_$AuraDatabase, $LocalTracksTable> {
  $$LocalTracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleNorm => $composableBuilder(
    column: $table.titleNorm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get albumId => $composableBuilder(
    column: $table.albumId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get albumTitle => $composableBuilder(
    column: $table.albumTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverAssetId => $composableBuilder(
    column: $table.coverAssetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artistNames => $composableBuilder(
    column: $table.artistNames,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artistIds => $composableBuilder(
    column: $table.artistIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trackNo => $composableBuilder(
    column: $table.trackNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discNo => $composableBuilder(
    column: $table.discNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceProvider => $composableBuilder(
    column: $table.sourceProvider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceRef => $composableBuilder(
    column: $table.sourceRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioAssetId => $composableBuilder(
    column: $table.audioAssetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get loudnessLufs => $composableBuilder(
    column: $table.loudnessLufs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get replaygainDb => $composableBuilder(
    column: $table.replaygainDb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bpm => $composableBuilder(
    column: $table.bpm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get energy => $composableBuilder(
    column: $table.energy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get explicit => $composableBuilder(
    column: $table.explicit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localAudioPath => $composableBuilder(
    column: $table.localAudioPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalTracksTableAnnotationComposer
    extends Composer<_$AuraDatabase, $LocalTracksTable> {
  $$LocalTracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get titleNorm =>
      $composableBuilder(column: $table.titleNorm, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get albumId =>
      $composableBuilder(column: $table.albumId, builder: (column) => column);

  GeneratedColumn<String> get albumTitle => $composableBuilder(
    column: $table.albumTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coverAssetId => $composableBuilder(
    column: $table.coverAssetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get artistNames => $composableBuilder(
    column: $table.artistNames,
    builder: (column) => column,
  );

  GeneratedColumn<String> get artistIds =>
      $composableBuilder(column: $table.artistIds, builder: (column) => column);

  GeneratedColumn<int> get trackNo =>
      $composableBuilder(column: $table.trackNo, builder: (column) => column);

  GeneratedColumn<int> get discNo =>
      $composableBuilder(column: $table.discNo, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceProvider => $composableBuilder(
    column: $table.sourceProvider,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceRef =>
      $composableBuilder(column: $table.sourceRef, builder: (column) => column);

  GeneratedColumn<String> get audioAssetId => $composableBuilder(
    column: $table.audioAssetId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get loudnessLufs => $composableBuilder(
    column: $table.loudnessLufs,
    builder: (column) => column,
  );

  GeneratedColumn<double> get replaygainDb => $composableBuilder(
    column: $table.replaygainDb,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bpm =>
      $composableBuilder(column: $table.bpm, builder: (column) => column);

  GeneratedColumn<double> get energy =>
      $composableBuilder(column: $table.energy, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get explicit =>
      $composableBuilder(column: $table.explicit, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get localAudioPath => $composableBuilder(
    column: $table.localAudioPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$LocalTracksTableTableManager
    extends
        RootTableManager<
          _$AuraDatabase,
          $LocalTracksTable,
          LocalTrack,
          $$LocalTracksTableFilterComposer,
          $$LocalTracksTableOrderingComposer,
          $$LocalTracksTableAnnotationComposer,
          $$LocalTracksTableCreateCompanionBuilder,
          $$LocalTracksTableUpdateCompanionBuilder,
          (
            LocalTrack,
            BaseReferences<_$AuraDatabase, $LocalTracksTable, LocalTrack>,
          ),
          LocalTrack,
          PrefetchHooks Function()
        > {
  $$LocalTracksTableTableManager(_$AuraDatabase db, $LocalTracksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalTracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalTracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalTracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> titleNorm = const Value.absent(),
                Value<String?> version = const Value.absent(),
                Value<String?> albumId = const Value.absent(),
                Value<String?> albumTitle = const Value.absent(),
                Value<String?> coverAssetId = const Value.absent(),
                Value<String> artistNames = const Value.absent(),
                Value<String> artistIds = const Value.absent(),
                Value<int?> trackNo = const Value.absent(),
                Value<int?> discNo = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<String> sourceProvider = const Value.absent(),
                Value<String> sourceRef = const Value.absent(),
                Value<String?> audioAssetId = const Value.absent(),
                Value<double?> loudnessLufs = const Value.absent(),
                Value<double?> replaygainDb = const Value.absent(),
                Value<double?> bpm = const Value.absent(),
                Value<double?> energy = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> explicit = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> localAudioPath = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalTracksCompanion(
                id: id,
                title: title,
                titleNorm: titleNorm,
                version: version,
                albumId: albumId,
                albumTitle: albumTitle,
                coverAssetId: coverAssetId,
                artistNames: artistNames,
                artistIds: artistIds,
                trackNo: trackNo,
                discNo: discNo,
                durationMs: durationMs,
                sourceProvider: sourceProvider,
                sourceRef: sourceRef,
                audioAssetId: audioAssetId,
                loudnessLufs: loudnessLufs,
                replaygainDb: replaygainDb,
                bpm: bpm,
                energy: energy,
                status: status,
                explicit: explicit,
                favorite: favorite,
                addedAt: addedAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                localAudioPath: localAudioPath,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String> titleNorm = const Value.absent(),
                Value<String?> version = const Value.absent(),
                Value<String?> albumId = const Value.absent(),
                Value<String?> albumTitle = const Value.absent(),
                Value<String?> coverAssetId = const Value.absent(),
                Value<String> artistNames = const Value.absent(),
                Value<String> artistIds = const Value.absent(),
                Value<int?> trackNo = const Value.absent(),
                Value<int?> discNo = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<String> sourceProvider = const Value.absent(),
                Value<String> sourceRef = const Value.absent(),
                Value<String?> audioAssetId = const Value.absent(),
                Value<double?> loudnessLufs = const Value.absent(),
                Value<double?> replaygainDb = const Value.absent(),
                Value<double?> bpm = const Value.absent(),
                Value<double?> energy = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> explicit = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                required DateTime addedAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> localAudioPath = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalTracksCompanion.insert(
                id: id,
                title: title,
                titleNorm: titleNorm,
                version: version,
                albumId: albumId,
                albumTitle: albumTitle,
                coverAssetId: coverAssetId,
                artistNames: artistNames,
                artistIds: artistIds,
                trackNo: trackNo,
                discNo: discNo,
                durationMs: durationMs,
                sourceProvider: sourceProvider,
                sourceRef: sourceRef,
                audioAssetId: audioAssetId,
                loudnessLufs: loudnessLufs,
                replaygainDb: replaygainDb,
                bpm: bpm,
                energy: energy,
                status: status,
                explicit: explicit,
                favorite: favorite,
                addedAt: addedAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                localAudioPath: localAudioPath,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalTracksTableProcessedTableManager =
    ProcessedTableManager<
      _$AuraDatabase,
      $LocalTracksTable,
      LocalTrack,
      $$LocalTracksTableFilterComposer,
      $$LocalTracksTableOrderingComposer,
      $$LocalTracksTableAnnotationComposer,
      $$LocalTracksTableCreateCompanionBuilder,
      $$LocalTracksTableUpdateCompanionBuilder,
      (
        LocalTrack,
        BaseReferences<_$AuraDatabase, $LocalTracksTable, LocalTrack>,
      ),
      LocalTrack,
      PrefetchHooks Function()
    >;
typedef $$LocalAlbumsTableCreateCompanionBuilder =
    LocalAlbumsCompanion Function({
      required String id,
      required String title,
      Value<String> titleNorm,
      Value<int?> year,
      Value<String?> coverAssetId,
      Value<String?> albumArtistId,
      Value<String?> albumArtistName,
      Value<int?> totalTracks,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LocalAlbumsTableUpdateCompanionBuilder =
    LocalAlbumsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> titleNorm,
      Value<int?> year,
      Value<String?> coverAssetId,
      Value<String?> albumArtistId,
      Value<String?> albumArtistName,
      Value<int?> totalTracks,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalAlbumsTableFilterComposer
    extends Composer<_$AuraDatabase, $LocalAlbumsTable> {
  $$LocalAlbumsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleNorm => $composableBuilder(
    column: $table.titleNorm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverAssetId => $composableBuilder(
    column: $table.coverAssetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get albumArtistId => $composableBuilder(
    column: $table.albumArtistId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get albumArtistName => $composableBuilder(
    column: $table.albumArtistName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalTracks => $composableBuilder(
    column: $table.totalTracks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalAlbumsTableOrderingComposer
    extends Composer<_$AuraDatabase, $LocalAlbumsTable> {
  $$LocalAlbumsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleNorm => $composableBuilder(
    column: $table.titleNorm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverAssetId => $composableBuilder(
    column: $table.coverAssetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get albumArtistId => $composableBuilder(
    column: $table.albumArtistId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get albumArtistName => $composableBuilder(
    column: $table.albumArtistName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalTracks => $composableBuilder(
    column: $table.totalTracks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalAlbumsTableAnnotationComposer
    extends Composer<_$AuraDatabase, $LocalAlbumsTable> {
  $$LocalAlbumsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get titleNorm =>
      $composableBuilder(column: $table.titleNorm, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get coverAssetId => $composableBuilder(
    column: $table.coverAssetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get albumArtistId => $composableBuilder(
    column: $table.albumArtistId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get albumArtistName => $composableBuilder(
    column: $table.albumArtistName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalTracks => $composableBuilder(
    column: $table.totalTracks,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalAlbumsTableTableManager
    extends
        RootTableManager<
          _$AuraDatabase,
          $LocalAlbumsTable,
          LocalAlbum,
          $$LocalAlbumsTableFilterComposer,
          $$LocalAlbumsTableOrderingComposer,
          $$LocalAlbumsTableAnnotationComposer,
          $$LocalAlbumsTableCreateCompanionBuilder,
          $$LocalAlbumsTableUpdateCompanionBuilder,
          (
            LocalAlbum,
            BaseReferences<_$AuraDatabase, $LocalAlbumsTable, LocalAlbum>,
          ),
          LocalAlbum,
          PrefetchHooks Function()
        > {
  $$LocalAlbumsTableTableManager(_$AuraDatabase db, $LocalAlbumsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalAlbumsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalAlbumsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalAlbumsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> titleNorm = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> coverAssetId = const Value.absent(),
                Value<String?> albumArtistId = const Value.absent(),
                Value<String?> albumArtistName = const Value.absent(),
                Value<int?> totalTracks = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAlbumsCompanion(
                id: id,
                title: title,
                titleNorm: titleNorm,
                year: year,
                coverAssetId: coverAssetId,
                albumArtistId: albumArtistId,
                albumArtistName: albumArtistName,
                totalTracks: totalTracks,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String> titleNorm = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> coverAssetId = const Value.absent(),
                Value<String?> albumArtistId = const Value.absent(),
                Value<String?> albumArtistName = const Value.absent(),
                Value<int?> totalTracks = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAlbumsCompanion.insert(
                id: id,
                title: title,
                titleNorm: titleNorm,
                year: year,
                coverAssetId: coverAssetId,
                albumArtistId: albumArtistId,
                albumArtistName: albumArtistName,
                totalTracks: totalTracks,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalAlbumsTableProcessedTableManager =
    ProcessedTableManager<
      _$AuraDatabase,
      $LocalAlbumsTable,
      LocalAlbum,
      $$LocalAlbumsTableFilterComposer,
      $$LocalAlbumsTableOrderingComposer,
      $$LocalAlbumsTableAnnotationComposer,
      $$LocalAlbumsTableCreateCompanionBuilder,
      $$LocalAlbumsTableUpdateCompanionBuilder,
      (
        LocalAlbum,
        BaseReferences<_$AuraDatabase, $LocalAlbumsTable, LocalAlbum>,
      ),
      LocalAlbum,
      PrefetchHooks Function()
    >;
typedef $$LocalArtistsTableCreateCompanionBuilder =
    LocalArtistsCompanion Function({
      required String id,
      required String name,
      Value<String> nameNorm,
      Value<String?> sortName,
      Value<String?> imageAssetId,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LocalArtistsTableUpdateCompanionBuilder =
    LocalArtistsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> nameNorm,
      Value<String?> sortName,
      Value<String?> imageAssetId,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalArtistsTableFilterComposer
    extends Composer<_$AuraDatabase, $LocalArtistsTable> {
  $$LocalArtistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameNorm => $composableBuilder(
    column: $table.nameNorm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sortName => $composableBuilder(
    column: $table.sortName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageAssetId => $composableBuilder(
    column: $table.imageAssetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalArtistsTableOrderingComposer
    extends Composer<_$AuraDatabase, $LocalArtistsTable> {
  $$LocalArtistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameNorm => $composableBuilder(
    column: $table.nameNorm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sortName => $composableBuilder(
    column: $table.sortName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageAssetId => $composableBuilder(
    column: $table.imageAssetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalArtistsTableAnnotationComposer
    extends Composer<_$AuraDatabase, $LocalArtistsTable> {
  $$LocalArtistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameNorm =>
      $composableBuilder(column: $table.nameNorm, builder: (column) => column);

  GeneratedColumn<String> get sortName =>
      $composableBuilder(column: $table.sortName, builder: (column) => column);

  GeneratedColumn<String> get imageAssetId => $composableBuilder(
    column: $table.imageAssetId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalArtistsTableTableManager
    extends
        RootTableManager<
          _$AuraDatabase,
          $LocalArtistsTable,
          LocalArtist,
          $$LocalArtistsTableFilterComposer,
          $$LocalArtistsTableOrderingComposer,
          $$LocalArtistsTableAnnotationComposer,
          $$LocalArtistsTableCreateCompanionBuilder,
          $$LocalArtistsTableUpdateCompanionBuilder,
          (
            LocalArtist,
            BaseReferences<_$AuraDatabase, $LocalArtistsTable, LocalArtist>,
          ),
          LocalArtist,
          PrefetchHooks Function()
        > {
  $$LocalArtistsTableTableManager(_$AuraDatabase db, $LocalArtistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalArtistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalArtistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalArtistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nameNorm = const Value.absent(),
                Value<String?> sortName = const Value.absent(),
                Value<String?> imageAssetId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalArtistsCompanion(
                id: id,
                name: name,
                nameNorm: nameNorm,
                sortName: sortName,
                imageAssetId: imageAssetId,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> nameNorm = const Value.absent(),
                Value<String?> sortName = const Value.absent(),
                Value<String?> imageAssetId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalArtistsCompanion.insert(
                id: id,
                name: name,
                nameNorm: nameNorm,
                sortName: sortName,
                imageAssetId: imageAssetId,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalArtistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AuraDatabase,
      $LocalArtistsTable,
      LocalArtist,
      $$LocalArtistsTableFilterComposer,
      $$LocalArtistsTableOrderingComposer,
      $$LocalArtistsTableAnnotationComposer,
      $$LocalArtistsTableCreateCompanionBuilder,
      $$LocalArtistsTableUpdateCompanionBuilder,
      (
        LocalArtist,
        BaseReferences<_$AuraDatabase, $LocalArtistsTable, LocalArtist>,
      ),
      LocalArtist,
      PrefetchHooks Function()
    >;
typedef $$LocalPlaylistsTableCreateCompanionBuilder =
    LocalPlaylistsCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<String> kind,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LocalPlaylistsTableUpdateCompanionBuilder =
    LocalPlaylistsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<String> kind,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalPlaylistsTableFilterComposer
    extends Composer<_$AuraDatabase, $LocalPlaylistsTable> {
  $$LocalPlaylistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalPlaylistsTableOrderingComposer
    extends Composer<_$AuraDatabase, $LocalPlaylistsTable> {
  $$LocalPlaylistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPlaylistsTableAnnotationComposer
    extends Composer<_$AuraDatabase, $LocalPlaylistsTable> {
  $$LocalPlaylistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalPlaylistsTableTableManager
    extends
        RootTableManager<
          _$AuraDatabase,
          $LocalPlaylistsTable,
          LocalPlaylist,
          $$LocalPlaylistsTableFilterComposer,
          $$LocalPlaylistsTableOrderingComposer,
          $$LocalPlaylistsTableAnnotationComposer,
          $$LocalPlaylistsTableCreateCompanionBuilder,
          $$LocalPlaylistsTableUpdateCompanionBuilder,
          (
            LocalPlaylist,
            BaseReferences<_$AuraDatabase, $LocalPlaylistsTable, LocalPlaylist>,
          ),
          LocalPlaylist,
          PrefetchHooks Function()
        > {
  $$LocalPlaylistsTableTableManager(
    _$AuraDatabase db,
    $LocalPlaylistsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPlaylistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalPlaylistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalPlaylistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPlaylistsCompanion(
                id: id,
                name: name,
                description: description,
                kind: kind,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPlaylistsCompanion.insert(
                id: id,
                name: name,
                description: description,
                kind: kind,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalPlaylistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AuraDatabase,
      $LocalPlaylistsTable,
      LocalPlaylist,
      $$LocalPlaylistsTableFilterComposer,
      $$LocalPlaylistsTableOrderingComposer,
      $$LocalPlaylistsTableAnnotationComposer,
      $$LocalPlaylistsTableCreateCompanionBuilder,
      $$LocalPlaylistsTableUpdateCompanionBuilder,
      (
        LocalPlaylist,
        BaseReferences<_$AuraDatabase, $LocalPlaylistsTable, LocalPlaylist>,
      ),
      LocalPlaylist,
      PrefetchHooks Function()
    >;
typedef $$LocalPlaylistTracksTableCreateCompanionBuilder =
    LocalPlaylistTracksCompanion Function({
      required String playlistId,
      required String trackId,
      required int position,
      Value<int> rowid,
    });
typedef $$LocalPlaylistTracksTableUpdateCompanionBuilder =
    LocalPlaylistTracksCompanion Function({
      Value<String> playlistId,
      Value<String> trackId,
      Value<int> position,
      Value<int> rowid,
    });

class $$LocalPlaylistTracksTableFilterComposer
    extends Composer<_$AuraDatabase, $LocalPlaylistTracksTable> {
  $$LocalPlaylistTracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackId => $composableBuilder(
    column: $table.trackId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalPlaylistTracksTableOrderingComposer
    extends Composer<_$AuraDatabase, $LocalPlaylistTracksTable> {
  $$LocalPlaylistTracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackId => $composableBuilder(
    column: $table.trackId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPlaylistTracksTableAnnotationComposer
    extends Composer<_$AuraDatabase, $LocalPlaylistTracksTable> {
  $$LocalPlaylistTracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get trackId =>
      $composableBuilder(column: $table.trackId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$LocalPlaylistTracksTableTableManager
    extends
        RootTableManager<
          _$AuraDatabase,
          $LocalPlaylistTracksTable,
          LocalPlaylistTrack,
          $$LocalPlaylistTracksTableFilterComposer,
          $$LocalPlaylistTracksTableOrderingComposer,
          $$LocalPlaylistTracksTableAnnotationComposer,
          $$LocalPlaylistTracksTableCreateCompanionBuilder,
          $$LocalPlaylistTracksTableUpdateCompanionBuilder,
          (
            LocalPlaylistTrack,
            BaseReferences<
              _$AuraDatabase,
              $LocalPlaylistTracksTable,
              LocalPlaylistTrack
            >,
          ),
          LocalPlaylistTrack,
          PrefetchHooks Function()
        > {
  $$LocalPlaylistTracksTableTableManager(
    _$AuraDatabase db,
    $LocalPlaylistTracksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPlaylistTracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalPlaylistTracksTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalPlaylistTracksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> playlistId = const Value.absent(),
                Value<String> trackId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPlaylistTracksCompanion(
                playlistId: playlistId,
                trackId: trackId,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String playlistId,
                required String trackId,
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => LocalPlaylistTracksCompanion.insert(
                playlistId: playlistId,
                trackId: trackId,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalPlaylistTracksTableProcessedTableManager =
    ProcessedTableManager<
      _$AuraDatabase,
      $LocalPlaylistTracksTable,
      LocalPlaylistTrack,
      $$LocalPlaylistTracksTableFilterComposer,
      $$LocalPlaylistTracksTableOrderingComposer,
      $$LocalPlaylistTracksTableAnnotationComposer,
      $$LocalPlaylistTracksTableCreateCompanionBuilder,
      $$LocalPlaylistTracksTableUpdateCompanionBuilder,
      (
        LocalPlaylistTrack,
        BaseReferences<
          _$AuraDatabase,
          $LocalPlaylistTracksTable,
          LocalPlaylistTrack
        >,
      ),
      LocalPlaylistTrack,
      PrefetchHooks Function()
    >;
typedef $$QueueEntriesTableCreateCompanionBuilder =
    QueueEntriesCompanion Function({
      Value<int> id,
      required String trackId,
      required int position,
    });
typedef $$QueueEntriesTableUpdateCompanionBuilder =
    QueueEntriesCompanion Function({
      Value<int> id,
      Value<String> trackId,
      Value<int> position,
    });

class $$QueueEntriesTableFilterComposer
    extends Composer<_$AuraDatabase, $QueueEntriesTable> {
  $$QueueEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackId => $composableBuilder(
    column: $table.trackId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QueueEntriesTableOrderingComposer
    extends Composer<_$AuraDatabase, $QueueEntriesTable> {
  $$QueueEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackId => $composableBuilder(
    column: $table.trackId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QueueEntriesTableAnnotationComposer
    extends Composer<_$AuraDatabase, $QueueEntriesTable> {
  $$QueueEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get trackId =>
      $composableBuilder(column: $table.trackId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$QueueEntriesTableTableManager
    extends
        RootTableManager<
          _$AuraDatabase,
          $QueueEntriesTable,
          QueueEntry,
          $$QueueEntriesTableFilterComposer,
          $$QueueEntriesTableOrderingComposer,
          $$QueueEntriesTableAnnotationComposer,
          $$QueueEntriesTableCreateCompanionBuilder,
          $$QueueEntriesTableUpdateCompanionBuilder,
          (
            QueueEntry,
            BaseReferences<_$AuraDatabase, $QueueEntriesTable, QueueEntry>,
          ),
          QueueEntry,
          PrefetchHooks Function()
        > {
  $$QueueEntriesTableTableManager(_$AuraDatabase db, $QueueEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QueueEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QueueEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QueueEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> trackId = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => QueueEntriesCompanion(
                id: id,
                trackId: trackId,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String trackId,
                required int position,
              }) => QueueEntriesCompanion.insert(
                id: id,
                trackId: trackId,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QueueEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AuraDatabase,
      $QueueEntriesTable,
      QueueEntry,
      $$QueueEntriesTableFilterComposer,
      $$QueueEntriesTableOrderingComposer,
      $$QueueEntriesTableAnnotationComposer,
      $$QueueEntriesTableCreateCompanionBuilder,
      $$QueueEntriesTableUpdateCompanionBuilder,
      (
        QueueEntry,
        BaseReferences<_$AuraDatabase, $QueueEntriesTable, QueueEntry>,
      ),
      QueueEntry,
      PrefetchHooks Function()
    >;
typedef $$PlaybackStatesTableCreateCompanionBuilder =
    PlaybackStatesCompanion Function({
      Value<String> key,
      Value<String?> trackId,
      Value<int> positionMs,
      Value<int> queueIndex,
      Value<String> repeatMode,
      Value<bool> shuffle,
      Value<double> speed,
      Value<double> volume,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$PlaybackStatesTableUpdateCompanionBuilder =
    PlaybackStatesCompanion Function({
      Value<String> key,
      Value<String?> trackId,
      Value<int> positionMs,
      Value<int> queueIndex,
      Value<String> repeatMode,
      Value<bool> shuffle,
      Value<double> speed,
      Value<double> volume,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$PlaybackStatesTableFilterComposer
    extends Composer<_$AuraDatabase, $PlaybackStatesTable> {
  $$PlaybackStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackId => $composableBuilder(
    column: $table.trackId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get positionMs => $composableBuilder(
    column: $table.positionMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get queueIndex => $composableBuilder(
    column: $table.queueIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatMode => $composableBuilder(
    column: $table.repeatMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get shuffle => $composableBuilder(
    column: $table.shuffle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get volume => $composableBuilder(
    column: $table.volume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlaybackStatesTableOrderingComposer
    extends Composer<_$AuraDatabase, $PlaybackStatesTable> {
  $$PlaybackStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackId => $composableBuilder(
    column: $table.trackId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get positionMs => $composableBuilder(
    column: $table.positionMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get queueIndex => $composableBuilder(
    column: $table.queueIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatMode => $composableBuilder(
    column: $table.repeatMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get shuffle => $composableBuilder(
    column: $table.shuffle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get volume => $composableBuilder(
    column: $table.volume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlaybackStatesTableAnnotationComposer
    extends Composer<_$AuraDatabase, $PlaybackStatesTable> {
  $$PlaybackStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get trackId =>
      $composableBuilder(column: $table.trackId, builder: (column) => column);

  GeneratedColumn<int> get positionMs => $composableBuilder(
    column: $table.positionMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get queueIndex => $composableBuilder(
    column: $table.queueIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repeatMode => $composableBuilder(
    column: $table.repeatMode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get shuffle =>
      $composableBuilder(column: $table.shuffle, builder: (column) => column);

  GeneratedColumn<double> get speed =>
      $composableBuilder(column: $table.speed, builder: (column) => column);

  GeneratedColumn<double> get volume =>
      $composableBuilder(column: $table.volume, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PlaybackStatesTableTableManager
    extends
        RootTableManager<
          _$AuraDatabase,
          $PlaybackStatesTable,
          PlaybackState,
          $$PlaybackStatesTableFilterComposer,
          $$PlaybackStatesTableOrderingComposer,
          $$PlaybackStatesTableAnnotationComposer,
          $$PlaybackStatesTableCreateCompanionBuilder,
          $$PlaybackStatesTableUpdateCompanionBuilder,
          (
            PlaybackState,
            BaseReferences<_$AuraDatabase, $PlaybackStatesTable, PlaybackState>,
          ),
          PlaybackState,
          PrefetchHooks Function()
        > {
  $$PlaybackStatesTableTableManager(
    _$AuraDatabase db,
    $PlaybackStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaybackStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaybackStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaybackStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String?> trackId = const Value.absent(),
                Value<int> positionMs = const Value.absent(),
                Value<int> queueIndex = const Value.absent(),
                Value<String> repeatMode = const Value.absent(),
                Value<bool> shuffle = const Value.absent(),
                Value<double> speed = const Value.absent(),
                Value<double> volume = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaybackStatesCompanion(
                key: key,
                trackId: trackId,
                positionMs: positionMs,
                queueIndex: queueIndex,
                repeatMode: repeatMode,
                shuffle: shuffle,
                speed: speed,
                volume: volume,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String?> trackId = const Value.absent(),
                Value<int> positionMs = const Value.absent(),
                Value<int> queueIndex = const Value.absent(),
                Value<String> repeatMode = const Value.absent(),
                Value<bool> shuffle = const Value.absent(),
                Value<double> speed = const Value.absent(),
                Value<double> volume = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaybackStatesCompanion.insert(
                key: key,
                trackId: trackId,
                positionMs: positionMs,
                queueIndex: queueIndex,
                repeatMode: repeatMode,
                shuffle: shuffle,
                speed: speed,
                volume: volume,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlaybackStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AuraDatabase,
      $PlaybackStatesTable,
      PlaybackState,
      $$PlaybackStatesTableFilterComposer,
      $$PlaybackStatesTableOrderingComposer,
      $$PlaybackStatesTableAnnotationComposer,
      $$PlaybackStatesTableCreateCompanionBuilder,
      $$PlaybackStatesTableUpdateCompanionBuilder,
      (
        PlaybackState,
        BaseReferences<_$AuraDatabase, $PlaybackStatesTable, PlaybackState>,
      ),
      PlaybackState,
      PrefetchHooks Function()
    >;
typedef $$OutboxPlaysTableCreateCompanionBuilder =
    OutboxPlaysCompanion Function({
      Value<int> id,
      required String trackId,
      required DateTime startedAt,
      required int msPlayed,
      Value<bool> completed,
      required String idempotencyKey,
      Value<bool> sent,
      Value<DateTime> createdAt,
    });
typedef $$OutboxPlaysTableUpdateCompanionBuilder =
    OutboxPlaysCompanion Function({
      Value<int> id,
      Value<String> trackId,
      Value<DateTime> startedAt,
      Value<int> msPlayed,
      Value<bool> completed,
      Value<String> idempotencyKey,
      Value<bool> sent,
      Value<DateTime> createdAt,
    });

class $$OutboxPlaysTableFilterComposer
    extends Composer<_$AuraDatabase, $OutboxPlaysTable> {
  $$OutboxPlaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackId => $composableBuilder(
    column: $table.trackId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get msPlayed => $composableBuilder(
    column: $table.msPlayed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sent => $composableBuilder(
    column: $table.sent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxPlaysTableOrderingComposer
    extends Composer<_$AuraDatabase, $OutboxPlaysTable> {
  $$OutboxPlaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackId => $composableBuilder(
    column: $table.trackId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get msPlayed => $composableBuilder(
    column: $table.msPlayed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sent => $composableBuilder(
    column: $table.sent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxPlaysTableAnnotationComposer
    extends Composer<_$AuraDatabase, $OutboxPlaysTable> {
  $$OutboxPlaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get trackId =>
      $composableBuilder(column: $table.trackId, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get msPlayed =>
      $composableBuilder(column: $table.msPlayed, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get sent =>
      $composableBuilder(column: $table.sent, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$OutboxPlaysTableTableManager
    extends
        RootTableManager<
          _$AuraDatabase,
          $OutboxPlaysTable,
          OutboxPlay,
          $$OutboxPlaysTableFilterComposer,
          $$OutboxPlaysTableOrderingComposer,
          $$OutboxPlaysTableAnnotationComposer,
          $$OutboxPlaysTableCreateCompanionBuilder,
          $$OutboxPlaysTableUpdateCompanionBuilder,
          (
            OutboxPlay,
            BaseReferences<_$AuraDatabase, $OutboxPlaysTable, OutboxPlay>,
          ),
          OutboxPlay,
          PrefetchHooks Function()
        > {
  $$OutboxPlaysTableTableManager(_$AuraDatabase db, $OutboxPlaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxPlaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxPlaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxPlaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> trackId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<int> msPlayed = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<bool> sent = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => OutboxPlaysCompanion(
                id: id,
                trackId: trackId,
                startedAt: startedAt,
                msPlayed: msPlayed,
                completed: completed,
                idempotencyKey: idempotencyKey,
                sent: sent,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String trackId,
                required DateTime startedAt,
                required int msPlayed,
                Value<bool> completed = const Value.absent(),
                required String idempotencyKey,
                Value<bool> sent = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => OutboxPlaysCompanion.insert(
                id: id,
                trackId: trackId,
                startedAt: startedAt,
                msPlayed: msPlayed,
                completed: completed,
                idempotencyKey: idempotencyKey,
                sent: sent,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxPlaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AuraDatabase,
      $OutboxPlaysTable,
      OutboxPlay,
      $$OutboxPlaysTableFilterComposer,
      $$OutboxPlaysTableOrderingComposer,
      $$OutboxPlaysTableAnnotationComposer,
      $$OutboxPlaysTableCreateCompanionBuilder,
      $$OutboxPlaysTableUpdateCompanionBuilder,
      (
        OutboxPlay,
        BaseReferences<_$AuraDatabase, $OutboxPlaysTable, OutboxPlay>,
      ),
      OutboxPlay,
      PrefetchHooks Function()
    >;
typedef $$CachedLyricsTableCreateCompanionBuilder =
    CachedLyricsCompanion Function({
      required String trackId,
      Value<String> kind,
      Value<String> source,
      Value<int> offsetMs,
      Value<String> plainText,
      Value<String> linesJson,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });
typedef $$CachedLyricsTableUpdateCompanionBuilder =
    CachedLyricsCompanion Function({
      Value<String> trackId,
      Value<String> kind,
      Value<String> source,
      Value<int> offsetMs,
      Value<String> plainText,
      Value<String> linesJson,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$CachedLyricsTableFilterComposer
    extends Composer<_$AuraDatabase, $CachedLyricsTable> {
  $$CachedLyricsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get trackId => $composableBuilder(
    column: $table.trackId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get offsetMs => $composableBuilder(
    column: $table.offsetMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plainText => $composableBuilder(
    column: $table.plainText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linesJson => $composableBuilder(
    column: $table.linesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedLyricsTableOrderingComposer
    extends Composer<_$AuraDatabase, $CachedLyricsTable> {
  $$CachedLyricsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get trackId => $composableBuilder(
    column: $table.trackId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get offsetMs => $composableBuilder(
    column: $table.offsetMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plainText => $composableBuilder(
    column: $table.plainText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linesJson => $composableBuilder(
    column: $table.linesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedLyricsTableAnnotationComposer
    extends Composer<_$AuraDatabase, $CachedLyricsTable> {
  $$CachedLyricsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get trackId =>
      $composableBuilder(column: $table.trackId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get offsetMs =>
      $composableBuilder(column: $table.offsetMs, builder: (column) => column);

  GeneratedColumn<String> get plainText =>
      $composableBuilder(column: $table.plainText, builder: (column) => column);

  GeneratedColumn<String> get linesJson =>
      $composableBuilder(column: $table.linesJson, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$CachedLyricsTableTableManager
    extends
        RootTableManager<
          _$AuraDatabase,
          $CachedLyricsTable,
          CachedLyric,
          $$CachedLyricsTableFilterComposer,
          $$CachedLyricsTableOrderingComposer,
          $$CachedLyricsTableAnnotationComposer,
          $$CachedLyricsTableCreateCompanionBuilder,
          $$CachedLyricsTableUpdateCompanionBuilder,
          (
            CachedLyric,
            BaseReferences<_$AuraDatabase, $CachedLyricsTable, CachedLyric>,
          ),
          CachedLyric,
          PrefetchHooks Function()
        > {
  $$CachedLyricsTableTableManager(_$AuraDatabase db, $CachedLyricsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedLyricsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedLyricsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedLyricsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> trackId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> offsetMs = const Value.absent(),
                Value<String> plainText = const Value.absent(),
                Value<String> linesJson = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedLyricsCompanion(
                trackId: trackId,
                kind: kind,
                source: source,
                offsetMs: offsetMs,
                plainText: plainText,
                linesJson: linesJson,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String trackId,
                Value<String> kind = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> offsetMs = const Value.absent(),
                Value<String> plainText = const Value.absent(),
                Value<String> linesJson = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedLyricsCompanion.insert(
                trackId: trackId,
                kind: kind,
                source: source,
                offsetMs: offsetMs,
                plainText: plainText,
                linesJson: linesJson,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedLyricsTableProcessedTableManager =
    ProcessedTableManager<
      _$AuraDatabase,
      $CachedLyricsTable,
      CachedLyric,
      $$CachedLyricsTableFilterComposer,
      $$CachedLyricsTableOrderingComposer,
      $$CachedLyricsTableAnnotationComposer,
      $$CachedLyricsTableCreateCompanionBuilder,
      $$CachedLyricsTableUpdateCompanionBuilder,
      (
        CachedLyric,
        BaseReferences<_$AuraDatabase, $CachedLyricsTable, CachedLyric>,
      ),
      CachedLyric,
      PrefetchHooks Function()
    >;
typedef $$SyncMetaTableCreateCompanionBuilder =
    SyncMetaCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SyncMetaTableUpdateCompanionBuilder =
    SyncMetaCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SyncMetaTableFilterComposer
    extends Composer<_$AuraDatabase, $SyncMetaTable> {
  $$SyncMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetaTableOrderingComposer
    extends Composer<_$AuraDatabase, $SyncMetaTable> {
  $$SyncMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetaTableAnnotationComposer
    extends Composer<_$AuraDatabase, $SyncMetaTable> {
  $$SyncMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SyncMetaTableTableManager
    extends
        RootTableManager<
          _$AuraDatabase,
          $SyncMetaTable,
          SyncMetaData,
          $$SyncMetaTableFilterComposer,
          $$SyncMetaTableOrderingComposer,
          $$SyncMetaTableAnnotationComposer,
          $$SyncMetaTableCreateCompanionBuilder,
          $$SyncMetaTableUpdateCompanionBuilder,
          (
            SyncMetaData,
            BaseReferences<_$AuraDatabase, $SyncMetaTable, SyncMetaData>,
          ),
          SyncMetaData,
          PrefetchHooks Function()
        > {
  $$SyncMetaTableTableManager(_$AuraDatabase db, $SyncMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SyncMetaCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AuraDatabase,
      $SyncMetaTable,
      SyncMetaData,
      $$SyncMetaTableFilterComposer,
      $$SyncMetaTableOrderingComposer,
      $$SyncMetaTableAnnotationComposer,
      $$SyncMetaTableCreateCompanionBuilder,
      $$SyncMetaTableUpdateCompanionBuilder,
      (
        SyncMetaData,
        BaseReferences<_$AuraDatabase, $SyncMetaTable, SyncMetaData>,
      ),
      SyncMetaData,
      PrefetchHooks Function()
    >;

class $AuraDatabaseManager {
  final _$AuraDatabase _db;
  $AuraDatabaseManager(this._db);
  $$LocalTracksTableTableManager get localTracks =>
      $$LocalTracksTableTableManager(_db, _db.localTracks);
  $$LocalAlbumsTableTableManager get localAlbums =>
      $$LocalAlbumsTableTableManager(_db, _db.localAlbums);
  $$LocalArtistsTableTableManager get localArtists =>
      $$LocalArtistsTableTableManager(_db, _db.localArtists);
  $$LocalPlaylistsTableTableManager get localPlaylists =>
      $$LocalPlaylistsTableTableManager(_db, _db.localPlaylists);
  $$LocalPlaylistTracksTableTableManager get localPlaylistTracks =>
      $$LocalPlaylistTracksTableTableManager(_db, _db.localPlaylistTracks);
  $$QueueEntriesTableTableManager get queueEntries =>
      $$QueueEntriesTableTableManager(_db, _db.queueEntries);
  $$PlaybackStatesTableTableManager get playbackStates =>
      $$PlaybackStatesTableTableManager(_db, _db.playbackStates);
  $$OutboxPlaysTableTableManager get outboxPlays =>
      $$OutboxPlaysTableTableManager(_db, _db.outboxPlays);
  $$CachedLyricsTableTableManager get cachedLyrics =>
      $$CachedLyricsTableTableManager(_db, _db.cachedLyrics);
  $$SyncMetaTableTableManager get syncMeta =>
      $$SyncMetaTableTableManager(_db, _db.syncMeta);
}

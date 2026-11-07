import 'dart:io';

import 'package:aura/data/local/database.dart';
import 'package:aura/features/downloads/download_controller.dart';
import 'package:flutter_test/flutter_test.dart';

LocalTrack _track({String? path}) {
  final now = DateTime(2026, 1, 1);
  return LocalTrack(
    id: 't1',
    title: 'Luz de luna',
    titleNorm: 'luz de luna',
    artistNames: 'Marina Azul',
    artistIds: 'a1',
    sourceProvider: 'local',
    sourceRef: '1',
    status: 'ready',
    explicit: false,
    favorite: false,
    addedAt: now,
    updatedAt: now,
    cachedAt: now,
    localAudioPath: path,
  );
}

void main() {
  test('DownloadState reports progress and busy tracks', () {
    const state = DownloadState(
      tasks: {
        't1': DownloadTask(
          trackId: 't1',
          status: DownloadStatus.downloading,
          progress: 0.42,
        ),
        't2': DownloadTask(
          trackId: 't2',
          status: DownloadStatus.completed,
          progress: 1,
        ),
      },
    );

    expect(state.forTrack('t1')?.isBusy, isTrue);
    expect(state.forTrack('t1')?.progress, 0.42);
    expect(state.isDownloaded('t2'), isTrue);
    expect(state.hasActiveDownloads, isTrue);
    expect(state.forTrack('missing'), isNull);
  });

  test('isLocallyAvailable checks the file on disk', () async {
    final directory = await Directory.systemTemp.createTemp('aura-download');
    final file = File('${directory.path}/track.m4a');
    await file.writeAsBytes([1, 2, 3]);
    try {
      expect(hasLocalAudio(_track()), isFalse);
      expect(isLocallyAvailable(_track()), isFalse);
      expect(hasLocalAudio(_track(path: file.path)), isTrue);
      expect(isLocallyAvailable(_track(path: file.path)), isTrue);
      await file.delete();
      expect(hasLocalAudio(_track(path: file.path)), isTrue);
      expect(isLocallyAvailable(_track(path: file.path)), isFalse);
    } finally {
      await directory.delete(recursive: true);
    }
  });
}

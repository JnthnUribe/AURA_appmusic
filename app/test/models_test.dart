import 'package:aura/core/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Track parses the backend contract', () {
    final track = Track.fromJson({
      'id': 't1',
      'title': 'Canción',
      'title_norm': 'cancion',
      'version': 'Remastered',
      'album': {
        'id': 'a1',
        'title': 'Álbum',
        'year': 2024,
        'cover_asset_id': 'asset-1',
      },
      'artists': [
        {'id': 'ar1', 'name': 'Artista'},
        {'id': 'ar2', 'name': 'Invitado'},
      ],
      'track_no': 3,
      'duration_ms': 183000,
      'source_provider': 'youtube_music',
      'source_ref': 'abc',
      'status': 'ready',
      'added_at': '2026-01-02T03:04:05Z',
      'updated_at': '2026-01-02T03:04:05Z',
    });
    expect(track.title, 'Canción');
    expect(track.displayTitle, 'Canción (Remastered)');
    expect(track.artistNames, 'Artista, Invitado');
    expect(track.album?.year, 2024);
    expect(track.duration, const Duration(minutes: 3, seconds: 3));
  });

  test('Page parses cursors', () {
    final page = Page.fromJson({
      'items': [
        {
          'id': 't1',
          'title': 'x',
          'title_norm': 'x',
          'source_provider': 'local',
          'source_ref': '1',
          'status': 'ready',
          'added_at': '2026-01-01T00:00:00Z',
          'updated_at': '2026-01-01T00:00:00Z',
        },
      ],
      'next_cursor': 'next',
    }, Track.fromJson);
    expect(page.items.single.id, 't1');
    expect(page.nextCursor, 'next');
  });

  test('LyricsDocument serializes without losing word timings', () {
    const document = LyricsDocument(
      kind: 'synced',
      lines: [
        LyricLine(
          t: 0,
          end: 2000,
          text: 'hola mundo',
          words: [LyricWord(t: 0, text: 'hola')],
        ),
      ],
      offsetMs: 250,
      plainText: 'hola mundo',
    );
    final roundTrip = LyricsDocument.fromJson(document.toJson());
    expect(roundTrip.isSynced, isTrue);
    expect(roundTrip.offsetMs, 250);
    expect(roundTrip.lines.single.words.single.text, 'hola');
  });

  test('CoverInfo reads palette and thumbhash', () {
    final cover = CoverInfo.fromJson({
      'url': 'https://example.com/cover.webp',
      'palette': {
        'colors': ['#112233', '#445566'],
      },
      'thumbhash': 'data:image/webp;base64,AAAA',
      'expires_in': 600,
    });
    expect(cover.palette, ['#112233', '#445566']);
    expect(cover.expiresIn, 600);
  });
}

import 'package:aura/core/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('StatsOverview parses the backend overview contract', () {
    final overview = StatsOverview.fromJson({
      'range': '30d',
      'plays': 42,
      'minutes': 128.5,
      'unique_tracks': 17,
      'streak_days': 4,
      'top_tracks': [
        {
          'id': 't1',
          'title': 'Luz de luna',
          'title_norm': 'luz de luna',
          'source_provider': 'demo',
          'source_ref': 'demo:1',
          'status': 'ready',
          'added_at': '2026-01-02T03:04:05Z',
          'updated_at': '2026-01-02T03:04:05Z',
        },
      ],
      'top_artists': [
        {'name': 'Marina Azul', 'plays': 12},
      ],
    });

    expect(overview.range, '30d');
    expect(overview.plays, 42);
    expect(overview.minutes, 128.5);
    expect(overview.uniqueTracks, 17);
    expect(overview.streakDays, 4);
    expect(overview.topTracks.single.title, 'Luz de luna');
    expect(overview.topArtists.single.name, 'Marina Azul');
    expect(overview.topArtists.single.plays, 12);
    expect(overview.isEmpty, isFalse);
  });

  test('StatsOverview tolerates missing lists and reports emptiness', () {
    final overview = StatsOverview.fromJson({
      'range': '7d',
      'plays': 0,
      'minutes': 0,
      'unique_tracks': 0,
      'streak_days': 0,
    });

    expect(overview.topTracks, isEmpty);
    expect(overview.topArtists, isEmpty);
    expect(overview.isEmpty, isTrue);
  });
}

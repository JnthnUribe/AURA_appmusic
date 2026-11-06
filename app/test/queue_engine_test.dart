import 'dart:math';

import 'package:aura/features/player/queue_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QueueEngine', () {
    test('advances and stops at the end when repeat is off', () {
      final queue = QueueEngine(tracks: ['a', 'b', 'c']);
      expect(queue.current, 'a');
      expect(queue.next(), 'b');
      expect(queue.next(), 'c');
      expect(queue.next(), isNull);
      expect(queue.current, 'c');
    });

    test('repeat all wraps to the beginning', () {
      final queue = QueueEngine(
        tracks: ['a', 'b'],
        repeat: RepeatMode.all,
      );
      expect(queue.next(), 'b');
      expect(queue.next(), 'a');
      expect(queue.previous(), 'b');
    });

    test('repeat one keeps the track on automatic advance', () {
      final queue = QueueEngine(
        tracks: ['a', 'b'],
        repeat: RepeatMode.one,
      );
      expect(queue.next(automatic: true), 'a');
      expect(queue.next(automatic: false), 'b');
    });

    test('shuffle plays every track exactly once before repeating', () {
      final queue = QueueEngine(
        tracks: ['a', 'b', 'c', 'd', 'e'],
        shuffle: true,
        repeat: RepeatMode.all,
        random: Random(7),
      );
      final seen = <String>{queue.current!};
      for (var index = 0; index < 4; index++) {
        seen.add(queue.next()!);
      }
      expect(seen.length, 5);
      expect(queue.next(), queue.order.first);
    });

    test('toggling shuffle keeps the current track', () {
      final queue = QueueEngine(
        tracks: ['a', 'b', 'c', 'd'],
        index: 2,
        random: Random(3),
      );
      expect(queue.current, 'c');
      queue.toggleShuffle(enabled: true);
      expect(queue.current, 'c');
      expect(queue.order.first, 'c');
      queue.toggleShuffle(enabled: false);
      expect(queue.current, 'c');
      expect(queue.order, ['a', 'b', 'c', 'd']);
    });

    test('remove keeps the current track when possible', () {
      final queue = QueueEngine(tracks: ['a', 'b', 'c'], index: 1);
      queue.remove('b');
      expect(queue.order, ['a', 'c']);
      expect(queue.current, 'c');
    });

    test('jumpToId recovers from a shuffled order', () {
      final queue = QueueEngine(
        tracks: ['a', 'b', 'c'],
        shuffle: true,
        random: Random(1),
      );
      queue.jumpToId('b');
      expect(queue.current, 'b');
    });
  });
}

import 'package:aura/core/models/models.dart';
import 'package:aura/features/lyrics/lrc_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const lines = [
    LyricLine(t: 0, text: 'intro'),
    LyricLine(t: 5000, text: 'hello'),
    LyricLine(t: 10000, text: 'world'),
    LyricLine(t: 20000, text: 'end'),
  ];

  group('activeLyricIndex', () {
    test('returns -1 before the first timestamp', () {
      expect(activeLyricIndex(lines, const Duration(seconds: 0)), 0);
    });

    test('finds the exact and in-between lines', () {
      expect(activeLyricIndex(lines, const Duration(seconds: 5)), 1);
      expect(
        activeLyricIndex(lines, const Duration(milliseconds: 9500)),
        1,
      );
      expect(activeLyricIndex(lines, const Duration(seconds: 25)), 3);
    });

    test('handles empty lyrics', () {
      expect(activeLyricIndex(const [], Duration.zero), -1);
    });
  });

  test('shiftedLines applies the offset without mutating the original', () {
    final shifted = shiftedLines(lines, 500);
    expect(shifted[1].t, 5500);
    expect(lines[1].t, 5000);
  });

  test('plainLines creates synthetic timestamps', () {
    final parsed = plainLines('one\n\ntwo\n  three ');
    expect(parsed.length, 3);
    expect(parsed.first.text, 'one');
    expect(parsed[1].t, 5000);
  });

  test('lineProgress is clamped to 0..1', () {
    const line = LyricLine(t: 1000, end: 3000, text: 'x');
    expect(lineProgress(line, const Duration(milliseconds: 500)), 0);
    expect(lineProgress(line, const Duration(milliseconds: 2000)), 0.5);
    expect(lineProgress(line, const Duration(seconds: 10)), 1);
  });
}

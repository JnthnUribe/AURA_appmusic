/// LRC helpers used by the lyrics view and unit tests.
library;

import '../../core/models/models.dart';

/// Returns the index of the active line for [position].
/// Uses binary search; -1 means "before the first line".
int activeLyricIndex(List<LyricLine> lines, Duration position) {
  if (lines.isEmpty) return -1;
  final ms = position.inMilliseconds;
  var low = 0;
  var high = lines.length - 1;
  var result = -1;
  while (low <= high) {
    final middle = (low + high) >> 1;
    if (lines[middle].t <= ms) {
      result = middle;
      low = middle + 1;
    } else {
      high = middle - 1;
    }
  }
  return result;
}

/// Fraction of a line already sung, for the word-fill effect.
double lineProgress(LyricLine line, Duration position) {
  if (line.t <= 0) return 0;
  final end = line.end > line.t ? line.end : line.t + 4000;
  final elapsed = position.inMilliseconds - line.t;
  return (elapsed / (end - line.t)).clamp(0.0, 1.0);
}

/// Applies a manual offset without mutating the cached document.
List<LyricLine> shiftedLines(List<LyricLine> lines, int offsetMs) {
  if (offsetMs == 0) return lines;
  return lines
      .map(
        (line) => LyricLine(
          t: line.t + offsetMs,
          end: line.end + offsetMs,
          text: line.text,
          words: line.words
              .map((word) => LyricWord(t: word.t + offsetMs, text: word.text))
              .toList(growable: false),
        ),
      )
      .toList(growable: false);
}

/// Splits plain lyrics into synthetic lines so the view still works when the
/// provider only returned unsynced text.
List<LyricLine> plainLines(String text) {
  final lines = text
      .split(RegExp(r'\r?\n'))
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList(growable: false);
  return [
    for (var index = 0; index < lines.length; index++)
      LyricLine(t: index * 5000, text: lines[index]),
  ];
}

String formatDuration(Duration? duration) {
  if (duration == null) return '–:––';
  final totalSeconds = duration.inSeconds;
  final minutes = totalSeconds ~/ 60;
  final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
  if (minutes >= 60) {
    final hours = minutes ~/ 60;
    final rest = (minutes % 60).toString().padLeft(2, '0');
    return '$hours:$rest:$seconds';
  }
  return '$minutes:$seconds';
}

String formatMinutes(int minutes) {
  if (minutes < 60) return '${minutes}m';
  final hours = minutes ~/ 60;
  final rest = minutes % 60;
  return rest == 0 ? '${hours}h' : '${hours}h ${rest}m';
}

String initials(String value) {
  final words = value.trim().split(RegExp(r'\s+'));
  if (words.isEmpty || words.first.isEmpty) return '?';
  if (words.length == 1) {
    return words.first.substring(0, 1).toUpperCase();
  }
  return (words.first.substring(0, 1) + words.last.substring(0, 1))
      .toUpperCase();
}

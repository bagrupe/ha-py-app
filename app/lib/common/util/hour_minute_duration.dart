/// Formats [duration] as an hour and minute clock value such as `6:15`.
String formatHourMinuteDuration(Duration duration) {
  final absolute = duration.abs();
  final hours = absolute.inHours;
  final minutes = absolute.inMinutes.remainder(60);
  final value = '$hours:${minutes.toString().padLeft(2, '0')}';
  return duration.isNegative ? '-$value' : value;
}

import 'package:easy_localization/easy_localization.dart';

/// Formats volunteer interest timestamps for compact card headers.
abstract final class VolunteerInterestTimestamp {
  /// Formats [timestamp] relative to [now].
  static String format(DateTime timestamp, {DateTime? now}) {
    const basePath = 'application.profile.volunteer_interests.time';
    final localTimestamp = timestamp.toLocal();
    final difference = (now ?? DateTime.now()).difference(localTimestamp);
    if (difference.inMinutes < 1) return '$basePath.now'.tr();
    if (difference.inHours < 1) {
      return '$basePath.minutes'.tr(
        namedArgs: {'count': '${difference.inMinutes}'},
      );
    }
    if (difference.inDays < 1) {
      return '$basePath.hours'.tr(
        namedArgs: {'count': '${difference.inHours}'},
      );
    }
    if (difference.inDays < 7) {
      return '$basePath.days'.tr(namedArgs: {'count': '${difference.inDays}'});
    }
    return DateFormat.yMd('de').format(localTimestamp);
  }
}

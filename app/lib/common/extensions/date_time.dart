import 'package:easy_localization/easy_localization.dart';

/// Erweiterung für DateTime mit zusätzlichen Hilfsmethoden.
extension DateTimeExtensions on DateTime {
  /// Prüft, ob das Datum mit einem anderen Datum am gleichen Kalendertag liegt.
  bool isSameCalendarDayAs(DateTime other) =>
      day == other.day && month == other.month && year == other.year;

  /// Formatiert das Datum relativ zum aktuellen oder angegebenen Referenzdatum.
  /// Nutzt unterschiedliche Formate für heute, gestern, letzte Woche und sonst.
  String formatRelative(
    String defaultDateFormat, [
    String restFormatString = '',
    DateTime? referenceNow,
  ]) {
    final now = referenceNow ?? DateTime.now();

    final formattedRest = DateFormat(restFormatString).format(this);

    final isToday = isSameCalendarDayAs(now);
    if (isToday) {
      return '${'application.common.today'.tr()} $formattedRest'.trim();
    }

    final wasYesterday = isSameCalendarDayAs(
      now.subtract(const Duration(days: 1)),
    );
    if (wasYesterday) {
      return '${'application.common.yesterday'.tr()} $formattedRest'.trim();
    }

    final wasLastWeek = isAfter(now.subtract(const Duration(days: 6)));
    if (wasLastWeek) return DateFormat('E $restFormatString').format(this);

    return DateFormat('$defaultDateFormat $restFormatString').format(this);
  }
}

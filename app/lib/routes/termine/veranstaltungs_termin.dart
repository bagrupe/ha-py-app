import 'package:app/common/extensions/date_time.dart';
import 'package:intl/intl.dart';

/// Repräsentiert einen Termin einer Veranstaltung mit Start- und Endzeit sowie zugehörigen Metadaten.
class VeranstaltungsTermin {
  /// Erstellt eine Instanz von [VeranstaltungsTermin] mit den erforderlichen Daten.
  VeranstaltungsTermin({
    required this.veranstaltungsId,
    required this.start,
    required this.end,
    required this.titel,
    required this.subtitel,
    required this.imageUrl,
    required this.thumbnailImageUrl,
    required this.termineOnSameDay,
  });

  /// Datumsformat für die Anzeige von Datum und Wochentag.
  static const String dateFormat = 'EEE - dd.MM.yyyy';

  /// Zeitformat für die Anzeige der Uhrzeit.
  static const String timeFormat = "HH:mm 'Uhr'";

  /// Kombiniertes Format für Datum und Uhrzeit.
  static const String dateTimeFormat = '$dateFormat $timeFormat';

  /// Eindeutige ID der Veranstaltung.
  final String veranstaltungsId;

  /// Startzeitpunkt des Termins.
  final DateTime start;

  /// Endzeitpunkt des Termins.
  final DateTime end;

  /// Titel der Veranstaltung.
  final String titel;

  /// Untertitel oder ergänzende Beschreibung der Veranstaltung.
  final String subtitel;

  /// URL zum Bild der Veranstaltung, falls vorhanden.
  final String? imageUrl;

  /// URL zum Vorschaubild der Veranstaltung, falls vorhanden.
  final String? thumbnailImageUrl;

  /// Liste weiterer Termine am selben Tag.
  final List<DateTime> termineOnSameDay;

  /// Gibt zurück, ob der Termin sich über mehrere Tage erstreckt.
  bool get isMultipleDays => !start.isSameCalendarDayAs(end);

  /// Formats the date and time of the appointment as a string.
  /// Always uses German locale formatting.
  String get formattedDateTimeString {
    if (!isMultipleDays) {
      final formatter = DateFormat(dateTimeFormat, 'de');
      return formatter.format(start.toLocal());
    }

    final formatter = DateFormat(dateFormat, 'de');
    return '${formatter.format(start.toLocal())} bis ${formatter.format(end.toLocal())}';
  }

  /// Formatiert die Uhrzeit des Termins als String.
  String get formattedTimeString {
    final formatter = DateFormat(timeFormat);
    return formatter.format(start.toLocal());
  }

  /// Formatiert das Datum des Termins als String.
  String get formattedDateString {
    final formatter = DateFormat(dateFormat);
    return formatter.format(start.toLocal());
  }
}

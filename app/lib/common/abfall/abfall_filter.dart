import 'package:freezed_annotation/freezed_annotation.dart';

part 'abfall_filter.freezed.dart';
part 'abfall_filter.g.dart';

/// Enthält Schlüssel für die Speicherung der Abfallfilter-Einstellungen.
class AbfallFilterKeys {
  static const ortId = 'ort_filter';
  static const anfangsbuchstabe = 'anfangsbuchstabe_filter';
  static const strasseId = 'straße_filter';
  static const standortId = 'standort_filter';
  static const zusatzId = 'zusatz_filter';
  static const fraktionen = 'fraktionen_filter';
  static const abfallFilter = 'abfall_filter';
}

/// Modell für die Filtereinstellungen der Abfallinformationen.
@freezed
abstract class AbfallFilter with _$AbfallFilter {
  /// Erzeugt eine neue Instanz mit optionalen Filterwerten.
  factory AbfallFilter({
    String? ort,
    String? strasse,
    String? anfangsbuchstabe,
    String? standort,
    String? fraktionen,
  }) = _AbfallFilter;

  /// Erzeugt eine Instanz aus einer JSON-Darstellung.
  factory AbfallFilter.fromJson(Map<String, dynamic> json) =>
      _$AbfallFilterFromJson(json);
}

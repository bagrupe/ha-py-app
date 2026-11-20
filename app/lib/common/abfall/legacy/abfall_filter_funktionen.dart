import 'package:app/common/abfall/abfall_filter.dart';

/// Legacy manual functions kept temporarily for testing purposes.
/// These should be removed at a later point when migration is fully complete.
extension LegacyAbfallFilter on AbfallFilter {
  /// Erzeugt eine Instanz aus einer JSON-Darstellung.
  static AbfallFilter legacyFromJson(Map<String, dynamic> parsedJson) {
    return AbfallFilter(
      ort: parsedJson['ort'] as String?,
      anfangsbuchstabe: parsedJson['anfangsbuchstabe'] as String?,
      strasse: parsedJson['strasse'] as String?,
      standort: parsedJson['standort'] as String?,
      fraktionen: parsedJson['fraktionen'] as String?,
    );
  }

  /// Gibt eine Kopie mit optional geänderten Filterwerten zurück.
  AbfallFilter legacyCopyWith({
    String? ort,
    String? anfangsbuchstabe,
    String? strasse,
    String? standort,
    String? fraktionen,
  }) {
    return AbfallFilter(
      ort: ort ?? this.ort,
      anfangsbuchstabe: anfangsbuchstabe ?? this.anfangsbuchstabe,
      strasse: strasse ?? this.strasse,
      standort: standort ?? this.standort,
      fraktionen: fraktionen ?? this.fraktionen,
    );
  }

  /// Wandelt die Instanz in eine JSON-Darstellung um.
  Map<String, dynamic> legacyToJson() {
    return {
      'ort': ort,
      'strasse': strasse,
      'anfangsbuchstabe': anfangsbuchstabe,
      'standort': standort,
      'fraktionen': fraktionen,
    };
  }
}

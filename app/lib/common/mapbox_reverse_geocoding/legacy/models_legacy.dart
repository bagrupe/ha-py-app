import 'package:json_annotation/json_annotation.dart';

part 'models_legacy.g.dart';

/// Repräsentiert die Gesamtergebnisse der Mapbox-Umkehr-Geokodierung.
@JsonSerializable(fieldRename: FieldRename.snake)
class LegacyMapboxReverseGeocodingResults {
  /// Erzeugt eine Instanz mit einer Liste von Geokodierungsergebnissen.
  LegacyMapboxReverseGeocodingResults(this.features);

  /// Erzeugt eine Instanz aus einem JSON-Objekt.
  factory LegacyMapboxReverseGeocodingResults.fromJson(
    Map<String, dynamic> json,
  ) => _$LegacyMapboxReverseGeocodingResultsFromJson(json);

  /// Liste der einzelnen Geokodierungsergebnisse.
  final List<LegacyMapboxReverseGeocodingResult> features;

  /// Wandelt die Instanz in ein JSON-Objekt um.
  Map<String, dynamic> toJson() =>
      _$LegacyMapboxReverseGeocodingResultsToJson(this);
}

/// Repräsentiert ein einzelnes Ergebnis der Mapbox-Umkehr-Geokodierung.
@JsonSerializable(fieldRename: FieldRename.snake)
class LegacyMapboxReverseGeocodingResult {
  /// Erzeugt ein Ergebnis mit ID, deutschem Ortsnamen und Ortstypen.
  LegacyMapboxReverseGeocodingResult(this.id, this.placeNameDe, this.placeType);

  /// Erzeugt eine Instanz aus einem JSON-Objekt.
  factory LegacyMapboxReverseGeocodingResult.fromJson(
    Map<String, dynamic> json,
  ) => _$LegacyMapboxReverseGeocodingResultFromJson(json);

  /// Eindeutige Kennung des Ergebnisses.
  final String id;

  /// Ortsname auf Deutsch, falls vorhanden.
  final String? placeNameDe;

  /// Typen des Ortes (z.B. Adresse, Lokalität).
  final List<String> placeType;

  /// Wandelt die Instanz in ein JSON-Objekt um.
  Map<String, dynamic> toJson() =>
      _$LegacyMapboxReverseGeocodingResultToJson(this);
}

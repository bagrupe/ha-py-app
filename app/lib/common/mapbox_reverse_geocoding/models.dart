import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

/// Repräsentiert die Gesamtergebnisse der Mapbox-Umkehr-Geokodierung.
@freezed
abstract class MapboxReverseGeocodingResults
    with _$MapboxReverseGeocodingResults {
  /// Erzeugt eine Instanz mit einer Liste von Geokodierungsergebnissen.
  const factory MapboxReverseGeocodingResults({
    required List<MapboxReverseGeocodingResult> features,
  }) = _MapboxReverseGeocodingResults;

  /// Erzeugt eine Instanz aus einem JSON-Objekt.
  factory MapboxReverseGeocodingResults.fromJson(Map<String, dynamic> json) =>
      _$MapboxReverseGeocodingResultsFromJson(json);
}

/// Repräsentiert ein einzelnes Ergebnis der Mapbox-Umkehr-Geokodierung.
@freezed
abstract class MapboxReverseGeocodingResult
    with _$MapboxReverseGeocodingResult {
  /// Erzeugt ein Ergebnis mit ID, deutschem Ortsnamen und Ortstypen.
  const factory MapboxReverseGeocodingResult({
    required String id,
    required List<String> placeType,
    String? placeNameDe,
  }) = _MapboxReverseGeocodingResult;

  /// Erzeugt eine Instanz aus einem JSON-Objekt.
  factory MapboxReverseGeocodingResult.fromJson(Map<String, dynamic> json) =>
      _$MapboxReverseGeocodingResultFromJson(json);
}

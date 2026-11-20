import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'models.freezed.dart';
part 'models.g.dart';

/// Repräsentiert eine Sammlung von Suchvorschlägen von Mapbox.
@freezed
abstract class MapboxSuggestions with _$MapboxSuggestions {
  const factory MapboxSuggestions({List<MapboxSuggestion>? suggestions}) =
      _MapboxSuggestions;

  /// Erzeugt eine Instanz aus einem JSON-Objekt.
  factory MapboxSuggestions.fromJson(Map<String, dynamic> json) =>
      _$MapboxSuggestionsFromJson(json);
}

/// Repräsentiert einen einzelnen Suchvorschlag von Mapbox.
@freezed
abstract class MapboxSuggestion with _$MapboxSuggestion {
  const factory MapboxSuggestion({
    required String name,
    required String mapboxId,
    String? fullAddress,
    String? placeFormatted,
  }) = _MapboxSuggestion;

  /// Erzeugt eine Instanz aus einem JSON-Objekt.
  factory MapboxSuggestion.fromJson(Map<String, dynamic> json) =>
      _$MapboxSuggestionFromJson(json);
}

/// Repräsentiert die Ergebnisse einer Detailabfrage von Mapbox.
@freezed
abstract class MapboxRetrievals with _$MapboxRetrievals {
  const factory MapboxRetrievals({
    required List<MapboxRetrievalFeature> features,
  }) = _MapboxRetrievals;

  /// Erzeugt eine Instanz aus einem JSON-Objekt.
  factory MapboxRetrievals.fromJson(Map<String, dynamic> json) =>
      _$MapboxRetrievalsFromJson(json);
}

/// Repräsentiert ein einzelnes Feature aus einer Detailabfrage.
@freezed
abstract class MapboxRetrievalFeature with _$MapboxRetrievalFeature {
  const factory MapboxRetrievalFeature({
    required MapboxRetrievalFeatureProperties properties,
  }) = _MapboxRetrievalFeature;

  /// Erzeugt eine Instanz aus einem JSON-Objekt.
  factory MapboxRetrievalFeature.fromJson(Map<String, dynamic> json) =>
      _$MapboxRetrievalFeatureFromJson(json);
}

/// Repräsentiert die Eigenschaften eines Mapbox-Features.
@freezed
abstract class MapboxRetrievalFeatureProperties
    with _$MapboxRetrievalFeatureProperties {
  const factory MapboxRetrievalFeatureProperties({
    required Coordinates coordinates,
  }) = _MapboxRetrievalFeatureProperties;

  /// Erzeugt eine Instanz aus einem JSON-Objekt.
  factory MapboxRetrievalFeatureProperties.fromJson(
    Map<String, dynamic> json,
  ) => _$MapboxRetrievalFeaturePropertiesFromJson(json);
}

/// Repräsentiert geografische Koordinaten mit Breiten- und Längengrad.
@freezed
abstract class Coordinates with _$Coordinates {
  const factory Coordinates({
    required double latitude,
    required double longitude,
  }) = _Coordinates;

  const Coordinates._();

  /// Erzeugt eine Instanz aus einem JSON-Objekt.
  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);

  /// Wandelt die Koordinaten in ein LatLng-Objekt um.
  LatLng toLatLng() => LatLng(latitude, longitude);
}

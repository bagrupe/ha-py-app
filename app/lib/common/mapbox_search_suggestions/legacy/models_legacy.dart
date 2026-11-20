import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'models_legacy.g.dart';

/// Repräsentiert eine Sammlung von Suchvorschlägen von Mapbox.
@JsonSerializable(fieldRename: FieldRename.snake)
class LegacyMapboxSuggestions {
  LegacyMapboxSuggestions(this.suggestions);

  /// Erzeugt eine Instanz aus einem JSON-Objekt.
  factory LegacyMapboxSuggestions.fromJson(Map<String, dynamic> json) =>
      _$LegacyMapboxSuggestionsFromJson(json);

  /// Liste der einzelnen Suchvorschläge.
  final List<LegacyMapboxSuggestion>? suggestions;

  /// Wandelt die Instanz in ein JSON-Objekt um.
  Map<String, dynamic> toJson() => _$LegacyMapboxSuggestionsToJson(this);
}

/// Repräsentiert einen einzelnen Suchvorschlag von Mapbox.
@JsonSerializable(fieldRename: FieldRename.snake)
class LegacyMapboxSuggestion {
  LegacyMapboxSuggestion(
    this.name,
    this.mapboxId,
    this.fullAddress,
    this.placeFormatted,
  );

  /// Erzeugt eine Instanz aus einem JSON-Objekt.
  factory LegacyMapboxSuggestion.fromJson(Map<String, dynamic> json) =>
      _$LegacyMapboxSuggestionFromJson(json);

  /// Name des Vorschlags.
  final String name;

  /// Eindeutige Mapbox-ID des Vorschlags.
  final String mapboxId;

  /// Vollständige Adresse, falls vorhanden.
  final String? fullAddress;

  /// Formatierte Ortsbeschreibung, falls vorhanden.
  final String? placeFormatted;

  /// Wandelt die Instanz in ein JSON-Objekt um.
  Map<String, dynamic> toJson() => _$LegacyMapboxSuggestionToJson(this);
}

/// Repräsentiert die Ergebnisse einer Detailabfrage von Mapbox.
@JsonSerializable(fieldRename: FieldRename.snake)
class LegacyMapboxRetrievals {
  LegacyMapboxRetrievals(this.features);

  /// Erzeugt eine Instanz aus einem JSON-Objekt.
  factory LegacyMapboxRetrievals.fromJson(Map<String, dynamic> json) =>
      _$LegacyMapboxRetrievalsFromJson(json);

  /// Liste der abgerufenen Features.
  final List<LegacyMapboxRetrievalFeature> features;

  /// Wandelt die Instanz in ein JSON-Objekt um.
  Map<String, dynamic> toJson() => _$LegacyMapboxRetrievalsToJson(this);
}

/// Repräsentiert ein einzelnes Feature aus einer Detailabfrage.
@JsonSerializable(fieldRename: FieldRename.snake)
class LegacyMapboxRetrievalFeature {
  LegacyMapboxRetrievalFeature(this.properties);

  /// Erzeugt eine Instanz aus einem JSON-Objekt.
  factory LegacyMapboxRetrievalFeature.fromJson(Map<String, dynamic> json) =>
      _$LegacyMapboxRetrievalFeatureFromJson(json);

  /// Eigenschaften des Features.
  final LegacyMapboxRetrievalFeatureProperties properties;

  /// Wandelt die Instanz in ein JSON-Objekt um.
  Map<String, dynamic> toJson() => _$LegacyMapboxRetrievalFeatureToJson(this);
}

/// Repräsentiert die Eigenschaften eines Mapbox-Features.
@JsonSerializable(fieldRename: FieldRename.snake)
class LegacyMapboxRetrievalFeatureProperties {
  LegacyMapboxRetrievalFeatureProperties(this.coordinates);

  /// Erzeugt eine Instanz aus einem JSON-Objekt.
  factory LegacyMapboxRetrievalFeatureProperties.fromJson(
    Map<String, dynamic> json,
  ) => _$LegacyMapboxRetrievalFeaturePropertiesFromJson(json);

  /// Koordinaten des Features.
  final LegacyCoordinates coordinates;

  /// Wandelt die Instanz in ein JSON-Objekt um.
  Map<String, dynamic> toJson() =>
      _$LegacyMapboxRetrievalFeaturePropertiesToJson(this);
}

/// Repräsentiert geografische Koordinaten mit Breiten- und Längengrad.
@JsonSerializable(fieldRename: FieldRename.snake)
class LegacyCoordinates {
  LegacyCoordinates(this.latitude, this.longitude);

  /// Erzeugt eine Instanz aus einem JSON-Objekt.
  factory LegacyCoordinates.fromJson(Map<String, dynamic> json) =>
      _$LegacyCoordinatesFromJson(json);

  /// Breitengrad.
  final double latitude;

  /// Längengrad.
  final double longitude;

  /// Wandelt die Instanz in ein JSON-Objekt um.
  Map<String, dynamic> toJson() => _$LegacyCoordinatesToJson(this);

  /// Wandelt die Koordinaten in ein LatLng-Objekt um.
  LatLng toLatLng() => LatLng(latitude, longitude);
}

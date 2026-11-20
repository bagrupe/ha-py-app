// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MapboxSuggestions _$MapboxSuggestionsFromJson(Map json) => _MapboxSuggestions(
  suggestions: (json['suggestions'] as List<dynamic>?)
      ?.map(
        (e) => MapboxSuggestion.fromJson(Map<String, dynamic>.from(e as Map)),
      )
      .toList(),
);

Map<String, dynamic> _$MapboxSuggestionsToJson(_MapboxSuggestions instance) =>
    <String, dynamic>{
      'suggestions': instance.suggestions?.map((e) => e.toJson()).toList(),
    };

_MapboxSuggestion _$MapboxSuggestionFromJson(Map json) => _MapboxSuggestion(
  name: json['name'] as String,
  mapboxId: json['mapbox_id'] as String,
  fullAddress: json['full_address'] as String?,
  placeFormatted: json['place_formatted'] as String?,
);

Map<String, dynamic> _$MapboxSuggestionToJson(_MapboxSuggestion instance) =>
    <String, dynamic>{
      'name': instance.name,
      'mapbox_id': instance.mapboxId,
      'full_address': instance.fullAddress,
      'place_formatted': instance.placeFormatted,
    };

_MapboxRetrievals _$MapboxRetrievalsFromJson(Map json) => _MapboxRetrievals(
  features: (json['features'] as List<dynamic>)
      .map(
        (e) => MapboxRetrievalFeature.fromJson(
          Map<String, dynamic>.from(e as Map),
        ),
      )
      .toList(),
);

Map<String, dynamic> _$MapboxRetrievalsToJson(_MapboxRetrievals instance) =>
    <String, dynamic>{
      'features': instance.features.map((e) => e.toJson()).toList(),
    };

_MapboxRetrievalFeature _$MapboxRetrievalFeatureFromJson(Map json) =>
    _MapboxRetrievalFeature(
      properties: MapboxRetrievalFeatureProperties.fromJson(
        Map<String, dynamic>.from(json['properties'] as Map),
      ),
    );

Map<String, dynamic> _$MapboxRetrievalFeatureToJson(
  _MapboxRetrievalFeature instance,
) => <String, dynamic>{'properties': instance.properties.toJson()};

_MapboxRetrievalFeatureProperties _$MapboxRetrievalFeaturePropertiesFromJson(
  Map json,
) => _MapboxRetrievalFeatureProperties(
  coordinates: Coordinates.fromJson(
    Map<String, dynamic>.from(json['coordinates'] as Map),
  ),
);

Map<String, dynamic> _$MapboxRetrievalFeaturePropertiesToJson(
  _MapboxRetrievalFeatureProperties instance,
) => <String, dynamic>{'coordinates': instance.coordinates.toJson()};

_Coordinates _$CoordinatesFromJson(Map json) => _Coordinates(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
);

Map<String, dynamic> _$CoordinatesToJson(_Coordinates instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

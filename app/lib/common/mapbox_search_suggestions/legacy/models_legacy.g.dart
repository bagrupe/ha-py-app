// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models_legacy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LegacyMapboxSuggestions _$LegacyMapboxSuggestionsFromJson(Map json) =>
    LegacyMapboxSuggestions(
      (json['suggestions'] as List<dynamic>?)
          ?.map(
            (e) => LegacyMapboxSuggestion.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
    );

Map<String, dynamic> _$LegacyMapboxSuggestionsToJson(
  LegacyMapboxSuggestions instance,
) => <String, dynamic>{
  'suggestions': instance.suggestions?.map((e) => e.toJson()).toList(),
};

LegacyMapboxSuggestion _$LegacyMapboxSuggestionFromJson(Map json) =>
    LegacyMapboxSuggestion(
      json['name'] as String,
      json['mapbox_id'] as String,
      json['full_address'] as String?,
      json['place_formatted'] as String?,
    );

Map<String, dynamic> _$LegacyMapboxSuggestionToJson(
  LegacyMapboxSuggestion instance,
) => <String, dynamic>{
  'name': instance.name,
  'mapbox_id': instance.mapboxId,
  'full_address': instance.fullAddress,
  'place_formatted': instance.placeFormatted,
};

LegacyMapboxRetrievals _$LegacyMapboxRetrievalsFromJson(Map json) =>
    LegacyMapboxRetrievals(
      (json['features'] as List<dynamic>)
          .map(
            (e) => LegacyMapboxRetrievalFeature.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
    );

Map<String, dynamic> _$LegacyMapboxRetrievalsToJson(
  LegacyMapboxRetrievals instance,
) => <String, dynamic>{
  'features': instance.features.map((e) => e.toJson()).toList(),
};

LegacyMapboxRetrievalFeature _$LegacyMapboxRetrievalFeatureFromJson(Map json) =>
    LegacyMapboxRetrievalFeature(
      LegacyMapboxRetrievalFeatureProperties.fromJson(
        Map<String, dynamic>.from(json['properties'] as Map),
      ),
    );

Map<String, dynamic> _$LegacyMapboxRetrievalFeatureToJson(
  LegacyMapboxRetrievalFeature instance,
) => <String, dynamic>{'properties': instance.properties.toJson()};

LegacyMapboxRetrievalFeatureProperties
_$LegacyMapboxRetrievalFeaturePropertiesFromJson(Map json) =>
    LegacyMapboxRetrievalFeatureProperties(
      LegacyCoordinates.fromJson(
        Map<String, dynamic>.from(json['coordinates'] as Map),
      ),
    );

Map<String, dynamic> _$LegacyMapboxRetrievalFeaturePropertiesToJson(
  LegacyMapboxRetrievalFeatureProperties instance,
) => <String, dynamic>{'coordinates': instance.coordinates.toJson()};

LegacyCoordinates _$LegacyCoordinatesFromJson(Map json) => LegacyCoordinates(
  (json['latitude'] as num).toDouble(),
  (json['longitude'] as num).toDouble(),
);

Map<String, dynamic> _$LegacyCoordinatesToJson(LegacyCoordinates instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

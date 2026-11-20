// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MapboxReverseGeocodingResults _$MapboxReverseGeocodingResultsFromJson(
  Map json,
) => _MapboxReverseGeocodingResults(
  features: (json['features'] as List<dynamic>)
      .map(
        (e) => MapboxReverseGeocodingResult.fromJson(
          Map<String, dynamic>.from(e as Map),
        ),
      )
      .toList(),
);

Map<String, dynamic> _$MapboxReverseGeocodingResultsToJson(
  _MapboxReverseGeocodingResults instance,
) => <String, dynamic>{
  'features': instance.features.map((e) => e.toJson()).toList(),
};

_MapboxReverseGeocodingResult _$MapboxReverseGeocodingResultFromJson(
  Map json,
) => _MapboxReverseGeocodingResult(
  id: json['id'] as String,
  placeType: (json['place_type'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  placeNameDe: json['place_name_de'] as String?,
);

Map<String, dynamic> _$MapboxReverseGeocodingResultToJson(
  _MapboxReverseGeocodingResult instance,
) => <String, dynamic>{
  'id': instance.id,
  'place_type': instance.placeType,
  'place_name_de': instance.placeNameDe,
};

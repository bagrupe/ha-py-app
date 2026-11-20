// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models_legacy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LegacyMapboxReverseGeocodingResults
_$LegacyMapboxReverseGeocodingResultsFromJson(Map json) =>
    LegacyMapboxReverseGeocodingResults(
      (json['features'] as List<dynamic>)
          .map(
            (e) => LegacyMapboxReverseGeocodingResult.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
    );

Map<String, dynamic> _$LegacyMapboxReverseGeocodingResultsToJson(
  LegacyMapboxReverseGeocodingResults instance,
) => <String, dynamic>{
  'features': instance.features.map((e) => e.toJson()).toList(),
};

LegacyMapboxReverseGeocodingResult _$LegacyMapboxReverseGeocodingResultFromJson(
  Map json,
) => LegacyMapboxReverseGeocodingResult(
  json['id'] as String,
  json['place_name_de'] as String?,
  (json['place_type'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$LegacyMapboxReverseGeocodingResultToJson(
  LegacyMapboxReverseGeocodingResult instance,
) => <String, dynamic>{
  'id': instance.id,
  'place_name_de': instance.placeNameDe,
  'place_type': instance.placeType,
};

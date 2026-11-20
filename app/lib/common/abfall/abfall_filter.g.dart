// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abfall_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AbfallFilter _$AbfallFilterFromJson(Map json) => _AbfallFilter(
  ort: json['ort'] as String?,
  strasse: json['strasse'] as String?,
  anfangsbuchstabe: json['anfangsbuchstabe'] as String?,
  standort: json['standort'] as String?,
  fraktionen: json['fraktionen'] as String?,
);

Map<String, dynamic> _$AbfallFilterToJson(_AbfallFilter instance) =>
    <String, dynamic>{
      'ort': instance.ort,
      'strasse': instance.strasse,
      'anfangsbuchstabe': instance.anfangsbuchstabe,
      'standort': instance.standort,
      'fraktionen': instance.fraktionen,
    };

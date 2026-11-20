// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abfall_benachrichtigungen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AbfallBenachrichtigungen _$AbfallBenachrichtigungenFromJson(Map json) =>
    _AbfallBenachrichtigungen(
      preset: $enumDecode(
        _$AbfallBenachrichtigungenPresetsEnumMap,
        json['preset'],
      ),
      enabled: json['enabled'] as bool,
      zeitpunkt: _timeFromJson(json['zeitpunkt'] as String),
    );

Map<String, dynamic> _$AbfallBenachrichtigungenToJson(
  _AbfallBenachrichtigungen instance,
) => <String, dynamic>{
  'preset': _$AbfallBenachrichtigungenPresetsEnumMap[instance.preset]!,
  'enabled': instance.enabled,
  'zeitpunkt': _timeToJson(instance.zeitpunkt),
};

const _$AbfallBenachrichtigungenPresetsEnumMap = {
  AbfallBenachrichtigungenPresets.previousDay: 'previousDay',
};

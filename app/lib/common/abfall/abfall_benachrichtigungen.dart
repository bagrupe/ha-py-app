import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'abfall_benachrichtigungen.freezed.dart';
part 'abfall_benachrichtigungen.g.dart';

/// Enthält Schlüssel für die Speicherung der Abfallbenachrichtigungs-Konfiguration.
class AbfallBenachrichtigungenKeys {
  static const storageKey = 'abfall_benachrichtigungen_config';
}

/// Vordefinierte Zeitpunkte für Abfallbenachrichtigungen.
enum AbfallBenachrichtigungenPresets { previousDay }

/// Modell für die Konfiguration einer Abfallbenachrichtigung.
@freezed
abstract class AbfallBenachrichtigungen with _$AbfallBenachrichtigungen {
  /// Erzeugt eine neue Instanz mit den angegebenen Einstellungen.
  factory AbfallBenachrichtigungen({
    required AbfallBenachrichtigungenPresets preset,
    required bool enabled,
    @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)
    required TimeOfDay zeitpunkt,
  }) = _AbfallBenachrichtigungen;

  /// Erzeugt eine Instanz aus einer JSON-Darstellung.
  factory AbfallBenachrichtigungen.fromJson(Map<String, dynamic> json) =>
      _$AbfallBenachrichtigungenFromJson(json);
}

TimeOfDay _timeFromJson(String json) =>
    TimeOfDay.fromDateTime(DateTime.parse(json));

String _timeToJson(TimeOfDay time) {
  final now = DateTime.now();
  return DateTime(
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  ).toIso8601String();
}

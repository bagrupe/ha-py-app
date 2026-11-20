import 'dart:convert';

import 'package:app/common/abfall/abfall_benachrichtigungen.dart';
import 'package:app/common/abfall/abfall_filter.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'abfall_config.freezed.dart';

/// Modell für die Abfallkonfiguration mit Filter und Benachrichtigungen.
@freezed
abstract class AbfallConfig with _$AbfallConfig {
  /// Erzeugt eine neue Abfallkonfiguration mit angegebenem Filter und Benachrichtigungen.
  const factory AbfallConfig({
    required AbfallFilter filter,
    required AbfallBenachrichtigungen benachrichtigungen,
  }) = _AbfallConfig;
}

/// Repository zur Speicherung und Wiederherstellung der Abfallkonfiguration.
class AbfallConfigRepository {
  AbfallConfigRepository(SharedPreferences prefs) : _sharedPreferences = prefs;

  final SharedPreferences _sharedPreferences;

  /// Liest die gespeicherte Abfallkonfiguration aus den SharedPreferences aus.
  AbfallConfig read() {
    final prefs = _sharedPreferences;

    final abfallFilterString = prefs.getString(AbfallFilterKeys.abfallFilter);
    final abfallFilter = abfallFilterString != null
        ? AbfallFilter.fromJson(
            jsonDecode(abfallFilterString) as Map<String, dynamic>,
          )
        : AbfallFilter();

    final abfallBenachrichtigungenString = prefs.getString(
      AbfallBenachrichtigungenKeys.storageKey,
    );
    final abfallBenachrichtigungen = abfallBenachrichtigungenString != null
        ? AbfallBenachrichtigungen.fromJson(
            jsonDecode(abfallBenachrichtigungenString) as Map<String, dynamic>,
          )
        : AbfallBenachrichtigungen(
            preset: AbfallBenachrichtigungenPresets.previousDay,
            enabled: false,
            zeitpunkt: const TimeOfDay(hour: 18, minute: 0),
          );

    return AbfallConfig(
      filter: abfallFilter,
      benachrichtigungen: abfallBenachrichtigungen,
    );
  }

  /// Speichert die gegebene Abfallkonfiguration in den SharedPreferences.
  void write(AbfallConfig config) {
    _sharedPreferences
      ..setString(
        AbfallFilterKeys.abfallFilter,
        jsonEncode(config.filter.toJson()),
      )
      ..setString(
        AbfallBenachrichtigungenKeys.storageKey,
        jsonEncode(config.benachrichtigungen.toJson()),
      );
  }
}

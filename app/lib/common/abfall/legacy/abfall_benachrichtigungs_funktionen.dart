import 'package:app/common/abfall/abfall_benachrichtigungen.dart';
import 'package:flutter/material.dart';

/// Legacy manual functions kept temporarily for testing purposes.
/// These should be removed at a later point when migration is fully complete.
extension LegacyAbfallBenachrichtigungen on AbfallBenachrichtigungen {
  /// Erzeugt eine Instanz aus einer JSON-Darstellung.
  static AbfallBenachrichtigungen legacyFromJson(
    Map<String, dynamic> parsedJson,
  ) {
    return AbfallBenachrichtigungen(
      enabled: parsedJson['enabled'] as bool,
      preset: AbfallBenachrichtigungenPresets.values.byName(
        parsedJson['preset'] as String,
      ),
      zeitpunkt: TimeOfDay.fromDateTime(
        DateTime.parse(parsedJson['zeitpunkt'] as String),
      ),
    );
  }

  /// Gibt eine Kopie mit optional geänderten Werten zurück.
  AbfallBenachrichtigungen legacyCopyWith({
    AbfallBenachrichtigungenPresets? preset,
    TimeOfDay? zeitpunkt,
    bool? enabled,
  }) {
    return AbfallBenachrichtigungen(
      zeitpunkt: zeitpunkt ?? this.zeitpunkt,
      preset: preset ?? this.preset,
      enabled: enabled ?? this.enabled,
    );
  }

  /// Wandelt die Instanz in eine JSON-Darstellung um.
  Map<String, dynamic> legacyToJson() {
    return {
      'enabled': enabled,
      'preset': preset.name,
      'zeitpunkt': DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        zeitpunkt.hour,
        zeitpunkt.minute,
      ).toIso8601String(),
    };
  }
}

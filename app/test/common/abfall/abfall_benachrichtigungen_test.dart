import 'package:app/common/abfall/abfall_benachrichtigungen.dart';
import 'package:app/common/abfall/legacy/abfall_benachrichtigungs_funktionen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AbfallBenachrichtigungen Migration tests', () {
    test('Test old  AbfallBenachrichtigungen', () {
      final config = AbfallBenachrichtigungen(
        preset: AbfallBenachrichtigungenPresets.previousDay,
        enabled: true,
        zeitpunkt: const TimeOfDay(hour: 18, minute: 30),
      );

      // Verify fields
      expect(config.preset, AbfallBenachrichtigungenPresets.previousDay);
      expect(config.enabled, true);
      expect(config.zeitpunkt.hour, 18);
      expect(config.zeitpunkt.minute, 30);

      // Test toJson
      final json = config.legacyToJson();
      expect(json['enabled'], true);
      expect(json['preset'], 'previousDay');
      // zeitpunkt is ISO string with current date but correct time
      final parsedTime = DateTime.parse(json['zeitpunkt'] as String);
      expect(parsedTime.hour, 18);
      expect(parsedTime.minute, 30);

      // Test fromJson
      final fromJson = LegacyAbfallBenachrichtigungen.legacyFromJson(json);
      expect(fromJson.preset, AbfallBenachrichtigungenPresets.previousDay);
      expect(fromJson.enabled, true);
      expect(fromJson.zeitpunkt.hour, 18);
      expect(fromJson.zeitpunkt.minute, 30);

      // Test copyWith
      final updated = config.legacyCopyWith(
        enabled: false,
        zeitpunkt: const TimeOfDay(hour: 20, minute: 40),
      );
      expect(updated.enabled, false);
      expect(updated.zeitpunkt.hour, 20);
      expect(updated.zeitpunkt.minute, 40);
      expect(updated.preset, AbfallBenachrichtigungenPresets.previousDay);
    });
    test('Test new  AbfallBenachrichtigungen', () {
      final config = AbfallBenachrichtigungen(
        preset: AbfallBenachrichtigungenPresets.previousDay,
        enabled: true,
        zeitpunkt: const TimeOfDay(hour: 18, minute: 30),
      );

      // Verify fields
      expect(config.preset, AbfallBenachrichtigungenPresets.previousDay);
      expect(config.enabled, true);
      expect(config.zeitpunkt.hour, 18);
      expect(config.zeitpunkt.minute, 30);

      // Test toJson
      final json = config.toJson();
      expect(json['enabled'], true);
      expect(json['preset'], 'previousDay');
      // zeitpunkt is ISO string with current date but correct time
      final parsedTime = DateTime.parse(json['zeitpunkt'] as String);
      expect(parsedTime.hour, 18);
      expect(parsedTime.minute, 30);

      // Test fromJson
      final fromJson = AbfallBenachrichtigungen.fromJson(json);
      expect(fromJson.preset, AbfallBenachrichtigungenPresets.previousDay);
      expect(fromJson.enabled, true);
      expect(fromJson.zeitpunkt.hour, 18);
      expect(fromJson.zeitpunkt.minute, 30);

      // Test copyWith
      final updated = config.copyWith(
        enabled: false,
        zeitpunkt: const TimeOfDay(hour: 20, minute: 40),
      );
      expect(updated.enabled, false);
      expect(updated.zeitpunkt.hour, 20);
      expect(updated.zeitpunkt.minute, 40);
      expect(updated.preset, AbfallBenachrichtigungenPresets.previousDay);
    });
    test('legacy vs new should match', () {
      final config = AbfallBenachrichtigungen(
        preset: AbfallBenachrichtigungenPresets.previousDay,
        enabled: true,
        zeitpunkt: const TimeOfDay(hour: 18, minute: 30),
      );

      final legacyAB = LegacyAbfallBenachrichtigungen.legacyFromJson(
        config.legacyToJson(),
      );

      final newAB = AbfallBenachrichtigungen.fromJson(config.toJson());

      expect(newAB.preset, legacyAB.preset);
      expect(newAB.enabled, legacyAB.enabled);
      expect(newAB.zeitpunkt.hour, legacyAB.zeitpunkt.hour);
      expect(newAB.zeitpunkt.minute, legacyAB.zeitpunkt.minute);
    });
  });
}

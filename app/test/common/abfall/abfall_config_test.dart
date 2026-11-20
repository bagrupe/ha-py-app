import 'package:app/common/abfall/abfall_benachrichtigungen.dart';
import 'package:app/common/abfall/abfall_config.dart';
import 'package:app/common/abfall/abfall_filter.dart';
import 'package:app/common/abfall/legacy/abfall_config_funktionen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AbfallConfig Migration tests', () {
    test('Test old AbfallConfig', () {
      final filter = AbfallFilter(ort: 'Hameln');
      final notifications = AbfallBenachrichtigungen(
        preset: AbfallBenachrichtigungenPresets.previousDay,
        enabled: true,
        zeitpunkt: const TimeOfDay(hour: 18, minute: 0),
      );
      final config = AbfallConfig(
        filter: filter,
        benachrichtigungen: notifications,
      );

      // Verify fields
      expect(config.filter.ort, 'Hameln');
      expect(config.benachrichtigungen.enabled, true);

      // Test copyWith
      final updated = config.legacyCopyWith(
        filter: filter.copyWith(ort: 'Pyrmont'),
      );
      expect(updated.filter.ort, 'Pyrmont');
      expect(updated.benachrichtigungen.enabled, true);
    });
    test('Test new AbfallConfig', () {
      final filter = AbfallFilter(ort: 'Hameln');
      final notifications = AbfallBenachrichtigungen(
        preset: AbfallBenachrichtigungenPresets.previousDay,
        enabled: true,
        zeitpunkt: const TimeOfDay(hour: 18, minute: 0),
      );
      final config = AbfallConfig(
        filter: filter,
        benachrichtigungen: notifications,
      );

      // Verify fields
      expect(config.filter.ort, 'Hameln');
      expect(config.benachrichtigungen.enabled, true);

      // Test copyWith
      final updated = config.copyWith(filter: filter.copyWith(ort: 'Pyrmont'));
      expect(updated.filter.ort, 'Pyrmont');
      expect(updated.benachrichtigungen.enabled, true);
    });
    test('Legacy and new copyWith should behave identically', () {
      final filter = AbfallFilter(ort: 'Hameln');
      final notifications = AbfallBenachrichtigungen(
        preset: AbfallBenachrichtigungenPresets.previousDay,
        enabled: true,
        zeitpunkt: const TimeOfDay(hour: 18, minute: 0),
      );

      final config = AbfallConfig(
        filter: filter,
        benachrichtigungen: notifications,
      );

      final updatedLegacy = config.legacyCopyWith(
        filter: filter.copyWith(ort: 'Pyrmont'),
      );

      final updatedNew = config.copyWith(
        filter: filter.copyWith(ort: 'Pyrmont'),
      );

      _expectConfigsEqual(updatedNew, updatedLegacy);
    });
  });
}

void _expectConfigsEqual(AbfallConfig a, AbfallConfig b) {
  expect(a.filter.ort, b.filter.ort);

  expect(a.benachrichtigungen.enabled, b.benachrichtigungen.enabled);

  expect(a.benachrichtigungen.preset, b.benachrichtigungen.preset);

  expect(
    a.benachrichtigungen.zeitpunkt.hour,
    b.benachrichtigungen.zeitpunkt.hour,
  );

  expect(
    a.benachrichtigungen.zeitpunkt.minute,
    b.benachrichtigungen.zeitpunkt.minute,
  );
}

import 'package:app/common/abfall/abfall_filter.dart';
import 'package:app/common/abfall/legacy/abfall_filter_funktionen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AbfallFilter Migration tests', () {
    test('Test old AbfallFilter', () {
      final filter = AbfallFilter(
        ort: 'Hameln',
        anfangsbuchstabe: 'H',
        strasse: 'Musterstraße',
        standort: 'Musterstandort',
        fraktionen: 'Restmüll',
      );

      // Verify fields
      expect(filter.ort, 'Hameln');
      expect(filter.anfangsbuchstabe, 'H');
      expect(filter.strasse, 'Musterstraße');
      expect(filter.standort, 'Musterstandort');
      expect(filter.fraktionen, 'Restmüll');

      // Test toJson
      final json = filter.legacyToJson();
      expect(json['ort'], 'Hameln');
      expect(json['anfangsbuchstabe'], 'H');
      expect(json['strasse'], 'Musterstraße');
      expect(json['standort'], 'Musterstandort');
      expect(json['fraktionen'], 'Restmüll');

      // Test fromJson
      final fromJson = LegacyAbfallFilter.legacyFromJson(json);
      expect(fromJson.ort, 'Hameln');
      expect(fromJson.anfangsbuchstabe, 'H');
      expect(fromJson.strasse, 'Musterstraße');
      expect(fromJson.standort, 'Musterstandort');
      expect(fromJson.fraktionen, 'Restmüll');

      // Test copyWith
      final updated = filter.legacyCopyWith(ort: 'Pyrmont');
      expect(updated.ort, 'Pyrmont');
      expect(updated.anfangsbuchstabe, 'H');
    });
    test('Test new AbfallFilter', () {
      final filter = AbfallFilter(
        ort: 'Hameln',
        anfangsbuchstabe: 'H',
        strasse: 'Musterstraße',
        standort: 'Musterstandort',
        fraktionen: 'Restmüll',
      );

      // Verify fields
      expect(filter.ort, 'Hameln');
      expect(filter.anfangsbuchstabe, 'H');
      expect(filter.strasse, 'Musterstraße');
      expect(filter.standort, 'Musterstandort');
      expect(filter.fraktionen, 'Restmüll');

      // Test toJson
      final json = filter.toJson();
      expect(json['ort'], 'Hameln');
      expect(json['anfangsbuchstabe'], 'H');
      expect(json['strasse'], 'Musterstraße');
      expect(json['standort'], 'Musterstandort');
      expect(json['fraktionen'], 'Restmüll');

      // Test fromJson
      final fromJson = AbfallFilter.fromJson(json);
      expect(fromJson.ort, 'Hameln');
      expect(fromJson.anfangsbuchstabe, 'H');
      expect(fromJson.strasse, 'Musterstraße');
      expect(fromJson.standort, 'Musterstandort');
      expect(fromJson.fraktionen, 'Restmüll');

      // Test copyWith
      final updated = filter.copyWith(ort: 'Pyrmont');
      expect(updated.ort, 'Pyrmont');
      expect(updated.anfangsbuchstabe, 'H');
    });
    test('legacy vs new should match', () {
      final filter = AbfallFilter(
        ort: 'Hameln',
        anfangsbuchstabe: 'H',
        strasse: 'Musterstraße',
        standort: 'Musterstandort',
        fraktionen: 'Restmüll',
      );

      final legacy = LegacyAbfallFilter.legacyFromJson(filter.legacyToJson());

      final generated = AbfallFilter.fromJson(filter.toJson());

      _expectFiltersEqual(generated, legacy);
    });
  });
}

void _expectFiltersEqual(AbfallFilter a, AbfallFilter b) {
  expect(a.ort, b.ort);
  expect(a.anfangsbuchstabe, b.anfangsbuchstabe);
  expect(a.strasse, b.strasse);
  expect(a.standort, b.standort);
  expect(a.fraktionen, b.fraktionen);
}

import 'package:app/common/mapbox_reverse_geocoding/legacy/models_legacy.dart';
import 'package:app/common/mapbox_reverse_geocoding/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MapboxReverseGeocoding Migration tests', () {
    test('Test old MapboxReverseGeocodingResult', () {
      final json = {
        'id': 'place.123',
        'place_name_de': 'Hameln',
        'place_type': ['place'],
      };

      final legacy = LegacyMapboxReverseGeocodingResult.fromJson(json);

      expect(legacy.id, 'place.123');
      expect(legacy.placeNameDe, 'Hameln');
      expect(legacy.placeType, ['place']);

      final toJson = legacy.toJson();
      expect(toJson['id'], 'place.123');
      expect(toJson['place_name_de'], 'Hameln');
    });

    test('Test new MapboxReverseGeocodingResult', () {
      final json = {
        'id': 'place.123',
        'place_name_de': 'Hameln',
        'place_type': ['place'],
      };

      final result = MapboxReverseGeocodingResult.fromJson(json);

      expect(result.id, 'place.123');
      expect(result.placeNameDe, 'Hameln');
      expect(result.placeType, ['place']);

      final toJson = result.toJson();
      expect(toJson['id'], 'place.123');
      expect(toJson['place_name_de'], 'Hameln');
    });

    test('MapboxReverseGeocodingResults legacy vs new should match', () {
      final json = {
        'features': [
          {
            'id': 'place.1',
            'place_name_de': 'Hameln',
            'place_type': ['place'],
          },
        ],
      };

      final legacy = LegacyMapboxReverseGeocodingResults.fromJson(json);
      final generated = MapboxReverseGeocodingResults.fromJson(json);
      expect(generated.features.length, legacy.features.length);
      expect(generated.features.first.id, legacy.features.first.id);
    });

    test('Test new MapboxReverseGeocodingResults', () {
      final json = {
        'features': [
          {
            'id': 'place.1',
            'place_name_de': 'Hameln',
            'place_type': ['place'],
          },
        ],
      };

      final result = MapboxReverseGeocodingResults.fromJson(json);
      expect(result.features.length, 1);
    });

    test('MapboxReverseGeocodingResult legacy vs new should match', () {
      final json = {
        'id': 'place.123',
        'place_name_de': 'Hameln',
        'place_type': ['place'],
      };

      final legacy = LegacyMapboxReverseGeocodingResult.fromJson(json);
      final generated = MapboxReverseGeocodingResult.fromJson(json);

      expect(generated.id, legacy.id);
      expect(generated.placeNameDe, legacy.placeNameDe);
      expect(generated.placeType, legacy.placeType);
    });
  });
}

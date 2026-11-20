import 'package:app/common/mapbox_search_suggestions/legacy/models_legacy.dart';
import 'package:app/common/mapbox_search_suggestions/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MapboxSearchSuggestions Migration tests', () {
    test('Test old MapboxSuggestion', () {
      final json = {
        'name': 'Hameln Bahnhof',
        'mapbox_id': 'poi.123',
        'full_address': 'Bahnhofstraße 1, Hameln',
        'place_formatted': 'Hameln',
      };

      final legacy = LegacyMapboxSuggestion.fromJson(json);

      expect(legacy.name, 'Hameln Bahnhof');
      expect(legacy.mapboxId, 'poi.123');
      expect(legacy.fullAddress, 'Bahnhofstraße 1, Hameln');
      expect(legacy.placeFormatted, 'Hameln');

      final toJson = legacy.toJson();
      expect(toJson['name'], 'Hameln Bahnhof');
      expect(toJson['mapbox_id'], 'poi.123');
    });

    test('Test new MapboxSuggestion', () {
      final json = {
        'name': 'Hameln Bahnhof',
        'mapbox_id': 'poi.123',
        'full_address': 'Bahnhofstraße 1, Hameln',
        'place_formatted': 'Hameln',
      };

      final result = MapboxSuggestion.fromJson(json);

      expect(result.name, 'Hameln Bahnhof');
      expect(result.mapboxId, 'poi.123');
      expect(result.fullAddress, 'Bahnhofstraße 1, Hameln');
      expect(result.placeFormatted, 'Hameln');

      final toJson = result.toJson();
      expect(toJson['name'], 'Hameln Bahnhof');
      expect(toJson['mapbox_id'], 'poi.123');
    });

    test('Test old MapboxSuggestions list', () {
      final json = {
        'suggestions': [
          {
            'name': 'Bahnhof Hameln',
            'mapbox_id': 'poi.1',
            'full_address': null,
            'place_formatted': null,
          },
        ],
      };

      final legacy = LegacyMapboxSuggestions.fromJson(json);
      expect(legacy.suggestions?.length, 1);
      expect(legacy.suggestions?.first.name, 'Bahnhof Hameln');
    });

    test('Test new MapboxSuggestions list', () {
      final json = {
        'suggestions': [
          {'name': 'Bahnhof Hameln', 'mapbox_id': 'poi.1'},
        ],
      };

      final result = MapboxSuggestions.fromJson(json);
      expect(result.suggestions?.length, 1);
      expect(result.suggestions?.first.name, 'Bahnhof Hameln');
    });

    test('legacy vs new should match', () {
      final json = {
        'name': 'Hameln Bahnhof',
        'mapbox_id': 'poi.123',
        'full_address': 'Bahnhofstraße 1, Hameln',
        'place_formatted': 'Hameln',
      };

      final legacy = LegacyMapboxSuggestion.fromJson(json);
      final generated = MapboxSuggestion.fromJson(json);

      expect(generated.name, legacy.name);
      expect(generated.mapboxId, legacy.mapboxId);
      expect(generated.fullAddress, legacy.fullAddress);
      expect(generated.placeFormatted, legacy.placeFormatted);
    });

    test('Coordinates toLatLng conversion', () {
      final json = {'latitude': 52.1, 'longitude': 9.36};

      final coords = Coordinates.fromJson(json);
      final latLng = coords.toLatLng();

      expect(latLng.latitude, 52.1);
      expect(latLng.longitude, 9.36);
    });
  });
}

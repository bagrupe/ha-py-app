import 'package:app/common/mapbox_reverse_geocoding/models.dart';
import 'package:app/common/mapbox_search_suggestions/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Mapbox Models Migration tests', () {
    test('MapboxSuggestions behavior', () {
      final json = {
        'suggestions': [
          {
            'name': 'Hameln',
            'mapbox_id': '123',
            'full_address': 'Hameln, Germany',
            'place_formatted': 'Hameln, NI',
          },
        ],
      };
      final suggestions = MapboxSuggestions.fromJson(json);
      expect(suggestions.suggestions?.first.name, 'Hameln');
      expect(
        (suggestions.toJson()['suggestions']
            as List<Map<String, dynamic>>)[0]['name'],
        'Hameln',
      );
    });

    test('MapboxRetrievals behavior', () {
      final json = {
        'features': [
          {
            'properties': {
              'coordinates': {'latitude': 52.1, 'longitude': 9.3},
            },
          },
        ],
      };
      final retrievals = MapboxRetrievals.fromJson(json);
      expect(retrievals.features.first.properties.coordinates.latitude, 52.1);
      expect(
        retrievals.features.first.properties.coordinates.toLatLng().latitude,
        52.1,
      );
    });

    test('MapboxReverseGeocodingResults behavior', () {
      final json = {
        'features': [
          {
            'id': '456',
            'place_name_de': 'Hameln',
            'place_type': ['address'],
          },
        ],
      };
      final results = MapboxReverseGeocodingResults.fromJson(json);
      expect(results.features.first.placeNameDe, 'Hameln');
      expect(
        (results.toJson()['features']
            as List<Map<String, dynamic>>)[0]['place_name_de'],
        'Hameln',
      );
    });
  });
}

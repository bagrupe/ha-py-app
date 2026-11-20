import 'package:app/common/geofencing/geo_json_boundary.dart';
import 'package:app/common/geofencing/hameln_pyrmont_boundary_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GeoJsonBoundary', () {
    test('supports polygon holes and includes boundary points', () {
      final boundary = GeoJsonBoundary.fromJson('''
        {
          "type": "Polygon",
          "coordinates": [
            [[0, 0], [10, 0], [10, 10], [0, 10], [0, 0]],
            [[4, 4], [6, 4], [6, 6], [4, 6], [4, 4]]
          ]
        }
      ''');

      expect(boundary.contains(const LatLng(2, 2)), isTrue);
      expect(boundary.contains(const LatLng(5, 5)), isFalse);
      expect(boundary.contains(const LatLng(0, 5)), isTrue);
      expect(boundary.contains(const LatLng(12, 5)), isFalse);
    });

    test('uses the bundled Landkreis Hameln-Pyrmont boundary', () async {
      final source = await rootBundle.loadString(hamelnPyrmontBoundaryAsset);
      final boundary = GeoJsonBoundary.fromJson(source);

      expect(boundary.contains(const LatLng(52.1037, 9.3571)), isTrue);
      expect(boundary.contains(const LatLng(51.9851, 9.2525)), isTrue);
      expect(boundary.contains(const LatLng(52.3759, 9.7320)), isFalse);
    });
  });
}

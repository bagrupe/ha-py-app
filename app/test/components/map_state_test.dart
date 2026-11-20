import 'package:app/components/map/map_state/legacy/map_state_legacy.dart';
import 'package:app/components/map/map_state/map_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  const mapState = MapState(center: LatLng(123, 456), rotation: 30, zoom: 40);

  group('MapState Migration tests', () {
    test('Test old MapState copyWith', () {
      final updated = mapState.legacyCopyWith(
        center: const LatLng(586, 741),
        rotation: 10,
        zoom: 80,
      );

      expect(updated.center.latitude, 586);
      expect(updated.rotation, 10);
      expect(updated.zoom, 80);
    });

    test('Test new MapState copyWith', () {
      final updated = mapState.copyWith(
        center: const LatLng(586, 741),
        rotation: 10,
        zoom: 80,
      );

      expect(updated.center.latitude, 586);
      expect(updated.rotation, 10);
      expect(updated.zoom, 80);
    });

    test('legacy vs new copyWith should match', () {
      final legacyCopy = mapState.legacyCopyWith(
        center: const LatLng(586, 741),
        rotation: 10,
        zoom: 80,
      );
      final newCopy = mapState.copyWith(
        center: const LatLng(586, 741),
        rotation: 10,
        zoom: 80,
      );

      _expectMapStateEqual(newCopy, legacyCopy);
    });
  });
}

void _expectMapStateEqual(MapState a, MapState b) {
  expect(a.center, b.center);
  expect(a.rotation, b.rotation);
  expect(a.zoom, b.zoom);
}

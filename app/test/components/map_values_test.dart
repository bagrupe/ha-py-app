import 'package:app/common/kommune.dart';
import 'package:app/components/map/map_values.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

/// Checks that invalid camera inputs never reach tile projection.
void main() {
  for (final position in <List<double>>[
    [],
    [52],
    [52, 9, 1],
    [double.nan, 9],
    [52, double.infinity],
    [90, 9],
    [52, 181],
  ]) {
    test('falls back for $position', () {
      expect(
        MapValues.centerFrom(position),
        LatLng(KommuneIds.hapyMapPosition[0], KommuneIds.hapyMapPosition[1]),
      );
    });
  }
  test('keeps valid municipality coordinates', () {
    expect(MapValues.centerFrom([52, 9]), const LatLng(52, 9));
  });
  test('rejects nonfinite and out of range zoom', () {
    for (final zoom in [double.nan, double.infinity, -1.0, 24.0]) {
      expect(MapValues.isValidZoom(zoom), isFalse);
    }
    expect(MapValues.isValidZoom(0), isTrue);
    expect(MapValues.isValidZoom(23), isTrue);
  });
}

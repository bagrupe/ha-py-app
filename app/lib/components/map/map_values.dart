import 'package:app/common/kommune.dart';
import 'package:latlong2/latlong.dart';

/// Validates camera values before they reach Web Mercator tile calculations.
abstract final class MapValues {
  /// Lowest supported map zoom.
  static const minZoom = 0.0;

  /// Highest requested tile resolution; closer views upscale these tiles.
  static const maxNativeZoom = 18;

  /// Highest supported map zoom.
  static const maxZoom = 23.0;

  /// Checks finite coordinates within the Web Mercator projection.
  static bool isValidCenter(LatLng center) =>
      center.latitude.isFinite &&
      center.longitude.isFinite &&
      center.latitude.abs() <= 85.0511287798066 &&
      center.longitude.abs() <= 180;

  /// Checks finite zoom levels within the supported range.
  static bool isValidZoom(double zoom) =>
      zoom.isFinite && zoom >= minZoom && zoom <= maxZoom;

  /// Resolves a coordinate pair, falling back for missing or invalid values.
  static LatLng centerFrom(List<double> position) {
    if (position.length == 2) {
      final center = LatLng(position[0], position[1]);
      if (isValidCenter(center)) return center;
    }
    return LatLng(KommuneIds.hapyMapPosition[0], KommuneIds.hapyMapPosition[1]);
  }
}

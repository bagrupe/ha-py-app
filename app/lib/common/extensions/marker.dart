import 'dart:math';

import 'package:app/routes/karte/map_marker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Erweiterung für Listen von MarkerData zur Sortierung nach Z-Index unter Berücksichtigung einer Rotation.
extension MarkerExtensions on List<MarkerData> {
  /// Sortiert die Marker basierend auf ihrer Projektion und Rotation um den Z-Index.
  ///
  /// [rotationDeg] gibt den Rotationswinkel in Grad an, der bei der Sortierung berücksichtigt wird.
  void sortByZIndex(double rotationDeg) {
    const epsg = Epsg3857();
    final theta = degToRadian(rotationDeg);
    final cosTheta = cos(theta);
    final sinTheta = sin(theta);

    Point projectAndRotate(LatLng latLng) {
      final (x, y) = epsg.latLngToXY(latLng, 18);
      return Point(x * cosTheta - y * sinTheta, x * sinTheta + y * cosTheta);
    }

    final projection = <MarkerData, Point>{
      for (final marker in this) marker: projectAndRotate(marker.point),
    };

    // Sort the list of markers using the new coordinates
    sort((a, b) {
      final pointA = projection[a]!;
      final pointB = projection[b]!;
      final cmpY = pointA.y.compareTo(pointB.y);
      return cmpY != 0 ? cmpY : pointA.x.compareTo(pointB.x);
    });
  }
}

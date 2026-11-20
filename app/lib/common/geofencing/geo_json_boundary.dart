import 'dart:convert';
import 'dart:math';

import 'package:latlong2/latlong.dart';

/// A geographic boundary composed of GeoJSON polygon geometries.
class GeoJsonBoundary {
  /// Creates a boundary from polygons whose first ring is the exterior ring.
  const GeoJsonBoundary(this.polygons);

  /// Creates a boundary from a Polygon, MultiPolygon, Feature, or FeatureCollection.
  factory GeoJsonBoundary.fromJson(String source) {
    final document = jsonDecode(source);
    if (document is! Map<String, dynamic>) {
      throw const FormatException('The GeoJSON root must be an object.');
    }
    return GeoJsonBoundary(_parseDocument(document));
  }

  /// Polygon rings contained in this boundary.
  final List<List<List<LatLng>>> polygons;

  /// Returns whether [point] lies inside or directly on the boundary.
  bool contains(LatLng point) {
    return polygons.any((polygon) => _polygonContains(polygon, point));
  }

  static List<List<List<LatLng>>> _parseDocument(
    Map<String, dynamic> document,
  ) {
    return switch (document['type']) {
      'FeatureCollection' => _parseFeatureCollection(document),
      'Feature' => _parseGeometry(_object(document['geometry'])),
      'Polygon' || 'MultiPolygon' => _parseGeometry(document),
      _ => throw const FormatException(
        'Only Polygon and MultiPolygon GeoJSON are supported.',
      ),
    };
  }

  static List<List<List<LatLng>>> _parseFeatureCollection(
    Map<String, dynamic> document,
  ) {
    return _list(document['features'])
        .expand(
          (feature) => _parseGeometry(_object(_object(feature)['geometry'])),
        )
        .toList(growable: false);
  }

  static List<List<List<LatLng>>> _parseGeometry(
    Map<String, dynamic> geometry,
  ) {
    final coordinates = _list(geometry['coordinates']);
    return switch (geometry['type']) {
      'Polygon' => [_parsePolygon(coordinates)],
      'MultiPolygon' =>
        coordinates
            .map((polygon) => _parsePolygon(_list(polygon)))
            .toList(growable: false),
      _ => throw const FormatException(
        'Only Polygon and MultiPolygon geometries are supported.',
      ),
    };
  }

  static List<List<LatLng>> _parsePolygon(List<dynamic> coordinates) {
    if (coordinates.isEmpty) {
      throw const FormatException('A polygon requires an exterior ring.');
    }
    return coordinates
        .map((ring) {
          final positions = _list(ring);
          if (positions.length < 4) {
            throw const FormatException(
              'A polygon ring requires four positions.',
            );
          }
          return positions
              .map((position) {
                final values = _list(position);
                if (values.length < 2 ||
                    values[0] is! num ||
                    values[1] is! num) {
                  throw const FormatException('Invalid GeoJSON position.');
                }
                return LatLng(
                  (values[1] as num).toDouble(),
                  (values[0] as num).toDouble(),
                );
              })
              .toList(growable: false);
        })
        .toList(growable: false);
  }

  static bool _polygonContains(List<List<LatLng>> polygon, LatLng point) {
    final exterior = _ringContains(polygon.first, point);
    if (exterior == _RingContainment.outside) return false;
    if (exterior == _RingContainment.boundary) return true;

    for (final hole in polygon.skip(1)) {
      final holeContainment = _ringContains(hole, point);
      if (holeContainment == _RingContainment.inside) return false;
      if (holeContainment == _RingContainment.boundary) return true;
    }
    return true;
  }

  static _RingContainment _ringContains(List<LatLng> ring, LatLng point) {
    var inside = false;
    for (
      var currentIndex = 0, previousIndex = ring.length - 1;
      currentIndex < ring.length;
      previousIndex = currentIndex++
    ) {
      final current = ring[currentIndex];
      final previous = ring[previousIndex];
      if (_isOnSegment(point, previous, current)) {
        return _RingContainment.boundary;
      }

      final crossesLatitude =
          (current.latitude > point.latitude) !=
          (previous.latitude > point.latitude);
      if (!crossesLatitude) continue;

      final intersectionLongitude =
          (previous.longitude - current.longitude) *
              (point.latitude - current.latitude) /
              (previous.latitude - current.latitude) +
          current.longitude;
      if (point.longitude < intersectionLongitude) inside = !inside;
    }
    return inside ? _RingContainment.inside : _RingContainment.outside;
  }

  static bool _isOnSegment(LatLng point, LatLng start, LatLng end) {
    const tolerance = 1e-7;
    final latitudeDelta = end.latitude - start.latitude;
    final longitudeDelta = end.longitude - start.longitude;
    final segmentLength = sqrt(
      latitudeDelta * latitudeDelta + longitudeDelta * longitudeDelta,
    );
    final crossProduct =
        (point.latitude - start.latitude) * (end.longitude - start.longitude) -
        (point.longitude - start.longitude) * (end.latitude - start.latitude);
    final distanceFromLine = segmentLength == 0
        ? sqrt(
            pow(point.latitude - start.latitude, 2) +
                pow(point.longitude - start.longitude, 2),
          )
        : crossProduct.abs() / segmentLength;
    if (distanceFromLine > tolerance) return false;

    return point.longitude >= min(start.longitude, end.longitude) - tolerance &&
        point.longitude <= max(start.longitude, end.longitude) + tolerance &&
        point.latitude >= min(start.latitude, end.latitude) - tolerance &&
        point.latitude <= max(start.latitude, end.latitude) + tolerance;
  }

  static Map<String, dynamic> _object(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    throw const FormatException('Expected a GeoJSON object.');
  }

  static List<dynamic> _list(dynamic value) {
    if (value is List<dynamic>) return value;
    throw const FormatException('Expected a GeoJSON array.');
  }
}

enum _RingContainment { outside, inside, boundary }

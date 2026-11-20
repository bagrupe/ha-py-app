import 'package:app/common/geofencing/geo_json_boundary.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bundled GeoJSON asset containing the Landkreis Hameln-Pyrmont boundary.
const hamelnPyrmontBoundaryAsset = 'assets/geofences/hameln_pyrmont.geojson';

/// Provides the parsed Landkreis Hameln-Pyrmont boundary.
final hamelnPyrmontBoundaryProvider = FutureProvider<GeoJsonBoundary>((
  ref,
) async {
  final source = await rootBundle.loadString(hamelnPyrmontBoundaryAsset);
  return GeoJsonBoundary.fromJson(source);
});

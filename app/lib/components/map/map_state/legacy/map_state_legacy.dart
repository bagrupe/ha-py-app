import 'package:app/components/map/map_state/map_state.dart';
import 'package:latlong2/latlong.dart';

/// Legacy manual functions kept temporarily for testing purposes.
/// These should be removed at a later point when migration is fully complete.
extension MapStateLegacy on MapState {
  /// Gibt eine Kopie des aktuellen Zustands zurück mit optionalen neuen Werten.
  /// [center], [zoom] und [rotation] überschreiben die aktuellen Werte.
  MapState legacyCopyWith({LatLng? center, double? zoom, double? rotation}) {
    return MapState(
      center: center ?? this.center,
      zoom: zoom ?? this.zoom,
      rotation: (rotation ?? this.rotation) % 360,
    );
  }
}

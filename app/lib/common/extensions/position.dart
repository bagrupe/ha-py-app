import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Erweiterung für Position zur Umwandlung in LatLng.
/// Bietet eine Methode, um die geografischen Koordinaten als LatLng-Objekt zurückzugeben.
extension PositionToLatLng on Position {
  /// Wandelt die Position in ein LatLng-Objekt um.
  LatLng toLatLng() => LatLng(latitude, longitude);
}

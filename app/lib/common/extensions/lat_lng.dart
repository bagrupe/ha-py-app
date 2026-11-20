import 'package:latlong2/latlong.dart';

/// Erweiterung für LatLng zur Ausgabe der Koordinaten als formatierter String.
extension FormattedLatLng on LatLng {
  /// Gibt die Breiten- und Längengrade mit sechs Nachkommastellen als String zurück.
  String get formatted =>
      '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
}

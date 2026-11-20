import 'package:app/graphql/__generated__/fragments.graphql.dart';
import 'package:app/graphql/__generated__/sensoren.graphql.dart';

/// Erweiterung für Fragment_SensorWithIcon zur Bereitstellung eines Icons.
/// Liefert das zugeordnete Icon oder ein alternatives Icon basierend auf den Feldern.
extension SensorIcon on Fragment_SensorWithIcon {
  /// Gibt das aufgelöste Icon zurück, entweder das direkte Icon oder das Icon des ersten Feldes mit Werteart.
  Fragment_PoiIcon? get resolvedIcon {
    return icon ?? felder?.firstWhere((f) => f.werteart != null).werteart?.icon;
  }
}

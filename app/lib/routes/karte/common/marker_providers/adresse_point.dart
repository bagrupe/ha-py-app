import 'package:app/graphql/__generated__/fragments.graphql.dart';
import 'package:collection/collection.dart';
import 'package:latlong2/latlong.dart';

/// Reads the point of the `adresse` slot, or null when the slot is missing,
/// hidden from the viewer or not a location object, so that one malformed
/// entry cannot abort the whole marker stream.
LatLng? adressePointOf(List<Fragment_SlotValue> slotValues) {
  final adresse = slotValues.firstWhereOrNull((s) => s.slotName == 'adresse');
  if (adresse is! Fragment_SlotValue__PlainSlotValue) return null;

  final value = adresse.plainValue;
  if (value is! Map<String, dynamic>) return null;

  return LatLng.fromJson(value);
}

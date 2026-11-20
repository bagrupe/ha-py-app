import 'package:app/common/extensions/sensor_with_icon.dart';
import 'package:app/common/kommune.dart';
import 'package:app/common/poi_category_prefs.dart';
import 'package:app/graphql/__generated__/sensoren.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/karte/map_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

/// Wandelt eine Liste von Sensordaten in eine Liste von MarkerData um.
/// [sensoren] sind die Sensordokumente aus der GraphQL-Abfrage.
List<MarkerData> _toMarkerData(
  Iterable<Query_Sensoren_sensoren_docs?> sensoren,
) {
  return sensoren.nonNulls.map((s) {
    final point = LatLng(s.position[0], s.position[1]);

    return MarkerData(
      id: s.id,
      type: MarkerType.sensor,
      point: point,
      marker: MapMarker(type: MarkerType.sensor, iconUrl: s.resolvedIcon?.url),
      routePrefix: '/karte/sensor/',
    );
  }).toList();
}

/// Provider, der einen Stream von Sensor-Markern liefert.
/// Nutzt die aktuelle Kommune und ausgewählte POI-Kategorien zur Filterung.
final sensorMarkerProvider = Provider<Stream<List<MarkerData>>>((ref) {
  final client = ref.read(graphqlClientProvider);
  final kommuneBId = ref.watch(kommuneProvider).requireValue.bereichBId;

  final selectedPoiCategories = ref
      .watch(poiCategoryFilterProvider)
      .currentPoiCategoriesPrefs;

  return client
      .watchQuery_Sensoren(
        WatchOptions_Query_Sensoren(
          fetchResults: true,
          variables: Variables_Query_Sensoren(kommuneId: kommuneBId),
        ),
      )
      .stream
      .map((result) => result.parsedData?.sensoren.docs.nonNulls ?? [])
      .map((sensoren) {
        if (selectedPoiCategories.isEmpty) {
          return const Iterable<Query_Sensoren_sensoren_docs>.empty();
        }
        final tmp = sensoren.where(
          (s) =>
              s.felder?.any(
                (f) => selectedPoiCategories.contains(f.werteart?.id),
              ) ??
              false,
        );
        return tmp;
      })
      .map(_toMarkerData);
});

import 'package:app/common/kommune.dart';
import 'package:app/common/poi_category_prefs.dart';
import 'package:app/graphql/__generated__/pois.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/karte/map_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql/client.dart' show ErrorPolicy, FetchPolicy;
import 'package:latlong2/latlong.dart';
import 'package:rxdart/rxdart.dart';

/// POI marker stream payload: markers for the map plus empty-cache offline flag.
typedef PoiMarkerPayload = ({List<MarkerData> markers, bool isOfflineEmpty});

/// Wandelt eine Liste von POI-Dokumenten in eine Liste von MarkerData um.
/// [pois] sind die POI-Dokumente aus der GraphQL-Abfrage.
List<MarkerData> _toMarkerData(Iterable<Query_Pois_pois_docs?> pois) {
  return pois.nonNulls.map((m) {
    final point = LatLng(m.position[0], m.position[1]);

    return MarkerData(
      id: m.id,
      type: MarkerType.poi,
      point: point,
      marker: MapMarker(type: MarkerType.poi, iconUrl: m.category?.icon?.url),
      routePrefix: '/karte/pois/',
    );
  }).toList();
}

/// Maps a POI query result into markers and the empty-cache offline flag.
///
/// Evaluates `hasException && parsedData == null` *before* category filtering
/// so a cache miss never masquerades as "no categories selected".
PoiMarkerPayload poiMarkerPayloadFromResult({
  required bool hasException,
  required Query_Pois? parsedData,
  required List<String> selectedPoiCategories,
}) {
  if (hasException && parsedData == null) {
    return (markers: const [], isOfflineEmpty: true);
  }

  final poiList = parsedData?.pois?.docs.nonNulls ?? const [];

  // Intentional empty filter: clean map, not an offline error.
  // Map UI shows "Filter (0)" via FilterMenu; no SnackBar is raised.
  if (selectedPoiCategories.isEmpty) {
    return (markers: const [], isOfflineEmpty: false);
  }

  final filtered = poiList.where(
    (poi) => selectedPoiCategories.contains(poi.category?.id),
  );

  return (markers: _toMarkerData(filtered), isOfflineEmpty: false);
}

/// Provider, der einen Stream von POI-Markern inkl. Offline-Leerzustand liefert.
/// Nutzt die aktuelle Kommune und ausgewählte POI-Kategorien zur Filterung.
///
/// [shareValue] broadcasts so the map combiner and [poiMarkerErrorProvider]
/// can both subscribe without a single-subscription crash.
final poiMarkerProvider = Provider<Stream<PoiMarkerPayload>>((ref) {
  final client = ref.read(graphqlClientProvider);
  final kommuneBId = ref.watch(kommuneProvider).requireValue.bereichBId;

  final selectedPoiCategories = ref
      .watch(poiCategoryFilterProvider)
      .currentPoiCategoriesPrefs;

  return client
      .watchQuery_Pois(
        WatchOptions_Query_Pois(
          // cacheAndNetwork: emit Hive data immediately, then refresh.
          // ErrorPolicy.all keeps cached markers usable when the network fails.
          fetchPolicy: FetchPolicy.cacheAndNetwork,
          errorPolicy: ErrorPolicy.all,
          fetchResults: true,
          variables: Variables_Query_Pois(kommuneId: kommuneBId, limit: 9999),
        ),
      )
      .stream
      .map(
        (result) => poiMarkerPayloadFromResult(
          hasException: result.hasException,
          parsedData: result.parsedData,
          selectedPoiCategories: selectedPoiCategories,
        ),
      )
      .shareValue();
});

/// Derived offline empty-cache signal for non-blocking Map SnackBar UI.
final poiMarkerErrorProvider = StreamProvider<bool>((ref) {
  return ref
      .watch(poiMarkerProvider)
      .map((payload) => payload.isOfflineEmpty)
      .distinct();
});

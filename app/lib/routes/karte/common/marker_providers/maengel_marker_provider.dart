import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/poi_category_prefs.dart';
import 'package:app/graphql/__generated__/maengel.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/karte/common/marker_providers/adresse_point.dart';
import 'package:app/routes/karte/common/marker_providers/polling_marker_stream.dart';
import 'package:app/routes/karte/map_marker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql/client.dart' show FetchPolicy;

/// Alias für die Liste der Mängel-Ausführungen aus der GraphQL-Abfrage.
typedef MaengelAusfuehrungen = Query_MaengelKarte_kommune_maengelAusfuehrungen;

/// ID der POI-Kategorie für Mängel.
const String maengelKategorieId = 'b6a89196-643a-4441-8d61-2482d9378f78';

/// Mängel without a visible address are skipped so one entry cannot abort the marker stream.
@visibleForTesting
List<MarkerData> toMaengelMarkerData(List<MaengelAusfuehrungen> maengel) {
  return maengel
      .map((m) {
        final point = adressePointOf(m.slotValues);
        if (point == null) return null;

        final type = m.status == Enum_AusfuehrungStatus.ABGESCHLOSSEN
            ? MarkerType.mangelCompleted
            : MarkerType.mangelOpen;

        return MarkerData(
          id: m.id,
          type: type,
          point: point,
          marker: MapMarker(type: type),
          routePrefix: '/karte/maengel/detail/',
        );
      })
      .whereType<MarkerData>()
      .toList();
}

/// Provider, der einen Stream von MarkerData für Mängel liefert.
/// Nutzt die aktuelle Kommune und POI-Kategorien zur Filterung.
final maengelMarkerProvider = Provider.autoDispose<Stream<List<MarkerData>>>((
  ref,
) {
  final client = ref.read(graphqlClientProvider);
  final kommuneAId = ref.watch(appConfigProvider).kommuneId;
  final currentPoiCategories = ref
      .watch(poiCategoryFilterProvider)
      .currentPoiCategoriesPrefs;

  final options = Options_Query_MaengelKarte(
    fetchPolicy: FetchPolicy.networkOnly,
    variables: Variables_Query_MaengelKarte(
      kommuneId: kommuneAId,
      filter: Input_SlotValueFilterInput(
        or: [
          Input_SlotValueFilterInput(
            slotName: Input_StringOperationFilterInput(eq: 'adresse'),
          ),
        ],
      ),
    ),
  );

  return pollingMarkerStream(
    ref,
    enabled: currentPoiCategories.contains(maengelKategorieId),
    fetch: () async {
      final result = await client.query_MaengelKarte(options);
      final data = result.parsedData;
      if (data == null) return null;
      return toMaengelMarkerData(data.kommune.maengelAusfuehrungen);
    },
  );
});

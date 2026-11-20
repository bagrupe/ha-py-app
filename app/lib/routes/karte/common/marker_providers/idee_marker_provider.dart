import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/kommune.dart';
import 'package:app/common/poi_category_prefs.dart';
import 'package:app/graphql/__generated__/idee.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/karte/common/marker_providers/adresse_point.dart';
import 'package:app/routes/karte/common/marker_providers/polling_marker_stream.dart';
import 'package:app/routes/karte/map_marker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql/client.dart' show FetchPolicy;

/// Alias für die Liste der Ideen-Ausführungen aus der GraphQL-Abfrage.
typedef IdeenAusfuehrungen = Query_IdeenKarte_kommune_ideenAusfuehrungen;

/// ID der POI-Kategorie für Ideen.
const String ideenKategorieId = 'a1e3f8d2-9c47-4b62-8a1e-5d9f2c3b7e60';

/// Wandelt eine Liste von Ideen-Ausführungen in eine Liste von MarkerData um.
/// [ideen] ist die Liste der Ideen-Ausführungen, [iconUrl] das im CMS
/// hinterlegte Ideenmelder-Icon. Ideen mit fehlender oder unerwartet
/// geformter Adresse werden übersprungen statt die gesamte Liste (und damit
/// den Marker-Stream) durch eine Exception abzubrechen.
@visibleForTesting
List<MarkerData> toMarkerData(List<IdeenAusfuehrungen> ideen, String? iconUrl) {
  return ideen
      .map((i) {
        final point = adressePointOf(i.slotValues);
        if (point == null) return null;

        final type = i.status == Enum_AusfuehrungStatus.ABGESCHLOSSEN
            ? MarkerType.ideeCompleted
            : MarkerType.ideeOpen;

        return MarkerData(
          id: i.id,
          type: type,
          point: point,
          marker: MapMarker(type: type, iconUrl: iconUrl),
          routePrefix: '/karte/ideen/detail/',
        );
      })
      .whereType<MarkerData>()
      .toList();
}

/// Provider, der einen Stream von MarkerData für Ideen liefert.
/// Nutzt die aktuelle Kommune und POI-Kategorien zur Filterung.
final ideeMarkerProvider = Provider.autoDispose<Stream<List<MarkerData>>>((
  ref,
) {
  final client = ref.read(graphqlClientProvider);
  final kommuneAId = ref.watch(appConfigProvider).kommuneId;
  final currentPoiCategories = ref
      .watch(poiCategoryFilterProvider)
      .currentPoiCategoriesPrefs;
  final ideenIconUrl = ref.watch(kommuneProvider).value?.design?.ideenIcon?.url;

  final options = Options_Query_IdeenKarte(
    fetchPolicy: FetchPolicy.networkOnly,
    variables: Variables_Query_IdeenKarte(
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
    enabled: currentPoiCategories.contains(ideenKategorieId),
    fetch: () async {
      final result = await client.query_IdeenKarte(options);
      final data = result.parsedData;
      if (data == null) return null;
      return toMarkerData(data.kommune.ideenAusfuehrungen, ideenIconUrl);
    },
  );
});

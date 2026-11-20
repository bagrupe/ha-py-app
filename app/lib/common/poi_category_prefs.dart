// ignore_for_file: cascade_invocations

import 'package:app/common/kommune.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/graphql/__generated__/poi-categories.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String selectedPoiCategoriesPrefKey = 'selectedPoiCategories';

/// Repräsentiert den Zustand der ausgewählten POI-Kategorien.
class PoiCategoryFilterState {
  /// Erstellt einen neuen Zustand mit der aktuellen Liste der POI-Kategorien.
  const PoiCategoryFilterState(this.currentPoiCategoriesPrefs);
  final List<String> currentPoiCategoriesPrefs;
}

/// Notifier zur Verwaltung und Persistierung der POI-Kategorien-Auswahl.
class PoiCategoryFilterNotifier extends Notifier<PoiCategoryFilterState> {
  @override
  /// Initialisiert den Zustand mit den gespeicherten POI-Kategorien aus den SharedPreferences.
  PoiCategoryFilterState build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final poiFilter = prefs.getStringList(selectedPoiCategoriesPrefKey) ?? [];

    return PoiCategoryFilterState(poiFilter);
  }

  /// Aktualisiert die Auswahl der POI-Kategorien und speichert diese persistent.
  /// [nextPoiCategoryFilter] ist die neue Liste der ausgewählten Kategorien.
  void updatePoiCategories(List<String> nextPoiCategoryFilter) {
    state = PoiCategoryFilterState(nextPoiCategoryFilter);
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setStringList(selectedPoiCategoriesPrefKey, nextPoiCategoryFilter);
  }

  /// Setzt die Auswahl so, dass nur Sensor-Kategorien ausgewählt sind.
  /// Lädt die Sensor-Kategorien aus dem GraphQL-Backend basierend auf der Kommune.
  Future<void> ensureOnlySensorenSelected() async {
    final client = ref.read(graphqlClientProvider);
    final kommune = await ref.read(kommuneProvider.future);

    final sensorenKategorien = await client.query_SensorArtIds(
      Options_Query_SensorArtIds(
        variables: Variables_Query_SensorArtIds(
          kommuneIdBereichB: kommune.bereichBId,
        ),
      ),
    );

    final ids =
        sensorenKategorien.parsedData?.sensorArten.docs
            .map((d) => d.id)
            .nonNulls
            .toList() ??
        [];

    updatePoiCategories(ids);
  }
}

/// Provider für den POI-Kategorien-Filter und dessen Notifier.
final poiCategoryFilterProvider =
    NotifierProvider<PoiCategoryFilterNotifier, PoiCategoryFilterState>(
      PoiCategoryFilterNotifier.new,
    );

// ignore_for_file: unawaited_futures

import 'package:app/common/poi_category_prefs.dart';
import 'package:app/components/map/controls/map_control_button.dart';
import 'package:app/components/map/map_controller.dart';
import 'package:app/routes/overlays/location_search/location_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ein Button, der eine Suchfunktion für Orte auf der Karte bereitstellt.
class SearchButton extends ConsumerWidget {
  const SearchButton({super.key});

  /// Öffnet die Suchoberfläche und verarbeitet das Suchergebnis.
  ///
  /// [context] wird für die Navigation und UI benötigt.
  /// [ref] ermöglicht den Zugriff auf Provider und deren Zustand.
  Future<void> _searchLocation(BuildContext context, WidgetRef ref) async {
    final mapController = ref.read(mapControllerProvider);
    final result = await LocationSearch.open(context, ref);

    if (result == null) {
      // Markierung entfernen, wenn die Suche geschlossen wird
      mapController.clearMarkedPosition();
      return;
    }
    mapController.animateTo(dest: result.position);

    if (result.shouldMark) {
      mapController.markPosition(result.position);
    }

    final overrideFilter = result.overrideFilter ?? [];
    if (overrideFilter.isNotEmpty) {
      final poiCategoryFilterNotifier = ref.read(
        poiCategoryFilterProvider.notifier,
      );
      final currentFilter = ref
          .read(poiCategoryFilterProvider)
          .currentPoiCategoriesPrefs;
      final mergedFilter = [...overrideFilter, ...currentFilter];
      final nextFilter = Set.of(mergedFilter);
      poiCategoryFilterNotifier.updatePoiCategories(nextFilter.toList());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MapControlButton(
      onPressed: () => _searchLocation(context, ref),
      icon: Icons.search,
    );
  }
}

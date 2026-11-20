import 'package:app/common/poi_category_prefs.dart';
import 'package:app/components/filter_button/filter_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Ein Widget, das einen Filter-Button mit der Anzahl der ausgewählten POI-Kategorien anzeigt.
/// Öffnet beim Betätigen eine Seite zur Auswahl der Kategorien.
///
/// Always shows the selection count (including 0) so an intentional empty
/// filter is distinguishable from a loading/offline failure on the map.
class FilterMenu extends ConsumerWidget {
  const FilterMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategories = ref
        .watch(poiCategoryFilterProvider)
        .currentPoiCategoriesPrefs;
    return SizedBox(
      width: 120,
      child: FilterButton(
        text: 'Filter (${selectedCategories.length})',
        onPressed: () => context.push('/karte/categories-filter'),
      ),
    );
  }
}

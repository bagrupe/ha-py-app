import 'package:app/common/extensions/text_theme.dart';
import 'package:app/graphql/__generated__/pois.graphql.dart';
import 'package:app/routes/overlays/location_search/components/result_card.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef PoiSearchQueryResult = Query_PoiSearch_pois_docs;
typedef PoiSearchCategory = Query_PoiSearch_pois_docs_category;
typedef OnPoiSearchResultSelected = void Function(PoiSearchQueryResult);

/// Widget zur Darstellung einer Liste von POI-Suchergebnissen.
/// Gruppiert die Ergebnisse nach Kategorie und zeigt diese gruppiert an.
class PoiSearchResult extends StatelessWidget {
  const PoiSearchResult({
    required this.results,
    required this.onResultSelected,
    super.key,
  });

  /// Liste der POI-Suchergebnisse.
  final List<PoiSearchQueryResult> results;

  /// Callback, das bei Auswahl eines Suchergebnisses ausgeführt wird.
  final OnPoiSearchResultSelected onResultSelected;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) return const SizedBox.shrink();

    final categorizedResults = results
        .where((poi) => poi.category != null)
        .toList();
    if (categorizedResults.isEmpty) return const SizedBox.shrink();

    final groupedByCategory = groupBy(
      categorizedResults,
      (poi) => poi.category!.id,
    );

    return ResultCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groupedByCategory.entries
              .map(
                (entry) => PoiSearchResultCategoryGroup(
                  category: entry.value.first.category!,
                  results: entry.value,
                  onResultSelected: onResultSelected,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

/// Widget zur Darstellung einer Gruppe von POI-Suchergebnissen einer Kategorie.
/// Zeigt den Kategorienamen und die zugehörigen Ergebnisse an.
class PoiSearchResultCategoryGroup extends StatelessWidget {
  const PoiSearchResultCategoryGroup({
    required this.category,
    required this.results,
    required this.onResultSelected,
    super.key,
  });

  /// Kategorie der POIs.
  final PoiSearchCategory category;

  /// Liste der POIs in dieser Kategorie.
  final List<PoiSearchQueryResult> results;

  /// Callback, das bei Auswahl eines Suchergebnisses ausgeführt wird.
  final OnPoiSearchResultSelected onResultSelected;

  @override
  Widget build(BuildContext context) {
    final colorTextTheme = Theme.of(context).colorTextTheme;
    final textTheme = Theme.of(context).textTheme;
    final iconUrl = category.icon?.url;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(category.title, style: colorTextTheme.titleLarge),
        ),
        const SizedBox(height: 6),
        ...results.map(
          (r) => InkWell(
            onTap: () => onResultSelected(r),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 23,
                      maxWidth: 23,
                    ),
                    child: iconUrl == null || iconUrl.isEmpty
                        ? const SizedBox.shrink()
                        : SvgPicture.network(iconUrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: Text(r.title, style: textTheme.bodySmall)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

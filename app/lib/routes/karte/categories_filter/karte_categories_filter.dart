import 'dart:collection';

import 'package:app/common/kommune.dart';
import 'package:app/common/poi_category_prefs.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/heading/heading.dart';
import 'package:app/components/heading/heading_with_divider.dart';
import 'package:app/components/lists/error_state.dart';
import 'package:app/graphql/__generated__/fragments.graphql.dart';
import 'package:app/graphql/__generated__/poi-categories.graphql.dart';
import 'package:app/routes/karte/categories_filter/components/category_button_list.dart';
import 'package:app/routes/karte/common/marker_providers/idee_marker_provider.dart';
import 'package:app/routes/karte/common/marker_providers/maengel_marker_provider.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql/client.dart' show ErrorPolicy, FetchPolicy;

typedef Superkategorie =
    Query_PoiCategoryForKommune_poiCategories_docs_supercategory;
typedef Kategorie = Query_PoiCategoryForKommune_poiCategories_docs;

/// Widget zur Anzeige und Auswahl von POI-Kategorien in der Kartenansicht.
class KarteCategoriesFilter extends ConsumerStatefulWidget {
  const KarteCategoriesFilter({super.key});

  @override
  ConsumerState<KarteCategoriesFilter> createState() =>
      _KarteCategoriesFilterState();
}

/// Vordefinierte Superkategorie für zusätzliche Kategorien.
final weiteresSuperKategorie = Superkategorie(
  id: '00464dc5-0070-4d3d-9fd0-da1deb8011eb',
  title: 'Weiteres',
);

/// State-Klasse für die Verwaltung des Zustands und der UI der Kategorie-Filterseite.
class _KarteCategoriesFilterState extends ConsumerState<KarteCategoriesFilter> {
  bool filterSwitchState = false;
  List<String> options = [];

  @override
  void initState() {
    options = List.from(
      ref.read(poiCategoryFilterProvider).currentPoiCategoriesPrefs,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final kommune = ref.watch(kommuneProvider).value;

    final poiCategoryFilterNotifier = ref.watch(
      poiCategoryFilterProvider.notifier,
    );

    if (kommune == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: const CommonAppBar(title: Text('Karte')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Query_PoiCategoryForKommune_Widget(
          options: Options_Query_PoiCategoryForKommune(
            fetchPolicy: FetchPolicy.cacheAndNetwork,
            errorPolicy: ErrorPolicy.all,
            variables: Variables_Query_PoiCategoryForKommune(
              kommuneIdBereichB: kommune.bereichBId,
              sort: 'title',
            ),
          ),
          builder: (result, {fetchMore, refetch}) {
            if (result.hasException && result.parsedData == null) {
              return ListErrorState(
                message: 'application.error.offline_no_cache'.tr(),
                onRetry: refetch,
              );
            }

            if (result.isLoading && result.parsedData == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final kategorien = SplayTreeMap<Superkategorie, List<Kategorie>>(
              (a, b) => a.title.compareTo(b.title),
            );
            final poiCategories =
                result.parsedData?.poiCategories?.docs.nonNulls ?? [];
            for (final poiCategory in poiCategories) {
              final supercat = poiCategory.supercategory;
              if (supercat == null) continue;
              kategorien[supercat] ??= [];
              kategorien[supercat]!.add(poiCategory);
            }

            final sensorArten =
                result.parsedData?.sensorArten.docs.nonNulls.where(
                  (a) => a.icon != null && a.icon!.url != null,
                ) ??
                [];
            if (sensorArten.isNotEmpty) {
              final sensorenSuperKategorie = Superkategorie(
                id: 'fake',
                title: 'Sensoren',
              );
              final sensorArtKategorien = sensorArten
                  .sortedBy((a) => a.name)
                  .map(
                    (a) => Kategorie(
                      id: a.id,
                      title: a.name,
                      supercategory: sensorenSuperKategorie,
                      icon: a.icon,
                    ),
                  )
                  .toList();

              kategorien[sensorenSuperKategorie] = sensorArtKategorien;
            }

            final maengelIcon = kommune.design?.mangelIcon;
            final ideenIcon = kommune.design?.ideenIcon;
            final weitereKategorien = [
              Kategorie(
                id: maengelKategorieId,
                title: 'application.map.categories.defects'.tr(),
                icon: maengelIcon == null
                    ? null
                    : Fragment_PoiIcon(
                        id: maengelIcon.id,
                        url: maengelIcon.url,
                      ),
                supercategory: weiteresSuperKategorie,
              ),
              Kategorie(
                id: ideenKategorieId,
                title: 'application.map.categories.idea_reporter'.tr(),
                icon: ideenIcon == null
                    ? null
                    : Fragment_PoiIcon(id: ideenIcon.id, url: ideenIcon.url),
                supercategory: weiteresSuperKategorie,
              ),
            ];
            if (weitereKategorien.isNotEmpty) {
              kategorien[weiteresSuperKategorie] = weitereKategorien;
            }

            final allOptionIds = [
              ...poiCategories.map((category) => category.id),
              ...sensorArten.map((a) => a.id),
              maengelKategorieId,
              ideenKategorieId,
            ];

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Heading(
                      'Filter (${options.length})',
                      horizontalPadding: false,
                    ),
                    Row(
                      children: [
                        Text(
                          'Alle auswählen',
                          style: theme.textTheme.bodySmall,
                        ),
                        Switch(
                          activeThumbColor: theme.primaryColor,
                          value:
                              allOptionIds.length == options.length ||
                              filterSwitchState,
                          onChanged: (bool isActive) {
                            setState(() {
                              filterSwitchState = isActive;
                              options = isActive ? allOptionIds : [];
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: kategorien.keys.length,
                    itemBuilder: (BuildContext context, int index) {
                      final superCategory = kategorien.keys.elementAt(index);
                      return Column(
                        children: [
                          HeadingWithDivider(
                            title: superCategory.title,
                            primary: true,
                          ),
                          const SizedBox(height: 10),
                          CategoryButtonList(
                            poiCategories: kategorien[superCategory]!,
                            selectedOptions: options,
                            fallbackIcons: const {
                              maengelKategorieId: Icons.campaign_outlined,
                              ideenKategorieId: Icons.lightbulb_outline,
                            },
                            onChange: (String categoryId) {
                              setState(() {
                                if (options.contains(categoryId)) {
                                  options.remove(categoryId);
                                } else {
                                  options.add(categoryId);
                                }
                              });
                            },
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 15);
                    },
                  ),
                ),
                const SizedBox(height: 15),
                OutlinedButton(
                  onPressed: () {
                    poiCategoryFilterNotifier.updatePoiCategories(options);
                    context.pop();
                  },
                  child: const Text('Filter übernehmen'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

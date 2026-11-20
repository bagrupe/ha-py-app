import 'dart:ui';

import 'package:app/common/design_tokens.dart';
import 'package:app/common/kommune.dart';
import 'package:app/common/util/scaler.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/map/map.dart';
import 'package:app/components/snackbar/app_snackbar.dart';
import 'package:app/components/transition_page/transition_page_builders.dart';
import 'package:app/routes/ideas/ideas.dart';
import 'package:app/routes/karte/categories_filter/karte_categories_filter.dart';
import 'package:app/routes/karte/common/marker_providers/poi_marker_provider.dart';
import 'package:app/routes/karte/common/marker_providers/polling_marker_stream.dart';
import 'package:app/routes/karte/common/marker_providers/root_marker_provider.dart';
import 'package:app/routes/karte/components/map_action_button.dart';
import 'package:app/routes/karte/ideahub_visibility_provider.dart';
import 'package:app/routes/karte/ideen/idee_detail.dart';
import 'package:app/routes/karte/map_marker.dart';
import 'package:app/routes/karte/sensor.dart';
import 'package:app/routes/maengel/maengel.dart';
import 'package:app/routes/pois/pois_detail.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:url_launcher/url_launcher.dart';

const karteIntroShownKey = 'karteIntroShownKey';

/// Seite mit der interaktiven Karte der Kommunal-App.
/// Zeigt Marker für verschiedene Objekte und bietet Navigation zu Detailseiten.
class KartePage extends ConsumerWidget {
  const KartePage({super.key});

  /// Baut das Widget mit Karte, Markern und Bedienelementen.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultPosition =
        ref
            .watch(kommuneProvider)
            .value
            ?.defaultPosition
            .whereType<double>()
            .toList() ??
        KommuneIds.hapyMapPosition;

    final tabActive = TickerMode.valuesOf(context).enabled;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        ref.read(markerPollingActiveProvider).value = tabActive;
      }
    });

    // Offline empty-cache only: filter-deselected POIs yield a clean map
    // (isOfflineEmpty=false) and must not show this SnackBar.
    // Retry invalidates the shared POI watchQuery stream.
    ref.listen(poiMarkerErrorProvider, (previous, next) {
      // Use AsyncData only — Riverpod 3 keeps the previous value on AsyncLoading,
      // which would re-show the SnackBar immediately after invalidate/retry.
      if (next is! AsyncData<bool> || next.value != true) return;

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          AppSnackBar(
            message: 'application.error.offline_no_cache'.tr(),
            actionLabel: 'application.error.retry'.tr(),
            onAction: () => ref.invalidate(poiMarkerProvider),
            context: context,
          ),
        );
    });

    return Scaffold(
      appBar: CommonAppBar(
        title: Text('application.bottom_navigation.map'.tr()),
        logo: true,
      ),
      body: Stack(
        children: [
          KommunalAppMap(
            layers: [
              Consumer(
                builder: (_, ref, __) => StreamBuilder<List<MarkerData>>(
                  stream: ref.watch(sortedMarkerProvider),
                  builder: (context, snapshot) {
                    final markers =
                        snapshot.data
                            ?.map(
                              (m) => Marker(
                                height: 54,
                                width: 40,
                                point: m.point,
                                alignment: Alignment.topCenter,
                                child: GestureDetector(
                                  onTap: () =>
                                      context.push(m.routePrefix + m.id),
                                  child: m.marker,
                                ),
                              ),
                            )
                            .toList() ??
                        [];
                    final scaleFactor = MediaQuery.textScalerOf(
                      context,
                    ).scaleFactor;
                    final normalizedSF = (scaleFactor - 1.0).clamp(0.0, 1.0);
                    final clusterSize = lerpDouble(43, 68, normalizedSF)!;

                    return MarkerClusterLayerWidget(
                      options: MarkerClusterLayerOptions(
                        showPolygon: false,
                        maxClusterRadius: 120,
                        size: Size(clusterSize, clusterSize),
                        alignment: Alignment.center,
                        maxZoom: 20,
                        padding: const EdgeInsets.all(80),
                        markers: markers,
                        builder: (context, markers) {
                          final count = markers.length;
                          final t = ((count - 2) / (100 - 2)).clamp(0.0, 1.0);
                          final dynamicScale = 1.0 + lerpDouble(0.3, 0.8, t)!;

                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Transform.scale(
                                scale: dynamicScale,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: DesignTokens.white.withAlpha(170),
                                  ),
                                ),
                              ),
                              Container(
                                width: clusterSize,
                                height: clusterSize,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: DesignTokens.gray900,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    clusterSize,
                                  ),
                                  color: DesignTokens.white,
                                ),
                                child: Center(
                                  child: Text(
                                    count > 99 ? '99+' : count.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: DesignTokens.gray900,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textScaler: TextScaler.linear(
                                      MediaQuery.of(
                                            context,
                                          ).textScaler.scale(16).clamp(16, 25) /
                                          16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
            defaultPosition: defaultPosition,
            withShowcase: true,
          ),
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    final visibility = ref.watch(ideahubVisibilityProvider);
                    return visibility.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (isVisible) {
                        if (!isVisible) return const SizedBox.shrink();
                        return MapActionButton(
                          onPressed: () => context.push('/karte/ideahub'),
                          iconData: Symbols.emoji_objects,
                          semanticsLabel:
                              'application.map.actions.ideenmelder.label'.tr(),
                          tooltip: 'application.map.actions.ideenmelder.tooltip'
                              .tr(),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 8),
                MapActionButton(
                  onPressed: () => context.push('/karte/maengel'),
                  iconData: Icons.campaign_outlined,
                  semanticsLabel: 'application.map.actions.maengelmelder.label'
                      .tr(),
                  tooltip: 'application.map.actions.maengelmelder.tooltip'.tr(),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () =>
                  launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              child: const Text('© OpenStreetMap contributors'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Definition der Route für die Karte mit Unterrouten zu Detailseiten und Filtern.
final karteRoute = GoRoute(
  path: '/karte',
  pageBuilder: TransitionPageBuilders.noTransition(
    builder: (_, state) => const KartePage(),
  ),
  routes: [
    GoRoute(
      path: 'pois/:id',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, state) => PoisDetailPage(id: state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: 'sensor/:id',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, state) => KarteSensorPage(id: state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: 'ideen/detail/:id',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, state) => IdeeDetailPage(id: state.pathParameters['id']!),
      ),
    ),
    maengelRoute,
    ideasRoute,
    ideaRoute,
    GoRoute(
      path: 'categories-filter',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, state) => const KarteCategoriesFilter(),
      ),
    ),
  ],
);

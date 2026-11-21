import 'dart:async';
import 'package:app/common/design_tokens.dart';
import 'package:app/common/extensions/text_theme.dart';
import 'package:app/common/gemeinde_prefs.dart';
import 'package:app/common/kommune.dart';
import 'package:app/common/notifications/firebase_push.dart';
import 'package:app/common/notifications/notifications.dart';
import 'package:app/common/poi_category_prefs.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/lists/error_state.dart';
import 'package:app/components/transition_page/transition_page_builders.dart';
import 'package:app/graphql/__generated__/news.graphql.dart';
import 'package:app/graphql/query_snapshot_store.dart';
import 'package:app/routes/aktuelles/components/aktuelles_aktion/aktuelles_aktion.dart';
import 'package:app/routes/aktuelles/components/news_artikel_card/news_artikel_card.dart';
import 'package:app/routes/aktuelles/components/weather_card_list/weather_card_list.dart';
import 'package:app/routes/aktuelles/components/weather_card_list/weather_provider.dart';
import 'package:app/routes/aktuelles/news.dart';
import 'package:app/routes/aktuelles/news_detail.dart';
import 'package:app/routes/karte/ideahub_visibility_provider.dart';
import 'package:app/routes/onboarding/onboarding_intro.dart';
import 'package:app/routes/termine/common/model/termin_art_filter_type.dart';
import 'package:app/routes/termine/common/termine_provider.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

typedef Artikel = Fragment_NewsArtikel;
typedef ArtikelInfo = Fragment_NewsArtikelInfo;

/// Main page for the news section with app bar and overview.
class AktuellesPage extends StatelessWidget {
  const AktuellesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: Text('application.news.title'.tr()),
        logo: true,
      ),
      body: const _AktuellesOverview(),
    );
  }
}

/// Defines the routes for the news section, including overview and detail pages.
final aktuellesRoute = GoRoute(
  path: '/aktuelles',
  pageBuilder: TransitionPageBuilders.noTransition(
    builder: (_, __) => const AktuellesPage(),
  ),
  routes: [
    GoRoute(
      path: 'news',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, __) => const NewsPage(),
      ),
    ),
    GoRoute(
      path: 'news/:id',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, state) => NewsDetailPage(id: state.pathParameters['id']!),
      ),
    ),
  ],
);

/// Overview component that shows news and weather cards.
/// Uses Riverpod for the municipality context and GraphQL for data loading.
class _AktuellesOverview extends ConsumerStatefulWidget {
  const _AktuellesOverview();

  @override
  ConsumerState<_AktuellesOverview> createState() => _AktuellesOverviewState();
}

class _AktuellesOverviewState extends ConsumerState<_AktuellesOverview> {
  /// Tracks whether the Aktuelles shell branch is the active IndexedStack child.
  /// Same recovery model as Termine: remount never happens, so tab re-activation
  /// must explicitly refetch stuck empty-cache errors.
  var _wasTabActive = false;

  /// Latest GraphQL [refetch] from the frontpage query builder.
  Future<void> Function()? _newsRefetch;

  /// Whether the frontpage query is currently in empty-cache error state.
  var _newsInError = false;

  /// Whether a tab activation retry check is scheduled after the current frame.
  var _isTabActivationRetryScheduled = false;

  String? _kommuneId;

  /// Signature of the most recently persisted frontpage snapshot.
  String? _lastNewsSnapshotSignature;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRequestPushPermissions();
    });
  }

  Future<void> _checkAndRequestPushPermissions() async {
    if (!mounted || !isFirebasePushAvailable) return;

    final prefs = ref.read(sharedPreferencesProvider);
    final onboardingCompleted =
        prefs.getBool(onboardingIntroCompletedKey) ?? false;
    final requestedAlready =
        prefs.getBool(pushNotificationRequestedKey) ?? false;

    if (onboardingCompleted && !requestedAlready) {
      final notifications = ref.read(notificationsProvider);
      await notifications.requestPermission();
      await prefs.setBool(pushNotificationRequestedKey, true);
    }
  }

  Future<void> _refreshAll(
    Future<void> Function()? refetch,
    String? kommuneId,
  ) async {
    await Future.wait([
      if (refetch != null) refetch(),
      if (kommuneId != null) _refreshWeather(kommuneId),
    ]);
  }

  Future<void> _refreshWeather(String kommuneId) async {
    ref.invalidate(weatherProvider(kommuneId));
    try {
      await ref.read(weatherProvider(kommuneId).future);
    } catch (_) {
      // Empty-cache offline: WeatherCardList hides via AsyncError.
    }
  }

  Future<void> _reloadAfterKommuneError() async {
    ref.invalidate(kommuneProvider);
    try {
      await ref.read(kommuneProvider.future);
    } catch (_) {
      // Still offline / empty cache.
    }
  }

  void _retryOnTabActivationIfNeeded() {
    final isTabActive = TickerMode.valuesOf(context).enabled;
    final becameActive = isTabActive && !_wasTabActive;
    _wasTabActive = isTabActive;
    if (!becameActive) return;

    final kommune = ref.read(kommuneProvider);
    if (kommune.hasError) {
      unawaited(_reloadAfterKommuneError());
      return;
    }

    final kommuneId = _kommuneId ?? kommune.value?.bereichBId;
    final weatherInError =
        kommuneId != null && ref.read(weatherProvider(kommuneId)).hasError;

    if (_newsInError || weatherInError) {
      unawaited(_refreshAll(_newsRefetch, kommuneId));
    }
  }

  /// Schedules the tab activation retry after the current build frame.
  void _scheduleTabActivationRetryIfNeeded() {
    if (_isTabActivationRetryScheduled) return;
    _isTabActivationRetryScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isTabActivationRetryScheduled = false;
      if (!mounted) return;
      _retryOnTabActivationIfNeeded();
    });
  }

  /// Persists changed frontpage data without blocking the widget build.
  Future<void> _persistNewsSnapshot(
    String snapshotKey,
    Query_NewsArtikelFrontpage data,
  ) async {
    final signature = '$snapshotKey:${data.hashCode}';
    if (_lastNewsSnapshotSignature == signature) return;
    _lastNewsSnapshotSignature = signature;
    try {
      await writeQuerySnapshot(snapshotKey, data.toJson());
    } catch (_) {
      _lastNewsSnapshotSignature = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    _scheduleTabActivationRetryIfNeeded();

    const padding = EdgeInsets.fromLTRB(16, 8, 16, 8);
    final kommune = ref.watch(kommuneProvider);
    final ideahubVisibility = ref.watch(ideahubVisibilityProvider);
    final theme = Theme.of(context);

    final gemeindeFilter = ref
        .watch(gemeindeFilterProvider)
        .currentGemeindePrefs;

    return kommune.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => RefreshIndicator(
        onRefresh: _reloadAfterKommuneError,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.6,
              child: ListErrorState(
                message: 'application.error.offline_no_cache'.tr(),
                onRetry: () => unawaited(_reloadAfterKommuneError()),
              ),
            ),
          ],
        ),
      ),
      data: (kommuneData) {
        final kommuneName = kommuneData.name;
        final kommuneId = kommuneData.bereichBId;
        _kommuneId = kommuneId;
        final variables = Variables_Query_NewsArtikelFrontpage(
          ordinal: 10,
          kommuneId: kommuneId,
          limit: 3,
          untereinheitenIds: gemeindeFilter,
        );

        return Query_NewsArtikelFrontpage_Widget(
          options: Options_Query_NewsArtikelFrontpage(variables: variables),
          builder: (result, {fetchMore, refetch}) {
            _newsRefetch = refetch;
            final snapshotKey = createQuerySnapshotKey(
              namespace: 'aktuelles',
              variables: variables.toJson(),
            );
            final queryData = result.parsedData;
            if (queryData != null) {
              unawaited(_persistNewsSnapshot(snapshotKey, queryData));
            }
            final data =
                queryData ??
                readQuerySnapshot(
                  snapshotKey,
                  Query_NewsArtikelFrontpage.fromJson,
                );
            _newsInError = result.hasException && data == null;

            if (_newsInError) {
              // AlwaysScrollable so pull-to-refresh works on the empty-cache
              // error screen (ListErrorState alone is not scrollable).
              return RefreshIndicator(
                onRefresh: () => _refreshAll(refetch, kommuneId),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.6,
                      child: ListErrorState(
                        message: 'application.error.offline_no_cache'.tr(),
                        onRetry: () => _refreshAll(refetch, kommuneId),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (result.isLoading && data == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final topThemaDocs = data?.topThemaNewsArtikelList?.docs ?? [];

            final artikelListDocs = data?.newsArtikelList?.docs ?? [];

            final maybeTopThemaWithArtikel =
                [topThemaDocs.firstOrNull, ...artikelListDocs].nonNulls
                    .take(3)
                    .sortedBy((e) => e.datum ?? DateTime.now())
                    .reversed
                    .toList();

            return RefreshIndicator(
              onRefresh: () => _refreshAll(refetch, kommuneId),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 22),
                  Padding(
                    padding: padding,
                    child: Text(
                      'application.news.overview_title'.tr(
                        namedArgs: {'commune': kommuneName},
                      ),
                      style: theme.textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: 24),
                  WeatherCardList(kommuneId: kommuneId),
                  const SizedBox(height: 24),
                  Padding(
                    padding: padding,
                    child: Row(
                      children: [
                        Text(
                          'application.news.latest'.tr(),
                          style: theme.textTheme.headlineSmall,
                        ),
                        const Expanded(
                          child: Divider(
                            indent: 12,
                            height: 1,
                            color: DesignTokens.gray300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: maybeTopThemaWithArtikel
                        .map(
                          (artikel) => Padding(
                            padding: padding,
                            child: _buildArtikelCard(
                              context,
                              artikel,
                              kommuneName,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Padding(
                    padding: padding,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IntrinsicHeight(
                        child: IntrinsicWidth(
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Text(
                                      'application.news.more_articles'.tr(),
                                      style: theme.colorTextTheme.bodySmall,
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => context.go('/aktuelles/news'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ideahubVisibility.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (isVisible) {
                      if (!isVisible) return const SizedBox.shrink();

                      return Padding(
                        padding: padding,
                        child: AktuellesAktion(
                          text: 'application.news.actions.ideenmelder'.tr(),
                          icon: Icons.lightbulb_outline,
                          link: '/karte/ideahub',
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: padding,
                    child: AktuellesAktion(
                      text: 'application.news.actions.maengelmelder'.tr(),
                      icon: Icons.campaign_outlined,
                      link: '/karte/maengel',
                    ),
                  ),
                  Padding(
                    padding: padding,
                    child: AktuellesAktion(
                      text: 'application.news.actions.waste_calendar'.tr(),
                      icon: Icons.calendar_month_outlined,
                      link: '/termine',
                      onClick: () =>
                          ref.read(terminArtFilterProvider.notifier).state =
                              TerminArtFilterType.abfall,
                    ),
                  ),
                  Padding(
                    padding: padding,
                    child: AktuellesAktion(
                      text: 'application.news.actions.sensors'.tr(),
                      icon: Icons.settings_input_antenna,
                      onClick: () => ref
                          .read(poiCategoryFilterProvider.notifier)
                          .ensureOnlySensorenSelected(),
                      link: '/karte',
                    ),
                  ),
                  Padding(
                    padding: padding,
                    child: AktuellesAktion(
                      text: 'application.news.actions.lagehelfer'.tr(),
                      icon: Icons.fire_truck_outlined,
                      link: '/lagehelfer',
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Builds a news article card with title, image, date and source.
  /// Navigates to the article detail page when tapped.
  Widget _buildArtikelCard(
    BuildContext context,
    ArtikelInfo artikel,
    String kommuneName,
  ) {
    return NewsArtikelCard(
      title: artikel.titel,
      imageUrl: artikel.titelbilder
          ?.map(
            (titelbild) =>
                titelbild.bild?.sizes?.thumbnail?.url ?? titelbild.bild?.url,
          )
          .firstOrNull,
      datum: artikel.datum,
      quelle: artikel.untereinheit?.name ?? kommuneName,
      onTap: () {
        context.go('/aktuelles/news/${artikel.id}');
      },
    );
  }
}

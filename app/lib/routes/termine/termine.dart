import 'dart:async';

import 'package:app/common/abfall/abfall_filter.dart';
import 'package:app/common/abfall/abfall_provider.dart';
import 'package:app/common/extensions/scroll_metrics.dart';
import 'package:app/common/kommune.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/lists/empty_state.dart';
import 'package:app/components/lists/error_state.dart';
import 'package:app/components/lists/loading_state.dart';
import 'package:app/components/searchbar/searchbar.dart';
import 'package:app/components/transition_page/transition_page_builders.dart';
import 'package:app/graphql/__generated__/kommune.graphql.dart';
import 'package:app/graphql/__generated__/termine.graphql.dart';
import 'package:app/routes/termine/common/filter_count_provider.dart';
import 'package:app/routes/termine/common/model/termin_art_filter_type.dart';
import 'package:app/routes/termine/common/model/termin_list/termin_list.dart';
import 'package:app/routes/termine/common/termine_provider.dart';
import 'package:app/routes/termine/components/abfall/abfall_filter_call_to_action.dart';
import 'package:app/routes/termine/components/abfall/abfall_filter_sheet.dart';
import 'package:app/routes/termine/components/termin_art_filter_chips.dart';
import 'package:app/routes/termine/components/termine_filter_button.dart';
import 'package:app/routes/termine/components/termine_list_view.dart';
import 'package:app/routes/termine/components/veranstaltung/veranstaltungen_detail.dart';
import 'package:app/routes/termine/components/veranstaltung/veranstaltungen_filter_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

typedef Veranstaltung = Fragment_Veranstaltung;
typedef VeranstaltungInfo = Fragment_VeranstaltungInfo;
typedef AbfallkalenderTermin = Fragment_AbfallkalenderTermin;
typedef VeranstaltungDates =
    List<Fragment_VeranstaltungInfo_timeAndLocation_dates>;
typedef CollapsedDates =
    List<
      (
        Fragment_VeranstaltungInfo_timeAndLocation_dates firstDate,
        List<DateTime> otherDates,
      )
    >;

/// Seite zur Anzeige der Übersicht aller Termine.
class TerminePage extends StatelessWidget {
  const TerminePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(title: Text('Termine'), logo: true),
      body: _TermineOverview(),
    );
  }
}

/// StatefulWidget für die Terminübersicht mit Riverpod-Unterstützung.
class _TermineOverview extends ConsumerStatefulWidget {
  const _TermineOverview();

  @override
  ConsumerState<_TermineOverview> createState() => _TermineOverviewState();
}

/// State-Klasse für die Terminübersicht, verwaltet Filter und Anzeige.
class _TermineOverviewState extends ConsumerState<_TermineOverview> {
  /// Tracks whether the Termine shell branch is the active IndexedStack child.
  ///
  /// [StatefulShellRoute.indexedStack] keeps this page mounted offstage, so a
  /// stuck [AsyncError] is never cleared by remount. When the tab becomes
  /// active again ([TickerMode] flips to true), we retry failed providers.
  var _wasTabActive = false;

  Future<void> _reload() async {
    ref.invalidate(kommuneProvider);
    try {
      await ref.read(filteredTermineProvider.notifier).reload();
    } catch (_) {
      // Still offline / empty cache — provider stays on AsyncError.
    }
  }

  void _retryOnTabActivationIfNeeded() {
    final isTabActive = TickerMode.valuesOf(context).enabled;
    final becameActive = isTabActive && !_wasTabActive;
    _wasTabActive = isTabActive;
    if (!becameActive) return;

    final kommune = ref.read(kommuneProvider);
    final termine = ref.read(filteredTermineProvider);
    if (kommune.hasError || termine.hasError) {
      unawaited(_reload());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Depend on TickerMode so IndexedStack tab switches rebuild this widget.
    _retryOnTabActivationIfNeeded();

    final kommune = ref.watch(kommuneProvider);

    return kommune.when(
      data: (data) => _buildContent(context, data),
      error: (error, stackTrace) => RefreshIndicator(
        onRefresh: _reload,
        child: _TermineErrorView(error: error, stackTrace: stackTrace),
      ),
      loading: () => const ListLoadingState(),
    );
  }

  Widget _buildContent(BuildContext context, Fragment_Kommune kommune) {
    final prefs = ref.watch(sharedPreferencesProvider);
    final termine = ref.watch(filteredTermineProvider);
    final terminArtFilterState = ref.watch(terminArtFilterProvider);
    final abfallFilterStandortId = ref
        .watch(abfallConfigProvider)
        .filter
        .standort;

    return RefreshIndicator(
      onRefresh: _reload,
      // NestedScrollView emits overscroll at depth 1 from the inner body.
      notificationPredicate: (notification) => notification.depth <= 1,
      child: NestedScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Anstehende Termine',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 40, child: TerminArtFilterChips()),
                  const SizedBox(height: 16),
                  Searchbar(
                    value: ref.watch(terminSearchValueProvider),
                    onChanged: (newSearch) =>
                        ref.read(terminSearchValueProvider.notifier).state =
                            newSearch,
                  ),
                  if (terminArtFilterState != TerminArtFilterType.alle)
                    TermineFilterButton(
                      filterText: ref.watch(filterCountProvider),
                      filterSheet: switch (terminArtFilterState) {
                        TerminArtFilterType.abfall => AbfallFilterSheet(
                          onConfirm: (String? nextFilter) {
                            if (nextFilter != null) {
                              prefs.setString(
                                AbfallFilterKeys.ortId,
                                nextFilter,
                              );
                            }
                            Navigator.pop(context);
                          },
                          onCancel: () => Navigator.pop(context),
                        ),
                        TerminArtFilterType.veranstaltung =>
                          VeranstaltungFilterSheet(
                            onCancel: () => Navigator.pop(context),
                          ),
                        _ => const SizedBox.shrink(),
                      },
                    ),
                  if (terminArtFilterState == TerminArtFilterType.alle)
                    const SizedBox(height: 16),
                  if (abfallFilterStandortId == null &&
                      terminArtFilterState == TerminArtFilterType.alle) ...[
                    AbfallFilterCTA(
                      onTap: () {
                        ref.read(terminArtFilterProvider.notifier).state =
                            TerminArtFilterType.abfall;
                        if (abfallFilterStandortId?.isEmpty ?? true) {
                          showModalBottomSheet<String?>(
                            isScrollControlled: true,
                            enableDrag: false,
                            isDismissible: false,
                            useSafeArea: true,
                            context: context,
                            builder: (context) {
                              return AbfallFilterSheet(
                                onConfirm: (String nextFilter) {
                                  prefs.setString(
                                    AbfallFilterKeys.ortId,
                                    nextFilter,
                                  );
                                  Navigator.pop(context);
                                },
                                onCancel: () => Navigator.pop(context),
                              );
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
        ],
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is! ScrollUpdateNotification) return false;
              if (notification.metrics.isNearBottom) {
                ref.read(filteredTermineProvider.notifier).fetchMore();
              }
              return false;
            },
            child: switch (termine) {
              AsyncData(:final value) => _TermineDataView(data: value),
              AsyncError(:final error, :final stackTrace) => _TermineErrorView(
                error: error,
                stackTrace: stackTrace,
              ),
              AsyncLoading(:final value) when value != null => _TermineDataView(
                data: value,
                isFetchingMore: true,
              ),
              _ => const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: ListLoadingState(),
              ),
            },
          ),
        ),
      ),
    );
  }
}

class _TermineDataView extends StatelessWidget {
  const _TermineDataView({required this.data, this.isFetchingMore = false});

  final TermineList data;
  final bool isFetchingMore;

  @override
  Widget build(BuildContext context) {
    if (data.veranstaltungen.isEmpty && data.abfallkalenderTermine.isEmpty) {
      return const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: ListEmptyState(
          message: 'Mit dem aktuellen Filter wurden keine Termine gefunden',
        ),
      );
    }
    return TermineListView(
      veranstaltungen: data.veranstaltungen,
      abfallkalenderTermine: data.abfallkalenderTermine,
      hasNextPage: data.hasNextPage,
      isFetchingMore: isFetchingMore,
    );
  }
}

class _TermineErrorView extends ConsumerWidget {
  const _TermineErrorView({required this.error, required this.stackTrace});

  final Object error;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('Termine Error: $error\n$stackTrace');
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ListErrorState(
        message: 'application.error.offline_no_cache'.tr(),
        onRetry: () =>
            unawaited(ref.read(filteredTermineProvider.notifier).reload()),
      ),
    );
  }
}

/// Definition der Route für die Terminübersicht und Detailseiten.
final termineRoute = GoRoute(
  path: '/termine',
  pageBuilder: TransitionPageBuilders.noTransition(
    builder: (_, state) => const TerminePage(),
  ),
  routes: [
    GoRoute(
      path: ':id',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, state) =>
            VeranstaltungDetailPage(id: state.pathParameters['id']!),
      ),
    ),
  ],
);

import 'dart:async';

import 'package:app/common/extensions/scroll_metrics.dart';
import 'package:app/common/gemeinde_prefs.dart';
import 'package:app/common/kommune.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/heading/heading_with_divider.dart';
import 'package:app/components/lists/empty_state.dart';
import 'package:app/components/lists/error_state.dart';
import 'package:app/components/lists/loading_state.dart';
import 'package:app/graphql/__generated__/news.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/routes/aktuelles/components/news_artikel_card/news_artikel_card.dart';
import 'package:app/routes/aktuelles/news_artikel_list_fetch_more.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

typedef Artikel = Fragment_NewsArtikel;
typedef ArtikelInfo = Fragment_NewsArtikelInfo;

/// Seite zur Anzeige der News-Übersicht mit AppBar und Liste der Artikel.
class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(title: Text('News')),
      body: _NewsOverview(),
    );
  }
}

/// Übersichtskomponente für News, die Artikel aus der Kommune und ggf. gefiltert nach Gemeinde anzeigt.
class _NewsOverview extends ConsumerStatefulWidget {
  const _NewsOverview();

  @override
  ConsumerState<_NewsOverview> createState() => _NewsOverviewState();
}

class _NewsOverviewState extends ConsumerState<_NewsOverview> {
  Future<void> Function()? _newsRefetch;

  Future<void> _reloadKommune() async {
    ref.invalidate(kommuneProvider);
    try {
      await ref.read(kommuneProvider.future);
    } catch (_) {
      // Still offline / empty cache.
    }
  }

  Future<void> _reloadNews() async {
    final refetch = _newsRefetch;
    if (refetch == null) return;
    try {
      await refetch();
    } catch (_) {
      // Still offline / empty cache — Query widget keeps the error result.
    }
  }

  Widget _scrollableError({required Future<void> Function() onRefresh}) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.6,
            child: ListErrorState(
              message: 'application.error.offline_no_cache'.tr(),
              onRetry: () => unawaited(onRefresh()),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kommune = ref.watch(kommuneProvider);
    final gemeindeFilter = ref
        .watch(gemeindeFilterProvider)
        .currentGemeindePrefs;

    return kommune.when(
      loading: () => const ListLoadingState(),
      error: (error, stackTrace) => _scrollableError(onRefresh: _reloadKommune),
      data: (kommuneData) {
        final kommuneName = kommuneData.name;
        final kommuneId = kommuneData.bereichBId;

        var variables = Variables_Query_NewsArtikelList(
          filter: Input_NewsArtikel_where(
            kommune: Input_NewsArtikel_kommune_operator(equals: kommuneId),
          ),
          limit: 50,
        );

        if (gemeindeFilter.isNotEmpty) {
          // Payload v3 drops null entries from relationship `in` lists, so
          // articles without untereinheit need an explicit OR branch.
          variables = variables.copyWith(
            filter: variables.filter.copyWith(
              OR: [
                Input_NewsArtikel_where_or(
                  untereinheit: Input_NewsArtikel_untereinheit_operator(
                    $in: gemeindeFilter,
                  ),
                ),
                Input_NewsArtikel_where_or(
                  untereinheit: Input_NewsArtikel_untereinheit_operator(
                    exists: false,
                  ),
                ),
              ],
            ),
          );
        }

        return Query_NewsArtikelList_Widget(
          options: Options_Query_NewsArtikelList(variables: variables),
          builder: (result, {fetchMore, refetch}) {
            _newsRefetch = refetch;

            final newsInError =
                result.hasException && result.parsedData == null;

            if (newsInError) {
              return _scrollableError(onRefresh: _reloadNews);
            }

            if (result.isLoading && result.parsedData == null) {
              return const ListLoadingState();
            }

            final artikelList = (result.parsedData?.newsArtikelList?.docs ?? [])
                .nonNulls
                .toList();

            Future<void> onRefresh() async {
              if (refetch != null) {
                await refetch();
              }
            }

            if (artikelList.isEmpty) {
              return RefreshIndicator(
                onRefresh: onRefresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.6,
                      child: const ListEmptyState(
                        message: 'Aktuell gibt es keine News in Ihrer Region.',
                      ),
                    ),
                  ],
                ),
              );
            }

            final newsList = result.parsedData!.newsArtikelList!;

            return RefreshIndicator(
              onRefresh: onRefresh,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (fetchMore == null ||
                      !shouldFetchNewsArtikelListNextPage(
                        isLoading: result.isLoading,
                        isNearBottom: scrollInfo.metrics.isNearBottom,
                        hasNextPage: newsList.hasNextPage,
                      )) {
                    return false;
                  }

                  final currentPage = newsList.page;
                  fetchMore(
                    FetchMoreOptions_Query_NewsArtikelList(
                      variables: variables.copyWith(page: currentPage + 1),
                      updateQuery: mergeNewsArtikelListFetchMoreData,
                    ),
                  );

                  return false;
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: _NewsHeader(kommuneName: kommuneName),
                    ),
                    SliverList.builder(
                      itemCount: artikelList.length,
                      itemBuilder: (context, index) {
                        return _NewsArtikelCardWrapper(
                          artikel: artikelList[index],
                          previousArtikel: index > 0
                              ? artikelList[index - 1]
                              : null,
                          kommuneName: kommuneName,
                        );
                      },
                    ),
                    if (result.isLoading && artikelList.isNotEmpty)
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 100,
                          child: ListLoadingState(padding: EdgeInsets.zero),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Header für die News-Übersicht.
class _NewsHeader extends StatelessWidget {
  const _NewsHeader({required this.kommuneName});

  final String kommuneName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aktuelles aus $kommuneName',
            style: theme.textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}

/// Baut eine Karte für einen News-Artikel mit optionaler Wochenkennzeichnung.
/// [context] für den Widget-Baum, [theme] für das Design, [artikel] der aktuelle Artikel,
/// [previousArtikel] der vorherige Artikel zur Wochenvergleich, [kommuneName] als Fallback für Quelle.
class _NewsArtikelCardWrapper extends StatelessWidget {
  const _NewsArtikelCardWrapper({
    required this.artikel,
    required this.previousArtikel,
    required this.kommuneName,
  });

  final ArtikelInfo artikel;
  final ArtikelInfo? previousArtikel;
  final String kommuneName;

  @override
  Widget build(BuildContext context) {
    final previousArtikelWeek = previousArtikel?.datum != null
        ? _getGermanWeekOfYear(previousArtikel!.datum!)
        : null;
    final artikelWeek = artikel.datum != null
        ? _getGermanWeekOfYear(artikel.datum!)
        : null;
    final currentWeek = _getGermanWeekOfYear(DateTime.now());

    final showLabel = previousArtikelWeek != artikelWeek && artikelWeek != null;

    final thumbnailImageUrls =
        artikel.titelbilder
            ?.map((titelbild) => titelbild.bild?.sizes?.thumbnail?.url)
            .toList() ??
        [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Column(
        children: [
          if (showLabel)
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: HeadingWithDivider(
                title: currentWeek == artikelWeek
                    ? 'Diese Woche'
                    : 'KW ${artikelWeek.toString().padLeft(2, "0")}${DateTime.now().year == artikel.datum!.year ? '' : ' - ${artikel.datum!.year}'}',
              ),
            ),
          NewsArtikelCard(
            title: artikel.titel,
            imageUrl:
                thumbnailImageUrls.firstOrNull ??
                artikel.titelbilder?.firstOrNull?.bild?.url,
            datum: artikel.datum,
            quelle: artikel.untereinheit?.name ?? kommuneName,
            onTap: () {
              context.push('/aktuelles/news/${artikel.id}');
            },
          ),
        ],
      ),
    );
  }

  /// Berechnet die Kalenderwoche nach deutschem Standard für ein gegebenes Datum.
  /// [date] ist das Datum, für das die Kalenderwoche ermittelt wird.
  int _getGermanWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year);
    final firstWeekday = firstDayOfYear.weekday;
    int firstMonday;

    if (firstWeekday <= 4) {
      // Mo, Di, Mi, Do
      firstMonday = 1 + ((1 - firstWeekday) % 7);
    } else {
      // Fr, Sa, So
      firstMonday = 1 + ((8 - firstWeekday) % 7);
    }

    final firstMondayOfYear = DateTime(date.year, 1, firstMonday);
    final weekNumber =
        ((date.difference(firstMondayOfYear).inDays) / 7).floor() + 1;

    return weekNumber;
  }
}

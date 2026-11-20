import 'dart:async';

import 'package:app/common/abfall/abfall_provider.dart';
import 'package:app/common/gemeinde_prefs.dart';
import 'package:app/common/kommune.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/graphql/__generated__/kommune.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/__generated__/termine.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/graphql/query_snapshot_store.dart';
import 'package:app/routes/termine/common/map_event_appointments.dart';
import 'package:app/routes/termine/common/model/termin_art_filter_type.dart';
import 'package:app/routes/termine/common/model/termin_list/termin_list.dart';
import 'package:app/routes/termine/common/termine_query_date_range.dart';
import 'package:app/routes/termine/components/veranstaltung/veranstaltungen_filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:graphql/client.dart' show ErrorPolicy, FetchPolicy;

/// StateProvider für den Suchbegriff bei der Termin-Suche.
final terminSearchValueProvider = StateProvider((ref) => '');

/// StateProvider für temporäre Gemeindefilter.
final tempGemeindeProvider = StateProvider<List<String>>((ref) => []);

/// StateProvider für den Filtertyp der Termine.
final terminArtFilterProvider = StateProvider<TerminArtFilterType>(
  (ref) => TerminArtFilterType.alle,
);

/// Notifier, der gefilterte Termine basierend auf verschiedenen Kriterien lädt und Pagination unterstützt.
///
/// Offline empty-cache failures surface as [AsyncError]. Riverpod keeps that
/// state until [reload], [ref.invalidate], or a watched dependency changes —
/// simply re-watching (e.g. tab switch in an IndexedStack) does **not** retry.
class FilteredTermineNotifier extends AsyncNotifier<TermineList> {
  /// Identifies the latest request so obsolete background refreshes are ignored.
  var _requestGeneration = 0;

  @override
  Future<TermineList> build() async {
    ref
      ..watch(terminSearchValueProvider)
      ..watch(terminArtFilterProvider)
      ..watch(tempGemeindeProvider)
      ..watch(gemeindeFilterProvider)
      ..watch(abfallConfigProvider);

    final kommune = await ref.watch(kommuneProvider.future);
    final generation = ++_requestGeneration;
    return _fetch(
      page: 1,
      kommuneData: kommune,
      useSnapshot: true,
      generation: generation,
    );
  }

  /// Re-runs the initial fetch (pull-to-refresh / retry / tab re-activation).
  Future<void> reload() async {
    final generation = ++_requestGeneration;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final kommune = await ref.read(kommuneProvider.future);
      return _fetch(
        page: 1,
        kommuneData: kommune,
        useSnapshot: false,
        generation: generation,
      );
    });
    if (state case AsyncError(:final error, :final stackTrace)) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<TermineList> _fetch({
    required int page,
    required Fragment_Kommune kommuneData,
    required bool useSnapshot,
    required int generation,
  }) async {
    final client = ref.read(graphqlClientProvider);
    final kommune = kommuneData;
    final prefs = ref.read(sharedPreferencesProvider);
    final abfallFilter = ref.read(abfallConfigProvider).filter;
    final terminArt = ref.read(terminArtFilterProvider);
    final kategorien = prefs.getStringList(selectedCategoriesPrefsKey) ?? [];
    final gemeinden = ref.read(gemeindeFilterProvider).currentGemeindePrefs;
    final tempGemeinden = ref.read(tempGemeindeProvider);
    final standortId = abfallFilter.standort;
    final fraktionen =
        abfallFilter.fraktionen
            ?.split(',')
            .where((s) => s.isNotEmpty)
            .toList() ??
        [];
    final selectedDateRange =
        prefs.getStringList(selectedDateRangePrefsKey) ?? [];
    final dateTimeRange = selectedDateRange.isNotEmpty
        ? DateTimeRange(
            start: DateTime.parse(selectedDateRange[0]),
            end: DateTime.parse(selectedDateRange[1]),
          )
        : null;

    final search = ref.read(terminSearchValueProvider);
    final now = DateTime.now();
    final defaultDateRange = defaultTermineQueryDateRange(now);

    final vonFilter = dateTimeRange?.start.toUtc() ?? defaultDateRange.from;

    final bisFilter = dateTimeRange?.end.toUtc() ?? defaultDateRange.until;

    final variables = Variables_Query_TermineList(
      standortId: standortId ?? '',
      kommuneIdBereichA: kommune.bereichAId,
      von: vonFilter,
      bis: bisFilter,
      includeAbfallkalender: [
        TerminArtFilterType.alle,
        TerminArtFilterType.abfall,
      ].contains(terminArt),
      includeVeranstaltungen: [
        TerminArtFilterType.alle,
        TerminArtFilterType.veranstaltung,
      ].contains(terminArt),
      search: search,
      categoryIds: kategorien.isEmpty ? null : kategorien,
      untereinheiten: tempGemeinden.isNotEmpty
          ? tempGemeinden
          : gemeinden.isNotEmpty
          ? gemeinden
          : null,
      abfallkalenderFilter: Input_TerminFilterInput(
        fraktion: Input_StringOperationFilterInput(icontains: search),
      ),
      page: page,
      limit: 50,
      vonString: vonFilter.toIso8601String(),
      bisString: bisFilter.toIso8601String(),
      kommuneString: kommune.bereichBId,
    );
    final snapshotKey = createQuerySnapshotKey(
      namespace: 'termine',
      variables: variables.toJson(),
    );
    final snapshot = useSnapshot
        ? readQuerySnapshot(snapshotKey, Query_TermineList.fromJson)
        : null;

    if (snapshot != null) {
      if (page == 1) {
        unawaited(
          Future<void>(() async {
            await _refreshSnapshot(
              kommuneData: kommuneData,
              generation: generation,
            );
          }),
        );
      }
      return _createTermineList(
        data: snapshot,
        page: page,
        dateTimeRange: dateTimeRange,
        fraktionen: fraktionen,
      );
    }

    final items = await client.query_TermineList(
      Options_Query_TermineList(
        fetchPolicy: FetchPolicy.networkOnly,
        errorPolicy: ErrorPolicy.all,
        variables: variables,
      ),
    );

    debugPrint(
      'TermineProvider: Query finished. hasException: ${items.hasException}, '
      'hasData: ${items.parsedData != null}',
    );
    if (items.hasException && items.parsedData == null) {
      if (useSnapshot) {
        final cachedItems = await client.query_TermineList(
          Options_Query_TermineList(
            fetchPolicy: FetchPolicy.cacheOnly,
            errorPolicy: ErrorPolicy.all,
            variables: variables,
          ),
        );
        if (cachedItems.parsedData case final cachedData?) {
          await writeQuerySnapshot(snapshotKey, cachedData.toJson());
          return _createTermineList(
            data: cachedData,
            page: page,
            dateTimeRange: dateTimeRange,
            fraktionen: fraktionen,
          );
        }
      }
      debugPrint('TermineProvider ERROR: ${items.exception}');
      throw items.exception!;
    }

    final data = items.parsedData;
    if (data == null) {
      return TermineList(
        veranstaltungen: [],
        abfallkalenderTermine: [],
        currentPage: page,
      );
    }

    await writeQuerySnapshot(snapshotKey, data.toJson());

    return _createTermineList(
      data: data,
      page: page,
      dateTimeRange: dateTimeRange,
      fraktionen: fraktionen,
    );
  }

  /// Refreshes a displayed snapshot from the network when it is still current.
  Future<void> _refreshSnapshot({
    required Fragment_Kommune kommuneData,
    required int generation,
  }) async {
    try {
      final refreshed = await _fetch(
        page: 1,
        kommuneData: kommuneData,
        useSnapshot: false,
        generation: generation,
      );
      if (ref.mounted && generation == _requestGeneration) {
        state = AsyncData(refreshed);
      }
    } catch (_) {}
  }

  /// Maps a cached or network query response to the appointment view model.
  TermineList _createTermineList({
    required Query_TermineList data,
    required int page,
    required DateTimeRange? dateTimeRange,
    required List<String> fraktionen,
  }) {
    final veranstaltungskalenderDocs =
        data.veranstaltungsTermine?.docs?.toList().nonNulls ?? [];

    final hasNextPage = data.veranstaltungsTermine?.hasNextPage ?? false;

    final abfallkalender = data.kommune?.abfallkalender ?? [];

    final collapsedVeranstaltungsTermine = mapEventAppointments(
      veranstaltungskalenderDocs,
    );

    final filteredByDateRangeTermine = dateTimeRange == null
        ? collapsedVeranstaltungsTermine
        : collapsedVeranstaltungsTermine.where((collapse) {
            return collapse.start.isAfter(dateTimeRange.start) &&
                collapse.start.isBefore(dateTimeRange.end);
          }).toList();

    final filteredAbfallTermine = abfallkalender.where((termin) {
      if (fraktionen.isEmpty) return true;
      if (fraktionen.contains(termin.fraktionId)) {
        return true;
      }
      return false;
    }).toList();

    return TermineList(
      veranstaltungen: filteredByDateRangeTermine,
      abfallkalenderTermine: filteredAbfallTermine,
      currentPage: page,
      hasNextPage: hasNextPage,
    );
  }

  Future<void> fetchMore() async {
    final current = state.value;
    if (current == null || !current.hasNextPage || state.isLoading) return;

    final currentKommune = await ref.read(kommuneProvider.future);
    final generation = ++_requestGeneration;
    state = const AsyncLoading<TermineList>();

    state = await AsyncValue.guard(() async {
      final nextPage = await _fetch(
        page: current.currentPage + 1,
        kommuneData: currentKommune,
        useSnapshot: true,
        generation: generation,
      );
      return current.copyWith(
        veranstaltungen: mergeEventAppointments([
          ...current.veranstaltungen,
          ...nextPage.veranstaltungen,
        ]),
        currentPage: nextPage.currentPage,
        hasNextPage: nextPage.hasNextPage,
      );
    });
  }
}

/// Provider für die gefilterten Termine.
final filteredTermineProvider =
    AsyncNotifierProvider<FilteredTermineNotifier, TermineList>(
      FilteredTermineNotifier.new,
    );

import 'dart:async';

import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/pagination/load_all_offset_pages.dart';
import 'package:app/common/pagination/offset_page.dart';
import 'package:app/graphql/__generated__/schritte.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/graphql/query_snapshot_store.dart';
import 'package:app/routes/antraege/common/antrag_select.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql/client.dart' show ErrorPolicy, FetchPolicy;

/// Page size per request when loading a municipality's processes/services.
/// Matches the backend offset paging's `MaxPageSize`.
const _prozesseUndLeistungenPageSize = 100;

/// Holds a municipality's complete processes/services and their groups.
@immutable
class AntragSelectionList {
  const AntragSelectionList({required this.items, required this.groups});

  final List<ProzessOrLeistung> items;
  final List<Query_ErsteSchritte_kommune_prozessGroups> groups;
}

/// Loads a municipality's available processes and services.
///
/// This selection list must always be complete rather than paged in the UI
/// (unlike e.g. the news list), so [build] keeps fetching pages from the
/// backend until none are left.
class AntragSelectionNotifier extends AsyncNotifier<AntragSelectionList> {
  /// Identifies the latest request so obsolete background refreshes are ignored.
  var _requestGeneration = 0;

  @override
  Future<AntragSelectionList> build() async {
    final kommuneId = ref.watch(appConfigProvider).kommuneId;
    final generation = ++_requestGeneration;
    final snapshot = _readSelectionSnapshot(kommuneId);
    if (snapshot != null) {
      unawaited(
        Future<void>(() async {
          await _refreshSnapshot(kommuneId: kommuneId, generation: generation);
        }),
      );
      return snapshot;
    }

    return _loadSelectionWithFallback(kommuneId);
  }

  /// Refreshes the service list from the network and retains existing data on failure.
  Future<void> reload() async {
    final generation = ++_requestGeneration;
    final previous = state.value;
    try {
      final kommuneId = ref.read(appConfigProvider).kommuneId;
      final refreshed = await _loadSelection(
        kommuneId: kommuneId,
        fetchPolicy: FetchPolicy.networkOnly,
      );
      if (generation == _requestGeneration) state = AsyncData(refreshed);
    } catch (error, stackTrace) {
      if (previous == null) {
        debugPrint('Service selection reload failed: $error\n$stackTrace');
        state = AsyncError(error, stackTrace);
      }
    }
  }

  /// Loads services from the network and falls back to the normalized cache.
  Future<AntragSelectionList> _loadSelectionWithFallback(
    String kommuneId,
  ) async {
    try {
      return await _loadSelection(
        kommuneId: kommuneId,
        fetchPolicy: FetchPolicy.networkOnly,
      );
    } catch (error, stackTrace) {
      try {
        return await _loadSelection(
          kommuneId: kommuneId,
          fetchPolicy: FetchPolicy.cacheOnly,
        );
      } catch (_) {
        debugPrint('Service selection failed: $error\n$stackTrace');
        Error.throwWithStackTrace(error, stackTrace);
      }
    }
  }

  /// Refreshes a displayed snapshot from the network when it is still current.
  Future<void> _refreshSnapshot({
    required String kommuneId,
    required int generation,
  }) async {
    try {
      final refreshed = await _loadSelection(
        kommuneId: kommuneId,
        fetchPolicy: FetchPolicy.networkOnly,
      );
      if (ref.mounted && generation == _requestGeneration) {
        state = AsyncData(refreshed);
      }
    } catch (_) {}
  }

  /// Loads and combines all pages using the requested cache policy.
  Future<AntragSelectionList> _loadSelection({
    required String kommuneId,
    required FetchPolicy fetchPolicy,
  }) async {
    var groups = <Query_ErsteSchritte_kommune_prozessGroups>[];

    final items = await loadAllOffsetPages(
      pageSize: _prozesseUndLeistungenPageSize,
      loadPage: ({required skip, required take}) async {
        final page = await _fetchPage(
          kommuneId: kommuneId,
          skip: skip,
          take: take,
          fetchPolicy: fetchPolicy,
        );
        groups = page.groups;
        return page.page;
      },
    );

    return AntragSelectionList(items: items, groups: groups);
  }

  /// Loads one backend page of processes and services.
  Future<
    ({
      OffsetPage<ProzessOrLeistung> page,
      List<Query_ErsteSchritte_kommune_prozessGroups> groups,
    })
  >
  _fetchPage({
    required String kommuneId,
    required int skip,
    required int take,
    required FetchPolicy fetchPolicy,
  }) async {
    final client = ref.read(graphqlClientProvider);
    final result = await client.query_ErsteSchritte(
      Options_Query_ErsteSchritte(
        fetchPolicy: fetchPolicy,
        errorPolicy: ErrorPolicy.all,
        variables: Variables_Query_ErsteSchritte(
          kommuneId: kommuneId,
          skip: skip,
          take: take,
        ),
      ),
    );

    if (result.hasException && result.parsedData == null) {
      throw result.exception!;
    }

    final data = result.parsedData;
    if (data != null) {
      final snapshotKey = createQuerySnapshotKey(
        namespace: 'service',
        variables: Variables_Query_ErsteSchritte(
          kommuneId: kommuneId,
          skip: skip,
          take: take,
        ).toJson(),
      );
      await writeQuerySnapshot(snapshotKey, data.toJson());
    }

    final kommune = data?.kommune;
    final prozesseUndLeistungen = kommune?.prozesseUndLeistungen;

    return (
      page: OffsetPage(
        items: prozesseUndLeistungen?.items?.toList() ?? <ProzessOrLeistung>[],
        hasNextPage: prozesseUndLeistungen?.pageInfo.hasNextPage ?? false,
      ),
      groups: kommune?.prozessGroups.toList() ?? [],
    );
  }

  /// Reads every cached service page or returns null for an incomplete snapshot.
  AntragSelectionList? _readSelectionSnapshot(String kommuneId) {
    var skip = 0;
    final items = <ProzessOrLeistung>[];
    var groups = <Query_ErsteSchritte_kommune_prozessGroups>[];

    while (true) {
      final variables = Variables_Query_ErsteSchritte(
        kommuneId: kommuneId,
        skip: skip,
        take: _prozesseUndLeistungenPageSize,
      );
      final snapshotKey = createQuerySnapshotKey(
        namespace: 'service',
        variables: variables.toJson(),
      );
      final snapshot = readQuerySnapshot(
        snapshotKey,
        Query_ErsteSchritte.fromJson,
      );
      if (snapshot == null) return null;

      final kommune = snapshot.kommune;
      final page = kommune.prozesseUndLeistungen;
      final pageItems = page?.items?.toList() ?? <ProzessOrLeistung>[];
      items.addAll(pageItems);
      groups = kommune.prozessGroups.toList();

      if (page?.pageInfo.hasNextPage != true) {
        return AntragSelectionList(items: items, groups: groups);
      }
      if (pageItems.isEmpty) return null;
      skip += _prozesseUndLeistungenPageSize;
    }
  }
}

/// Provider exposing a municipality's available processes and services.
final antragSelectionProvider =
    AsyncNotifierProvider<AntragSelectionNotifier, AntragSelectionList>(
      AntragSelectionNotifier.new,
    );

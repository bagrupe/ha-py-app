import 'package:app/graphql/__generated__/schema.graphql.dart'
    show possibleTypesMap;
import 'package:app/graphql/graphql_cache_lifecycle_observer.dart';
import 'package:app/graphql/query_snapshot_store.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:normalize/normalize.dart' show TypePolicy;
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences key for the last GraphQL Hive cache bulk-clear.
const lastGraphQLCacheClearPrefsKey = 'last_graphql_cache_clear_v2';

/// Versioned Hive box used by the persistent application GraphQL cache.
const graphQLCacheBoxName = 'kommunalAppGraphQLCacheV2';

/// Cache TTL before a global Hive bulk-clear on startup.
const graphQLCacheTtl = Duration(days: 7);

/// Shared app GraphQL cache.
///
/// Replaced by [initializeGraphQLCache] during startup with a [HiveStore]-backed
/// instance. Tests and Widgetbook may keep the default in-memory store.
GraphQLCache cache = GraphQLCache(
  possibleTypes: possibleTypesMap,
  typePolicies: _typePolicies,
);

/// `VeranstaltungsTermin` rows are per-query aggregates whose `id` is the
/// Veranstaltung id, shared by all its dates; normalizing them merges rows.
const _typePolicies = {'VeranstaltungsTermin': TypePolicy(keyFields: {})};

HiveStore? _persistentGraphQLStore;
GraphQLCacheLifecycleObserver? _cacheLifecycleObserver;

/// Whether the persisted GraphQL cache should be cleared for [now].
///
/// A missing timestamp bootstraps an existing installation without deleting
/// data. Once initialized, the cache is cleared after [graphQLCacheTtl].
bool shouldClearGraphQLCache({
  required DateTime? lastClear,
  required DateTime now,
}) {
  if (lastClear == null) return false;
  return now.difference(lastClear) >= graphQLCacheTtl;
}

/// Clears the Hive GraphQL box when the TTL has expired, then records [now].
///
/// [clearStore] is injectable for unit tests; production uses [HiveStore.reset].
Future<bool> clearGraphQLCacheIfStale(
  SharedPreferences prefs, {
  required Future<void> Function() clearStore,
  DateTime Function() clock = DateTime.now,
}) async {
  final raw = prefs.getString(lastGraphQLCacheClearPrefsKey);
  final lastClear = raw == null ? null : DateTime.tryParse(raw);
  final now = clock();

  if (lastClear == null) {
    await prefs.setString(lastGraphQLCacheClearPrefsKey, now.toIso8601String());
    return false;
  }

  if (!shouldClearGraphQLCache(lastClear: lastClear, now: now)) {
    return false;
  }

  await clearStore();
  await prefs.setString(lastGraphQLCacheClearPrefsKey, now.toIso8601String());
  return true;
}

/// Flushes all pending persistent GraphQL cache writes.
Future<void> flushGraphQLCache() async {
  await Future.wait([
    if (_persistentGraphQLStore case final store?) store.box.flush(),
    flushQuerySnapshots(),
  ]);
}

Future<void> clearPersistentGraphQLCache() async {
  await Future.wait([
    if (_persistentGraphQLStore case final store?) store.reset(),
    clearQuerySnapshots(),
  ]);
}

/// Initializes Hive, applies the 7-day TTL bulk-clear, and installs [HiveStore].
///
/// Must run once during phase-1 startup before the main [GraphQLClient] is built.
Future<GraphQLCache> initializeGraphQLCache(SharedPreferences prefs) async {
  await initHiveForFlutter(
    boxes: const [graphQLCacheBoxName, querySnapshotBoxName],
  );
  final store = await HiveStore.open(boxName: graphQLCacheBoxName);
  _persistentGraphQLStore = store;
  await initializeQuerySnapshotStore();
  await clearGraphQLCacheIfStale(
    prefs,
    clearStore: () async {
      await Future.wait([store.reset(), clearQuerySnapshots()]);
    },
  );
  _registerCacheLifecycleObserver();
  return cache = GraphQLCache(
    store: store,
    possibleTypes: possibleTypesMap,
    typePolicies: _typePolicies,
  );
}

void _registerCacheLifecycleObserver() {
  final previousObserver = _cacheLifecycleObserver;
  if (previousObserver != null) {
    WidgetsBinding.instance.removeObserver(previousObserver);
  }

  final observer = GraphQLCacheLifecycleObserver(flush: flushGraphQLCache);
  _cacheLifecycleObserver = observer;
  WidgetsBinding.instance.addObserver(observer);
}

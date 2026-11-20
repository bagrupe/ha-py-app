import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';

/// Hive box used for complete query response snapshots.
const querySnapshotBoxName = 'kommunalAppQuerySnapshotsV1';

/// Active query snapshot store, replaced with Hive during application startup.
Store _querySnapshotStore = InMemoryStore();

/// Creates a stable snapshot key from a namespace and GraphQL variables.
String createQuerySnapshotKey({
  required String namespace,
  required Map<String, dynamic> variables,
}) {
  final canonicalPayload = jsonEncode({
    'namespace': namespace,
    'variables': _canonicalizeJson(variables),
  });
  return 'query:${sha256.convert(utf8.encode(canonicalPayload))}';
}

/// Reads and decodes a query snapshot, removing invalid entries.
T? readQuerySnapshot<T>(
  String key,
  T Function(Map<String, dynamic> data) decode,
) {
  try {
    final data = _querySnapshotStore.get(key);
    if (data == null) return null;
    return decode(data);
  } catch (error, stackTrace) {
    debugPrint('Query snapshot read failed for $key: $error\n$stackTrace');
    try {
      _querySnapshotStore.delete(key);
    } catch (_) {}
    return null;
  }
}

/// Persists a query response without blocking network data on cache failures.
Future<void> writeQuerySnapshot(String key, Map<String, dynamic> data) async {
  try {
    final store = _querySnapshotStore;
    if (store is HiveStore) {
      await store.box.put(key, data);
      return;
    }
    store.put(key, data);
  } catch (error, stackTrace) {
    debugPrint('Query snapshot write failed for $key: $error\n$stackTrace');
  }
}

/// Initializes the persistent Hive-backed query snapshot store.
Future<void> initializeQuerySnapshotStore() async {
  _querySnapshotStore = await HiveStore.open(boxName: querySnapshotBoxName);
}

/// Clears all stored query snapshots.
Future<void> clearQuerySnapshots() async {
  final store = _querySnapshotStore;
  if (store is HiveStore) {
    await store.reset();
    return;
  }
  store.reset();
}

/// Flushes pending Hive query snapshot writes.
Future<void> flushQuerySnapshots() async {
  final store = _querySnapshotStore;
  if (store is HiveStore) {
    await store.box.flush();
  }
}

/// Replaces the query snapshot store with an empty in-memory store for tests.
@visibleForTesting
void useInMemoryQuerySnapshotStore() {
  _querySnapshotStore = InMemoryStore();
}

/// Canonicalizes JSON maps so their encoded cache keys remain stable.
dynamic _canonicalizeJson(dynamic value) {
  if (value is Map) {
    final keys = value.keys.map((key) => key.toString()).toList()..sort();
    return <String, dynamic>{
      for (final key in keys) key: _canonicalizeJson(value[key]),
    };
  }
  if (value is List) {
    return value.map(_canonicalizeJson).toList();
  }
  return value;
}

import 'dart:async';

import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/fonts/fonts.dart';
import 'package:app/graphql/__generated__/kommune.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/graphql/query_snapshot_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql/client.dart'
    show FetchPolicy, GraphQLClient, OperationException;
import 'package:sentry_flutter/sentry_flutter.dart';

/// Displays municipality snapshots immediately and refreshes them from the network.
class KommuneNotifier extends AsyncNotifier<Fragment_Kommune> {
  /// Identifies the active configuration and rejects obsolete responses.
  var _generation = 0;

  /// Coalesces refreshes while a request is already running.
  Future<void>? _refresh;

  @override
  Future<Fragment_Kommune> build() async {
    final config = ref.watch(appConfigProvider);
    final client = ref.watch(graphqlClientProvider);
    final generation = ++_generation;
    _refresh = null;
    final snapshot = readQuerySnapshot(
      _snapshotKey(config),
      Fragment_Kommune.fromJson,
    );
    if (snapshot != null) {
      _registerFonts(snapshot, config.fontsBaseUrl);
      unawaited(
        Future<void>(() async {
          if (ref.mounted && generation == _generation) await reload();
        }),
      );
      return snapshot;
    }
    return _load(config, client);
  }

  /// Refreshes without hiding existing data or surfacing offline refresh errors.
  Future<void> reload() {
    final generation = _generation;
    return _refresh ??= _reload().whenComplete(() {
      if (generation == _generation) _refresh = null;
    });
  }

  /// Updates the visible municipality only while its configuration remains current.
  Future<void> _reload() async {
    final generation = _generation;
    final config = ref.read(appConfigProvider);
    final client = ref.read(graphqlClientProvider);
    try {
      final kommune = await _load(config, client);
      if (ref.mounted && generation == _generation) {
        state = AsyncData(kommune);
      }
    } catch (error, stackTrace) {
      if (error is! OperationException || error.linkException == null) {
        unawaited(Sentry.captureException(error, stackTrace: stackTrace));
      }
      if (ref.mounted && generation == _generation && state.value == null) {
        state = AsyncError(error, stackTrace);
      }
    }
  }

  /// Fetches authoritative data and persists the successful response.
  Future<Fragment_Kommune> _load(AppConfig config, GraphQLClient client) async {
    final result = await client.query_Kommune(
      Options_Query_Kommune(
        variables: Variables_Query_Kommune(kommuneId: config.kommuneId),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (result.hasException) throw result.exception!;
    final kommune = result.parsedData?.kommune;
    if (kommune == null) throw StateError('Municipality response has no data');
    await writeQuerySnapshot(_snapshotKey(config), kommune.toJson());
    _registerFonts(kommune, config.fontsBaseUrl);
    return kommune;
  }

  /// Uses the existing municipality snapshot namespace for installed apps.
  String _snapshotKey(AppConfig config) => createQuerySnapshotKey(
    namespace: 'kommune',
    variables: Variables_Query_Kommune(kommuneId: config.kommuneId).toJson(),
  );

  /// Registers fonts from cached and updated municipality designs.
  void _registerFonts(Fragment_Kommune kommune, String baseUrl) {
    final fonts = kommune.design?.fonts;
    final headings = fonts?.headings;
    final body = fonts?.body;
    if (headings != null) registerFont(headings.name, baseUrl);
    if (body != null) registerFont(body.name, baseUrl);
  }
}

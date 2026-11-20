import 'dart:async';

import 'package:app/common/location_service.dart';
import 'package:app/graphql/__generated__/wettermesspunkte.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql/client.dart' show ErrorPolicy, FetchPolicy;

/// Successful weather payload plus the device position used for station selection.
class WeatherState {
  const WeatherState({required this.data, this.lastKnownPosition});

  final Query_Wettermesspunkte data;
  final Position? lastKnownPosition;
}

/// Loads wettermesspunkte for a kommune, refreshes hourly, and keeps last good data
/// when a later fetch fails while the GraphQL cache / prior state still has data.
class WeatherNotifier extends AsyncNotifier<WeatherState> {
  WeatherNotifier(this.kommuneId);

  final String kommuneId;

  @override
  Future<WeatherState> build() async {
    final timer = Timer.periodic(const Duration(hours: 1), (_) {
      unawaited(_refreshQuietly());
    });
    ref.onDispose(timer.cancel);

    return _fetch();
  }

  /// Pull-to-refresh / retry entry point. Prefer [ref.invalidate] from UI;
  /// this keeps previous [AsyncData] visible while a network-only reload runs.
  Future<void> refresh() =>
      _refreshQuietly(fetchPolicy: FetchPolicy.networkOnly);

  Future<void> _refreshQuietly({
    FetchPolicy fetchPolicy = FetchPolicy.cacheAndNetwork,
  }) async {
    final previous = state.value;
    try {
      state = AsyncData(await _fetch(fetchPolicy: fetchPolicy));
    } catch (error, stackTrace) {
      if (previous == null) {
        state = AsyncError(error, stackTrace);
      }
    }
  }

  Future<WeatherState> _fetch({
    FetchPolicy fetchPolicy = FetchPolicy.cacheAndNetwork,
  }) async {
    final graphQlClient = ref.read(graphqlClientProvider);
    final response = await graphQlClient.query_Wettermesspunkte(
      Options_Query_Wettermesspunkte(
        // cacheAndNetwork: return Hive data immediately when present; network
        // refresh runs in the background and writes to cache.
        // ErrorPolicy.all keeps partial payloads usable alongside errors.
        fetchPolicy: fetchPolicy,
        errorPolicy: ErrorPolicy.all,
        variables: Variables_Query_Wettermesspunkte(kommuneId: kommuneId),
      ),
    );
    final lastKnownPosition = await LocationService.getLastKnownPosition();
    final data = response.parsedData;

    if (data == null) {
      if (response.hasException) {
        throw response.exception ?? Exception('Weather fetch failed');
      }
      throw Exception('No weather data');
    }

    return WeatherState(data: data, lastKnownPosition: lastKnownPosition);
  }
}

/// Weather data for a given kommune (`bereichBId`).
final weatherProvider =
    AsyncNotifierProvider.family<WeatherNotifier, WeatherState, String>(
      WeatherNotifier.new,
    );

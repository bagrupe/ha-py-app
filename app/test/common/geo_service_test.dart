import 'dart:async';

import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/geo_service.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:latlong2/latlong.dart';

class _FixedAppConfigNotifier extends AppConfigNotifier {
  @override
  AppConfig build() =>
      const AppConfig(backendUrl: 'http://localhost', kommuneId: 'kommune-1');
}

void main() {
  late int networkCalls;
  late Completer<void> releaseResponse;
  late ProviderContainer container;

  Response respond() => const Response(
    response: {},
    data: {
      '__typename': 'Query',
      'kommune': {
        '__typename': 'Kommune',
        'isPointInGeoflaeche': {
          '__typename': 'IsInside',
          'isInside': true,
          'message': null,
        },
      },
    },
  );

  setUp(() {
    networkCalls = 0;
    releaseResponse = Completer<void>();

    final link = Link.function((request, [forward]) {
      networkCalls++;
      return Stream.fromFuture(releaseResponse.future.then((_) => respond()));
    });

    container = ProviderContainer(
      overrides: [
        graphqlClientProvider.overrideWithValue(
          GraphQLClient(
            link: link,
            cache: GraphQLCache(store: InMemoryStore()),
          ),
        ),
        appConfigProvider.overrideWith(_FixedAppConfigNotifier.new),
      ],
    );
    addTearDown(container.dispose);
  });

  test(
    'merges concurrent identical requests into a single network call',
    () async {
      final geoService = container.read(geoServiceProvider);
      const position = LatLng(52.1, 9.36);

      final first = geoService.isPointInGeoflaeche('Hameln', position);
      final second = geoService.isPointInGeoflaeche('Hameln', position);
      releaseResponse.complete();

      expect(await first, isTrue);
      expect(await second, isTrue);
      expect(networkCalls, 1);
    },
  );

  test(
    'does not merge requests for a different Geofläche or position',
    () async {
      final geoService = container.read(geoServiceProvider);

      final hameln = geoService.isPointInGeoflaeche(
        'Hameln',
        const LatLng(52.1, 9.36),
      );
      final otherName = geoService.isPointInGeoflaeche(
        'Aerzen',
        const LatLng(52.1, 9.36),
      );
      final otherPosition = geoService.isPointInGeoflaeche(
        'Hameln',
        const LatLng(52.2, 9.36),
      );
      releaseResponse.complete();
      await Future.wait([hameln, otherName, otherPosition]);

      expect(networkCalls, 3);
    },
  );

  test('answers a later identical request from the cache', () async {
    final geoService = container.read(geoServiceProvider);
    const position = LatLng(52.1, 9.36);

    releaseResponse.complete();
    await geoService.isPointInGeoflaeche('Hameln', position);
    await geoService.isPointInGeoflaeche('Hameln', position);

    expect(networkCalls, 1);
  });
}

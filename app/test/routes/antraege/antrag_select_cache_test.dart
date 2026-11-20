import 'package:app/common/app_config/app_config.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/graphql/query_snapshot_store.dart';
import 'package:app/routes/antraege/antrag_select_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';

/// Supplies a deterministic municipality configuration for service cache tests.
class _FixedAppConfigNotifier extends AppConfigNotifier {
  @override
  AppConfig build() =>
      const AppConfig(backendUrl: 'http://localhost', kommuneId: 'kommune-1');
}

/// Verifies persistent GraphQL cache handling for the service selection.
void main() {
  late bool isOffline;
  late String serviceName;
  late int networkCalls;
  late ProviderContainer container;
  late ProviderContainer Function() createContainer;

  setUp(() {
    useInMemoryQuerySnapshotStore();
    isOffline = false;
    serviceName = 'Meldebescheinigung';
    networkCalls = 0;

    final link = Link.function((request, [forward]) {
      networkCalls++;
      if (isOffline) {
        return Stream.error(
          const ServerException(originalException: 'offline'),
        );
      }
      return Stream.value(
        Response(
          response: const {},
          data: {
            '__typename': 'Query',
            'kommune': {
              '__typename': 'Kommune',
              'id': 'kommune-1',
              'name': 'Testkommune',
              'prozessGroups': const [
                {
                  '__typename': 'ProzessGroup',
                  'id': 'group-1',
                  'name': 'Allgemein',
                },
              ],
              'prozesseUndLeistungen': {
                '__typename': 'ProzesseUndLeistungenCollectionSegment',
                'items': [
                  {
                    '__typename': 'ServicePortalLink',
                    'id': 'service-1',
                    'name': serviceName,
                    'url': 'https://service.example',
                    'group': const {
                      '__typename': 'ProzessGroup',
                      'id': 'group-1',
                      'name': 'Allgemein',
                    },
                  },
                ],
                'pageInfo': const {
                  '__typename': 'CollectionSegmentInfo',
                  'hasNextPage': false,
                },
              },
            },
          },
        ),
      );
    });

    createContainer = () {
      return ProviderContainer(
        retry: (_, _) => null,
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
    };
    container = createContainer();
    addTearDown(() => container.dispose());
  });

  test('returns the cached service list when the network is offline', () async {
    final online = await container.read(antragSelectionProvider.future);
    expect(online.items.single.name, 'Meldebescheinigung');

    isOffline = true;
    container.dispose();
    container = createContainer();

    final offline = await container.read(antragSelectionProvider.future);
    expect(offline.items.single.name, 'Meldebescheinigung');
    expect(networkCalls, greaterThanOrEqualTo(1));
  });

  test('manual refresh replaces cached data with the network result', () async {
    await container.read(antragSelectionProvider.future);
    serviceName = 'Aktuelle Meldebescheinigung';

    await container.read(antragSelectionProvider.notifier).reload();

    final refreshed = container.read(antragSelectionProvider).requireValue;
    expect(refreshed.items.single.name, 'Aktuelle Meldebescheinigung');
  });

  test('refreshes a displayed snapshot from the network', () async {
    await container.read(antragSelectionProvider.future);
    serviceName = 'Aktuelle Meldebescheinigung';
    container.dispose();
    container = createContainer();

    final cached = await container.read(antragSelectionProvider.future);
    expect(cached.items.single.name, 'Meldebescheinigung');

    await pumpEventQueue();

    final refreshed = container.read(antragSelectionProvider).requireValue;
    expect(refreshed.items.single.name, 'Aktuelle Meldebescheinigung');
  });

  test('reports an error when both network and cache are empty', () async {
    isOffline = true;
    container.dispose();
    container = createContainer();

    await expectLater(
      container.read(antragSelectionProvider.future),
      throwsA(isA<OperationException>()),
    );
  });
}

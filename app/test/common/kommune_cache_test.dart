import 'dart:async';

import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/kommune.dart';
import 'package:app/graphql/__generated__/kommune.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/graphql/query_snapshot_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';

import 'fixtures/kommune_test_app_config_notifier.dart';

/// Creates complete municipality data with distinguishable CMS fields.
Fragment_Kommune municipality(String version, {String id = 'kommune-1'}) =>
    Fragment_Kommune(
      bereichAId: id,
      bereichBId: id,
      name: version,
      analytics: Fragment_KommuneAnalytics(),
      rechtsTexte: Fragment_KommuneRechtstexte(
        impressum: 'https://example.com/$version/legal',
        privacy: 'https://example.com/$version/privacy',
      ),
      defaultPosition: [0, 0],
      abfallkalenderEnabled: false,
      design: Fragment_KommuneDesign(
        logo: Fragment_KommuneDesign_logo(url: '$version-logo'),
        mangelIcon: Fragment_KommuneDesign_mangelIcon(
          id: '$version-defect',
          url: '$version-defect-url',
        ),
        ideenIcon: Fragment_KommuneDesign_ideenIcon(
          id: '$version-idea',
          url: '$version-idea-url',
        ),
        colors: Fragment_KommuneDesignColors(primary: version),
      ),
    );

/// Returns the production snapshot key for a municipality.
String snapshotKey(String id) => createQuerySnapshotKey(
  namespace: 'kommune',
  variables: Variables_Query_Kommune(kommuneId: id).toJson(),
);

/// Verifies stale-while-revalidate behavior independently of the normalized cache.
void main() {
  late ProviderContainer container;
  late int calls;
  late Completer<Response> response;

  setUp(() async {
    useInMemoryQuerySnapshotStore();
    calls = 0;
    response = Completer<Response>();
    await writeQuerySnapshot(
      snapshotKey('kommune-1'),
      municipality('old').toJson(),
    );
    container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        appConfigProvider.overrideWith(KommuneTestAppConfigNotifier.new),
        graphqlClientProvider.overrideWithValue(
          GraphQLClient(
            cache: GraphQLCache(store: InMemoryStore()),
            link: Link.function((request, [forward]) {
              calls++;
              return Stream.fromFuture(response.future);
            }),
          ),
        ),
      ],
    );
    addTearDown(() => container.dispose());
  });

  test(
    'shows the snapshot before the network completes and persists new CMS data',
    () async {
      final cached = await container.read(kommuneProvider.future);
      expect(cached, municipality('old'));
      await pumpEventQueue();
      expect(calls, 1);
      response.complete(
        Response(
          response: const {},
          data: {
            '__typename': 'Query',
            'kommune': municipality('new').toJson(),
          },
        ),
      );
      await pumpEventQueue();
      expect(container.read(kommuneProvider).requireValue, municipality('new'));
      expect(
        readQuerySnapshot(snapshotKey('kommune-1'), Fragment_Kommune.fromJson),
        municipality('new'),
      );
      container.invalidate(kommuneProvider);
      expect(await container.read(kommuneProvider.future), municipality('new'));
      await pumpEventQueue();
    },
  );

  test('keeps snapshot and visible data unchanged when offline', () async {
    await container.read(kommuneProvider.future);
    await pumpEventQueue();
    response.completeError(const ServerException(originalException: 'offline'));
    await pumpEventQueue();
    expect(calls, 1);
    expect(container.read(kommuneProvider).hasError, isFalse);
    expect(container.read(kommuneProvider).requireValue, municipality('old'));
    expect(
      readQuerySnapshot(snapshotKey('kommune-1'), Fragment_Kommune.fromJson),
      municipality('old'),
    );
    await container.read(kommuneProvider.notifier).reload();
    expect(container.read(kommuneProvider).hasError, isFalse);
  });

  test(
    'manual tab refresh retains data and coalesces concurrent requests',
    () async {
      await container.read(kommuneProvider.future);
      await pumpEventQueue();
      response.complete(
        Response(
          response: const {},
          data: {
            '__typename': 'Query',
            'kommune': municipality('new').toJson(),
          },
        ),
      );
      await pumpEventQueue();
      response = Completer<Response>();
      final first = container.read(kommuneProvider.notifier).reload();
      final second = container.read(kommuneProvider.notifier).reload();
      expect(container.read(kommuneProvider).requireValue, municipality('new'));
      await pumpEventQueue();
      expect(calls, 2);
      response.complete(
        Response(
          response: const {},
          data: {
            '__typename': 'Query',
            'kommune': municipality('latest').toJson(),
          },
        ),
      );
      await Future.wait([first, second]);
      expect(
        container.read(kommuneProvider).requireValue,
        municipality('latest'),
      );
    },
  );

  test(
    'persists a late response under its own key without changing the visible municipality',
    () async {
      await container.read(kommuneProvider.future);
      await pumpEventQueue();
      final obsolete = response;
      response = Completer<Response>();
      await writeQuerySnapshot(
        snapshotKey('kommune-2'),
        municipality('second', id: 'kommune-2').toJson(),
      );
      container.read(appConfigProvider.notifier).state = const AppConfig(
        backendUrl: 'http://localhost',
        kommuneId: 'kommune-2',
      );
      expect(
        await container.read(kommuneProvider.future),
        municipality('second', id: 'kommune-2'),
      );
      await pumpEventQueue();
      obsolete.complete(
        Response(
          response: const {},
          data: {
            '__typename': 'Query',
            'kommune': municipality('obsolete').toJson(),
          },
        ),
      );
      await pumpEventQueue();
      expect(container.read(kommuneProvider).requireValue.name, 'second');
      expect(
        readQuerySnapshot(
          snapshotKey('kommune-1'),
          Fragment_Kommune.fromJson,
        )?.name,
        'obsolete',
      );
      response.complete(
        Response(
          response: const {},
          data: {
            '__typename': 'Query',
            'kommune': municipality('current', id: 'kommune-2').toJson(),
          },
        ),
      );
      await pumpEventQueue();
      expect(container.read(kommuneProvider).requireValue.name, 'current');
    },
  );

  test('reports an error without a snapshot when offline', () async {
    await clearQuerySnapshots();
    response.completeError(const ServerException(originalException: 'offline'));
    await expectLater(
      container.read(kommuneProvider.future),
      throwsA(isA<OperationException>()),
    );
  });
}

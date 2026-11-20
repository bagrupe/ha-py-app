import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/kommune.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart'
    show possibleTypesMap;
import 'package:app/graphql/graphql_client.dart';
import 'package:app/graphql/query_snapshot_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';

import 'fixtures/kommune_test_app_config_notifier.dart';
import 'kommune_cache_test.dart' show municipality, snapshotKey;

void seedThinKommuneEntity(GraphQLCache cache, String id) {
  cache.store
    ..put('Kommune:$id', {'id': id, 'name': 'thin', '__typename': 'Kommune'})
    ..put('Query', {
      'kommune({"kommuneId":"$id"})': {r'$ref': 'Kommune:$id'},
    });
}

void main() {
  late ProviderContainer container;

  setUp(() async {
    useInMemoryQuerySnapshotStore();
    await writeQuerySnapshot(
      snapshotKey('kommune-1'),
      municipality('old').toJson(),
    );
    final cache = GraphQLCache(
      store: InMemoryStore(),
      possibleTypes: possibleTypesMap,
    );
    seedThinKommuneEntity(cache, 'kommune-1');
    container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        appConfigProvider.overrideWith(KommuneTestAppConfigNotifier.new),
        graphqlClientProvider.overrideWithValue(
          GraphQLClient(
            cache: cache,
            link: Link.function(
              (request, [forward]) => Stream.value(
                Response(
                  data: {
                    '__typename': 'Query',
                    'kommune': municipality('new').toJson(),
                  },
                  response: const {},
                ),
              ),
            ),
          ),
        ),
      ],
    );
    addTearDown(() => container.dispose());
  });

  test(
    'replaces the snapshot although the GraphQL cache holds a thin Kommune',
    () async {
      expect((await container.read(kommuneProvider.future)).name, 'old');

      await container.read(kommuneProvider.notifier).reload();

      final updated = container.read(kommuneProvider).requireValue;
      expect(updated.name, 'new');
      expect(updated.design?.ideenIcon?.url, 'new-idea-url');
    },
  );
}

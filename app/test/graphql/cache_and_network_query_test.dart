import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gql/language.dart';
import 'package:graphql/client.dart';

/// Validates Attempt A for Chunk 2: one-shot [GraphQLClient.query] with
/// [FetchPolicy.cacheAndNetwork] against a failing network link.
///
/// Documents the graphql 5.x behaviour that Termine's AsyncNotifier relies on:
/// when Hive/cache already has data, [query] returns the eager cache result and
/// does not surface the background network failure on that Future.
void main() {
  late GraphQLClient client;
  late int networkCalls;

  const document = '''
    query Ping {
      __typename
    }
  ''';

  final parsed = parseString(document);

  setUp(() {
    networkCalls = 0;
    final link = Link.function((request, [forward]) {
      networkCalls++;
      return Stream.error(const ServerException(originalException: 'offline'));
    });

    client = GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
      defaultPolicies: DefaultPolicies(
        query: Policies(
          fetch: FetchPolicy.cacheAndNetwork,
          error: ErrorPolicy.all,
        ),
      ),
    );
  });

  test('empty cache + offline → exception and no data', () async {
    final result = await client.query(QueryOptions(document: parsed));

    expect(result.hasException, isTrue);
    expect(result.data, isNull);
    expect(networkCalls, 1);
  });

  test(
    'warm cache + offline → returns cached data without throwing away UI data',
    () async {
      final request = Request(operation: Operation(document: parsed));
      client.cache.writeQuery(request, data: {'__typename': 'Query'});

      final result = await client.query(
        QueryOptions(
          document: parsed,
          fetchPolicy: FetchPolicy.cacheAndNetwork,
          errorPolicy: ErrorPolicy.all,
        ),
      );

      // One-shot query returns the eager cache hit immediately.
      expect(result.data, {'__typename': 'Query'});
      expect(result.source, QueryResultSource.cache);
      // Melder / Termine empty-cache condition must stay false here.
      expect(result.hasException && result.data == null, isFalse);

      // Background network still fires (fire-and-forget for this Future).
      await Future<void>.delayed(Duration.zero);
      expect(networkCalls, greaterThanOrEqualTo(1));
    },
  );
}

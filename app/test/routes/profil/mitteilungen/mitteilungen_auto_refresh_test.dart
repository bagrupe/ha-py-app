import 'package:app/graphql/graphql_client.dart' hide GraphQLProvider;
import 'package:app/routes/profil/mitteilungen/mitteilungen_auto_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gql/language.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  late GraphQLClient client;
  late ObservableQuery<Object?> watched;
  var requests = 0;

  setUp(() {
    requests = 0;
    client = GraphQLClient(
      link: Link.function((request, [forward]) {
        requests++;
        return Stream.value(const Response(data: {'my': null}, response: {}));
      }),
      cache: GraphQLCache(),
      queryRequestTimeout: null,
    );
    watched = client.watchQuery(
      WatchQueryOptions(
        document: parseString('query MyMitteilungen { my }'),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  });

  Future<void> pump(WidgetTester tester, {required bool tabActive}) {
    return tester.pumpWidget(
      ProviderScope(
        overrides: [graphqlClientProvider.overrideWithValue(client)],
        child: MaterialApp(
          home: TickerMode(
            enabled: tabActive,
            child: const MitteilungenAutoRefresh(child: SizedBox()),
          ),
        ),
      ),
    );
  }

  testWidgets('refreshes immediately and then on every interval', (
    tester,
  ) async {
    await tester.runAsync(() async {
      watched.fetchResults();
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    final before = requests;

    await pump(tester, tabActive: true);
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    expect(requests, before + 1);

    await tester.pump(mitteilungenRefreshInterval);
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    expect(requests, before + 2);

    await tester.pumpWidget(const SizedBox());
    watched.close();
  });

  testWidgets('does not refresh while the tab is inactive', (tester) async {
    await tester.runAsync(() async {
      watched.fetchResults();
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    final before = requests;

    await pump(tester, tabActive: false);
    await tester.pump(mitteilungenRefreshInterval * 3);
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    expect(requests, before);

    await tester.pumpWidget(const SizedBox());
    watched.close();
  });
}

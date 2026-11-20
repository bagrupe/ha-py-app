import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/auth/auth.dart';
import 'package:app/common/auth/mitteilungen_provider.dart';
import 'package:app/common/volunteer_database/volunteer_database_enabled_notifier.dart';
import 'package:app/graphql/graphql_client.dart' hide GraphQLProvider;
import 'package:app/routes/karte/ideen/idee_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _FixedAppConfigNotifier extends AppConfigNotifier {
  @override
  AppConfig build() =>
      const AppConfig(backendUrl: 'http://localhost', kommuneId: 'kommune-1');
}

class _NoVolunteerDbNotifier extends VolunteerDatabaseEnabledNotifier {
  @override
  bool build() => false;
}

class _NoMitteilungenNotifier extends MitteilungenCountNotifier {
  @override
  int build() => 0;
}

const _idee = {
  '__typename': 'Query',
  'kommune': {
    '__typename': 'Kommune',
    'id': 'kommune-1',
    'ideeAusfuehrung': {
      '__typename': 'Ausfuehrung',
      'id': 'idee-1',
      'userId': 'anderer-nutzer',
      'adresse': null,
      'beschreibung': null,
      'title': null,
      'bilder': null,
      'status': 'BEARBEITUNG_DURCH_KOMMUNE',
      'prozessVersion': {
        '__typename': 'ProzessVersion',
        'id': 'pv-1',
        'prozess': {
          '__typename': 'Prozess',
          'id': 'p-1',
          'name': 'Ideenmelder',
        },
      },
      'aktuellerNutzerFolgt': false,
      'historie': <dynamic>[],
    },
  },
};

Future<void> _pump(
  WidgetTester tester,
  Stream<Response> Function() mutation,
) async {
  final graphQLClient = GraphQLClient(
    link: Link.function((request, [forward]) {
      final isMutation = request.operation.document.definitions
          .whereType<OperationDefinitionNode>()
          .any((d) => d.type == OperationType.mutation);
      return isMutation
          ? mutation()
          : Stream.value(const Response(data: _idee, response: {}));
    }),
    cache: GraphQLCache(),
    queryRequestTimeout: null,
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWith(_FixedAppConfigNotifier.new),
        authProvider.overrideWithValue(
          const AuthState(null, null, null, 'buerger-1'),
        ),
        graphqlClientProvider.overrideWithValue(graphQLClient),
        volunteerDatabaseEnabledProvider.overrideWith(
          _NoVolunteerDbNotifier.new,
        ),
        mitteilungenCountNotifierProvider.overrideWith(
          _NoMitteilungenNotifier.new,
        ),
      ],
      child: GraphQLProvider(
        client: ValueNotifier(graphQLClient),
        child: const MaterialApp(home: IdeeDetailPage(id: 'idee-1')),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();

  final button = find.text('application.melder.ideas.follow');
  await tester.ensureVisible(button);
  await tester.tap(button);
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<void> _unmountAndFlushPollTimer(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 15));
}

void main() {
  testWidgets('tells the user the Idee is gone when the server rejects the '
      'request', (tester) async {
    await _pump(
      tester,
      () => Stream.value(
        const Response(
          errors: [GraphQLError(message: 'not allowed')],
          response: {},
        ),
      ),
    );

    expect(find.text('application.melder.ideas.follow_gone'), findsOne);
    await _unmountAndFlushPollTimer(tester);
  });

  testWidgets('shows a generic message on a network failure', (tester) async {
    await _pump(
      tester,
      () => Stream.error(ServerException(originalException: Exception())),
    );

    expect(find.text('application.melder.ideas.follow_failed'), findsOne);
    expect(find.text('application.melder.ideas.follow_gone'), findsNothing);
    await _unmountAndFlushPollTimer(tester);
  });
}

import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/auth/auth.dart';
import 'package:app/common/auth/mitteilungen_provider.dart';
import 'package:app/common/volunteer_database/volunteer_database_enabled_notifier.dart';
import 'package:app/graphql/graphql_client.dart' hide GraphQLProvider;
import 'package:app/routes/maengel/maengel_detail.dart';
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

const _nichtGefunden = {
  '__typename': 'Query',
  'kommune': {
    '__typename': 'Kommune',
    'id': 'kommune-1',
    'mangelAusfuehrung': null,
  },
};

Future<void> _pumpDetail(
  WidgetTester tester,
  Link link, {
  AuthState? auth,
}) async {
  final graphQLClient = GraphQLClient(
    link: link,
    cache: GraphQLCache(),
    queryRequestTimeout: null,
  );
  final client = ValueNotifier(graphQLClient);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWith(_FixedAppConfigNotifier.new),
        authProvider.overrideWithValue(auth ?? AuthState.loading()),
        graphqlClientProvider.overrideWithValue(graphQLClient),
        volunteerDatabaseEnabledProvider.overrideWith(
          _NoVolunteerDbNotifier.new,
        ),
        mitteilungenCountNotifierProvider.overrideWith(
          _NoMitteilungenNotifier.new,
        ),
      ],
      child: GraphQLProvider(
        client: client,
        child: const MaterialApp(home: MaengelDetailPage(id: 'mangel-1')),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

Future<void> _unmountAndFlushPollTimer(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 15));
}

void main() {
  testWidgets('shows the not-found message instead of a spinner when the '
      'Mangel no longer exists', (tester) async {
    await _pumpDetail(
      tester,
      Link.function(
        (request, [forward]) =>
            Stream.value(const Response(data: _nichtGefunden, response: {})),
      ),
    );

    expect(find.text('application.melder.maengel.not_found'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await _unmountAndFlushPollTimer(tester);
  });

  testWidgets('shows an error with retry on a failed request, separate from '
      'not-found', (tester) async {
    var calls = 0;
    await _pumpDetail(
      tester,
      Link.function((request, [forward]) {
        calls++;
        return calls == 1
            ? Stream.error(ServerException(originalException: Exception()))
            : Stream.value(const Response(data: _nichtGefunden, response: {}));
      }),
    );

    expect(find.text('application.melder.maengel.detail_error'), findsOne);
    expect(find.text('application.melder.maengel.not_found'), findsNothing);

    await tester.tap(find.text('Erneut versuchen'));
    await tester.pump();
    await tester.pump();

    expect(find.text('application.melder.maengel.not_found'), findsOneWidget);
    expect(find.text('application.melder.maengel.detail_error'), findsNothing);
    await _unmountAndFlushPollTimer(tester);
  });

  group('Folgen', () {
    const mangel = {
      '__typename': 'Query',
      'kommune': {
        '__typename': 'Kommune',
        'id': 'kommune-1',
        'mangelAusfuehrung': {
          '__typename': 'Ausfuehrung',
          'id': 'mangel-1',
          'userId': 'anderer-nutzer',
          'adresse': null,
          'beschreibung': null,
          'kategorie': null,
          'title': null,
          'bilder': null,
          'status': 'BEARBEITUNG_DURCH_KOMMUNE',
          'aktuellerNutzerFolgt': false,
          'historie': <dynamic>[],
        },
      },
    };
    const auth = AuthState(null, null, null, 'buerger-1');

    Link link(Stream<Response> Function() mutation) {
      return Link.function((request, [forward]) {
        if (request.operation.document.definitions
            .whereType<OperationDefinitionNode>()
            .any((d) => d.type == OperationType.mutation)) {
          return mutation();
        }
        return Stream.value(const Response(data: mangel, response: {}));
      });
    }

    Future<void> tapFollow(WidgetTester tester) async {
      final button = find.text('application.melder.maengel.follow');
      await tester.ensureVisible(button);
      await tester.tap(button);
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    testWidgets('tells the user the Mangel is gone when the server rejects '
        'the request', (tester) async {
      await _pumpDetail(
        tester,
        link(
          () => Stream.value(
            const Response(
              errors: [GraphQLError(message: 'not allowed')],
              response: {},
            ),
          ),
        ),
        auth: auth,
      );

      await tapFollow(tester);

      expect(find.text('application.melder.maengel.follow_gone'), findsOne);
      await _unmountAndFlushPollTimer(tester);
    });

    testWidgets('shows a generic message on a network failure, not the '
        'gone message', (tester) async {
      await _pumpDetail(
        tester,
        link(
          () => Stream.error(ServerException(originalException: Exception())),
        ),
        auth: auth,
      );

      await tapFollow(tester);

      expect(find.text('application.melder.maengel.follow_failed'), findsOne);
      expect(find.text('application.melder.maengel.follow_gone'), findsNothing);
      await _unmountAndFlushPollTimer(tester);
    });

    testWidgets('shows no message when following succeeds', (tester) async {
      await _pumpDetail(
        tester,
        link(
          () => Stream.value(
            const Response(
              data: {
                '__typename': 'Mutation',
                'ausfuehrungFolgen': {
                  '__typename': 'AusfuehrungFolgenPayload',
                  'buerger': {
                    '__typename': 'Buerger',
                    'id': 'buerger-1',
                    'gefolgteAusfuehrungen': <dynamic>[],
                  },
                },
              },
              response: {},
            ),
          ),
        ),
        auth: auth,
      );

      await tapFollow(tester);

      expect(find.byType(SnackBar), findsNothing);
      await _unmountAndFlushPollTimer(tester);
    });
  });
}

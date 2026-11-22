import 'package:app/common/app_config/app_config.dart';
import 'package:app/routes/aktuelles/components/lage_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../common/fixtures/kommune_test_app_config_notifier.dart';

void main() {
  for (final active in [false, true]) {
    testWidgets('Reporting entry for active=$active', (tester) async {
      final client = ValueNotifier(
        GraphQLClient(
          cache: GraphQLCache(),
          link: Link.function(
            (request, [forward]) => Stream.value(
              Response(
                response: const {},
                data: {
                  'activeLagen': [
                    if (active)
                      {
                        'id': 'lage-1',
                        'title': 'Sturm',
                        'warningText': 'Sturmschäden',
                      },
                  ],
                },
              ),
            ),
          ),
        ),
      );
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const Scaffold(body: LageBubbles()),
          ),
          GoRoute(
            path: '/lagehelfer',
            builder: (_, state) => Text(state.uri.queryParameters['lageId']!),
          ),
        ],
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWith(KommuneTestAppConfigNotifier.new),
          ],
          child: GraphQLProvider(
            client: client,
            child: MaterialApp.router(routerConfig: router),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Sturm'), active ? findsOneWidget : findsNothing);
      expect(find.byType(TextButton), active ? findsOneWidget : findsNothing);
      if (active) {
        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();
        expect(find.text('lage-1'), findsOneWidget);
      }
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(minutes: 1));
      router.dispose();
      client.dispose();
    });
  }
}

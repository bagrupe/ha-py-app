import 'package:app/app/app.dart';
import 'package:app/common/kommune.dart';
import 'package:app/common/notifications/notifications.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/graphql/__generated__/kommune.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final fakeKommune = Fragment_Kommune(
  bereichAId: 'bereichAId',
  bereichBId: 'bereichBId',
  name: 'name',
  defaultPosition: [0, 0],
  abfallkalenderEnabled: true,
  analytics: Fragment_KommuneAnalytics(),
  rechtsTexte: Fragment_KommuneRechtstexte(),
);

class NoInitNotificationsService extends NotificationService {
  NoInitNotificationsService({
    required super.graphQLClient,
    required super.routerRef,
  }) : super(kommuneBereichAId: fakeKommune.bereichAId);

  @override
  Future<void> init() async {}
}

class TestApp extends StatelessWidget {
  const TestApp({required this.sharedPreferences, super.key});
  final SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        notificationsProvider.overrideWith((ref) {
          final graphqlClient = ref.watch(graphqlClientProvider);

          return NoInitNotificationsService(
            graphQLClient: graphqlClient,
            routerRef: ref,
          );
        }),
        kommuneProvider.overrideWithBuild((ref, notifier) => fakeKommune),
      ],
      child: const GraphQLProvider(child: App()),
    );
  }
}

import 'package:app/common/auth/mitteilungen_provider.dart';
import 'package:app/common/volunteer_database/volunteer_database_enabled_notifier.dart';
import 'package:app/graphql/graphql_client.dart' hide GraphQLProvider;
import 'package:app/routes/profil/mitteilungen/mitteilungen_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

var _lastReadCalls = 0;

class _NoVolunteerDbNotifier extends VolunteerDatabaseEnabledNotifier {
  @override
  bool build() => false;
}

class _RecordingCountNotifier extends MitteilungenCountNotifier {
  @override
  int build() => 0;

  @override
  void setLastRead() => _lastReadCalls++;
}

void main() {
  final source = StateProvider<List<MitteilungData>>((_) => []);

  setUp(() => _lastReadCalls = 0);

  Widget app({required bool visible}) {
    return TickerMode(
      enabled: visible,
      child: const MaterialApp(home: MitteilungenOverviewPage()),
    );
  }

  Future<ProviderContainer> pump(
    WidgetTester tester, {
    required bool visible,
  }) async {
    final container = ProviderContainer(
      overrides: [
        graphqlClientProvider.overrideWithValue(
          GraphQLClient(
            link: Link.function(
              (request, [forward]) => Stream.value(
                const Response(data: {'my': null}, response: {}),
              ),
            ),
            cache: GraphQLCache(),
          ),
        ),
        mitteilungenDataProvider.overrideWith((ref) => ref.watch(source)),
        volunteerDatabaseEnabledProvider.overrideWith(
          _NoVolunteerDbNotifier.new,
        ),
        mitteilungenCountNotifierProvider.overrideWith(
          _RecordingCountNotifier.new,
        ),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: app(visible: visible),
      ),
    );
    return container;
  }

  testWidgets(
    'marks mitteilungen as read when new data arrives while visible',
    (tester) async {
      final container = await pump(tester, visible: true);

      container.read(source.notifier).state = [];
      await tester.pump();

      expect(_lastReadCalls, 1);
    },
  );

  testWidgets('does not mark mitteilungen as read while the page is covered', (
    tester,
  ) async {
    final container = await pump(tester, visible: false);

    container.read(source.notifier).state = [];
    await tester.pump();

    expect(_lastReadCalls, 0);
  });
}

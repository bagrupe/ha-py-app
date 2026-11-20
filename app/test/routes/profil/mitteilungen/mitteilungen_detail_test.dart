import 'package:app/common/auth/mitteilungen_provider.dart';
import 'package:app/common/volunteer_database/volunteer_database_enabled_notifier.dart';
import 'package:app/routes/profil/mitteilungen/mitteilungen_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'notification_message_test.dart' show createNotification;

class _NoVolunteerDbNotifier extends VolunteerDatabaseEnabledNotifier {
  @override
  bool build() => false;
}

class _NoMitteilungenNotifier extends MitteilungenCountNotifier {
  @override
  int build() => 0;
}

Future<void> _pump(WidgetTester tester, List<MitteilungData> data) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        mitteilungenDataProvider.overrideWithValue(data),
        volunteerDatabaseEnabledProvider.overrideWith(
          _NoVolunteerDbNotifier.new,
        ),
        mitteilungenCountNotifierProvider.overrideWith(
          _NoMitteilungenNotifier.new,
        ),
      ],
      child: const MaterialApp(
        home: MitteilungDetailPage(
          ausfuehrungId: 'ausfuehrung-1',
          verbindungId: 'historie-1',
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shows the not-found message instead of throwing once the '
      'notification is gone', (tester) async {
    await _pump(tester, []);

    expect(tester.takeException(), isNull);
    expect(
      find.text('application.profil.mitteilungen.not_found'),
      findsOneWidget,
    );
  });

  testWidgets('shows the notification while it exists', (tester) async {
    await _pump(tester, [createNotification(status: 'Done')]);

    expect(find.text('Parking permit'), findsOneWidget);
    expect(
      find.text('application.profil.mitteilungen.not_found'),
      findsNothing,
    );
  });
}

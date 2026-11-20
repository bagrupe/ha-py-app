import 'package:app/common/auth/mitteilungen_provider.dart';
import 'package:app/common/theme.dart';
import 'package:app/graphql/__generated__/user.graphql.dart';
import 'package:app/routes/profil/mitteilungen/notification_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper/localization_helper.dart';

/// Creates a notification with a configurable status and message.
MitteilungData createNotification({String? status, String? message}) {
  return MitteilungData(
    id: 'ausfuehrung-1',
    prozessName: 'Parking permit',
    historie: Query_MyMitteilungen_my__Buerger_mitteilungen_historie(
      id: 'historie-1',
      createdAt: DateTime.utc(2026, 8, 18, 10),
      statusAenderung: status,
      statusAenderungBeschreibung: status == null
          ? null
          : 'The application has been completed.',
      nachricht: message,
    ),
  );
}

/// Renders a notification with the providers required by the test.
Future<void> pumpNotification(
  WidgetTester tester, {
  required MitteilungData notification,
  required bool overview,
}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [themeProvider.overrideWithValue(ThemeData.light())],
      child: MaterialApp(
        home: Scaffold(
          body: NotificationDetail(
            notification: notification,
            overview: overview,
          ),
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(TestLocalizationHelper.init);

  testWidgets('shows a message preview in the overview', (tester) async {
    await pumpNotification(
      tester,
      notification: createNotification(
        status: 'Completed',
        message: 'Your permit is ready for collection.',
      ),
      overview: true,
    );

    expect(find.text('Your permit is ready for collection.'), findsOneWidget);
    expect(find.text('Completed'), findsNothing);
  });

  testWidgets('shows the status and message in the detail view', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    await pumpNotification(
      tester,
      notification: createNotification(
        status: 'Completed',
        message: 'Your permit is ready for collection.',
      ),
      overview: false,
    );

    expect(find.text('The application has been completed.'), findsOneWidget);
    expect(find.text('Your permit is ready for collection.'), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('Nachricht zur Prozessbearbeitung')),
      findsOneWidget,
    );

    semantics.dispose();
  });

  testWidgets('continues to show the status when no message exists', (
    tester,
  ) async {
    await pumpNotification(
      tester,
      notification: createNotification(status: 'Completed', message: '   '),
      overview: true,
    );

    expect(find.text('Completed'), findsOneWidget);
  });

  testWidgets('shows an entry containing only a message', (tester) async {
    await pumpNotification(
      tester,
      notification: createNotification(message: 'A personal message'),
      overview: false,
    );

    expect(find.text('A personal message'), findsOneWidget);
  });
}

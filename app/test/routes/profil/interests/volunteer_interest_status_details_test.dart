import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/routes/profil/interests/volunteer_interest_status_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper/localization_helper.dart';

/// Renders visible request status details.
Future<void> pumpStatusDetails(
  WidgetTester tester, {
  required Enum_EhrenamtsbankAnfrageStatus status,
  DateTime? agreementConfirmedAt,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: VolunteerInterestStatusDetails(
          status: status,
          agreementConfirmedAt: agreementConfirmedAt,
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(TestLocalizationHelper.init);

  testWidgets('shows the accepted status before confirmation', (tester) async {
    await pumpStatusDetails(
      tester,
      status: Enum_EhrenamtsbankAnfrageStatus.AKZEPTIERT,
    );

    expect(find.text('Status: Angefragt'), findsOneWidget);
    expect(find.textContaining('Vereinbart am'), findsNothing);
  });

  testWidgets('shows status and server agreement time after confirmation', (
    tester,
  ) async {
    await pumpStatusDetails(
      tester,
      status: Enum_EhrenamtsbankAnfrageStatus.VEREINBART,
      agreementConfirmedAt: DateTime(2026, 9, 1, 10, 30),
    );

    expect(find.text('Status: Zugesagt'), findsOneWidget);
    expect(find.textContaining('Vereinbart am'), findsOneWidget);
    expect(find.textContaining('10:30'), findsOneWidget);
  });
}

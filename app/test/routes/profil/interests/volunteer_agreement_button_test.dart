import 'package:app/routes/profil/interests/volunteer_agreement_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper/localization_helper.dart';

/// Renders an agreement button with the requested visibility.
Future<void> pumpAgreementButton(
  WidgetTester tester, {
  required bool isVisible,
  required VoidCallback onPressed,
  bool isLoading = false,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: VolunteerAgreementButton(
          isVisible: isVisible,
          isLoading: isLoading,
          onPressed: onPressed,
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(TestLocalizationHelper.init);

  testWidgets('shows the confirmation action for accepted requests', (
    tester,
  ) async {
    var confirmationCount = 0;
    await pumpAgreementButton(
      tester,
      isVisible: true,
      onPressed: () => confirmationCount += 1,
    );

    expect(find.text('Vereinbarung bestätigt'), findsOneWidget);
    await tester.tap(find.text('Vereinbarung bestätigt'));
    expect(confirmationCount, 1);
  });

  testWidgets('hides the confirmation action after agreement', (tester) async {
    await pumpAgreementButton(tester, isVisible: false, onPressed: () {});

    expect(find.text('Vereinbarung bestätigt'), findsNothing);
  });

  testWidgets('blocks repeated confirmation while loading', (tester) async {
    var confirmationCount = 0;
    await pumpAgreementButton(
      tester,
      isVisible: true,
      isLoading: true,
      onPressed: () => confirmationCount += 1,
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    expect(confirmationCount, 0);
  });
}

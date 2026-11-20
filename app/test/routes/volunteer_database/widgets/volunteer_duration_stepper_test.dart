import 'package:app/routes/volunteer_database/widgets/parts/volunteer_duration_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Renders the shared duration stepper with the selected value.
Future<void> pumpDurationStepper(
  WidgetTester tester, {
  required int durationMinutes,
  required ValueChanged<int> onChanged,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: VolunteerDurationStepper(
          durationMinutes: durationMinutes,
          minimumMinutes: 30,
          maximumMinutes: 720,
          stepMinutes: 15,
          durationSuffix: ' Std.',
          semanticLabel: 'Dauer 2 Stunden',
          decreaseTooltip: 'Dauer verringern',
          increaseTooltip: 'Dauer erhöhen',
          onChanged: onChanged,
        ),
      ),
    ),
  );
}

/// Verifies the reusable duration stepper behavior.
void main() {
  testWidgets('formats the duration and reports stepped values', (
    tester,
  ) async {
    int? selectedMinutes;
    await pumpDurationStepper(
      tester,
      durationMinutes: 120,
      onChanged: (value) => selectedMinutes = value,
    );

    expect(find.text('2:00 Std.', findRichText: true), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    expect(selectedMinutes, 135);

    await tester.tap(find.byIcon(Icons.remove));
    expect(selectedMinutes, 105);
  });

  testWidgets('disables the decrement action at the minimum', (tester) async {
    await pumpDurationStepper(tester, durationMinutes: 30, onChanged: (_) {});

    final button = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.remove),
    );
    expect(button.onPressed, isNull);
  });
}

import 'package:app/components/forms/app_phone_number_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<String?> enterText(WidgetTester tester, String input) async {
    String? reported;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppPhoneNumberField(
            label: 'Phone',
            onChanged: (value) => reported = value,
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(TextFormField), input);
    await tester.pump();
    return reported;
  }

  group('AppPhoneNumberField', () {
    for (final entry in {
      '+491776553776': '1776553776',
      '+49 1776553776': '1776553776',
      '00491776553776': '1776553776',
      '01776553776': '1776553776',
      '1776553776': '1776553776',
    }.entries) {
      testWidgets('normalizes "${entry.key}"', (tester) async {
        final reported = await enterText(tester, entry.key);

        expect(reported, entry.value);
        expect(find.text(entry.value), findsOneWidget);
      });
    }
  });
}

import 'dart:convert';
import 'dart:io';

import 'package:app/routes/onboarding/components/personal_data_form.dart';
import 'package:app/routes/profil/profil_personal_data.dart';
import 'package:flutter_test/flutter_test.dart';

/// Verifies localization coverage without changing persisted profile values.
void main() {
  test('profile and onboarding labels resolve in the German translations', () {
    /// Real translation catalog used by the application.
    final translations =
        jsonDecode(File('assets/translations/de.json').readAsStringSync())
            as Map<String, dynamic>;

    /// Resolves a dotted translation key against the real asset.
    Object? lookup(String key) {
      Object? value = translations;
      for (final segment in key.split('.')) {
        if (value is! Map<String, dynamic>) return null;
        value = value[segment];
      }
      return value;
    }

    for (final field in [...defaultFields, ...onboardingDefaultFields]) {
      expect(lookup('${field.translationKey}.label'), isA<String>());
      expect(lookup('${field.translationKey}.hint'), isA<String>());
      if (field is DefaultTextField) {
        for (final option in field.options.entries) {
          expect(lookup(option.value), option.key);
        }
      }
    }

    expect(defaultFields.map((field) => field.name), [
      'Anrede',
      'Doktorgrad',
      'Vorname',
      'Nachname',
      'Geschlecht',
      'Geburtsdatum',
      'Postleitzahl',
      'Gemeinde',
      'Ort',
      'Straße',
      'Hausnummer',
      'Adresszusatz',
    ]);
    expect(
      defaultFields
          .where((field) => field.showInFirstSetup)
          .map((field) => field.name),
      ['Vorname', 'Nachname'],
    );
  });
}

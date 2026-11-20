import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:iban/iban.dart';

/// Stellt benutzerdefinierte String-Validatoren bereit.
class CustomStringValidators {
  /// Gibt einen Validator zurück, der prüft, ob eine IBAN gültig ist.
  static FormFieldValidator<String> iban() {
    return (value) {
      if (value != null && !isValid(value)) {
        return 'Bitte geben Sie eine gültige IBAN ein';
      }
      return null;
    };
  }

  /// Formatierer zur Darstellung und Eingabe von IBANs.
  static IbanFormatter ibanFormatter = IbanFormatter();
}

/// Formatiert IBAN-Eingaben gemäß elektronischem und Druckformat.
class IbanFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final stripped = electronicFormat(newValue.text);
    final formatted = toPrintFormat(stripped);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

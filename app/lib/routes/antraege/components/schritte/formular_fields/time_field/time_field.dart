// ignore_for_file: inference_failure_on_function_invocation

import 'package:app/common/shared_preferences.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/formular_field_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

/// Typalias für die Daten eines Zeit-Formularfelds aus dem GraphQL-Fragment.
typedef FormularTimeFieldData = Fragment_FormularFeld__TimeFormularFeld;

/// Widget zur Darstellung eines Zeitformularfelds mit optionaler Pflichtvalidierung und initialem Wert aus SharedPreferences.
class FormularTimeField extends ConsumerWidget {
  /// Erstellt ein Zeitformularfeld mit den angegebenen Felddaten und Optionalität.
  const FormularTimeField({
    required this.feld,
    super.key,
    this.optional = false,
  });

  /// Die Daten des Zeitformularfelds.
  final FormularTimeFieldData feld;

  /// Gibt an, ob das Feld optional ist.
  final bool optional;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final validator = FormBuilderValidators.required(
      errorText: 'Diese Angabe ist zwingend notwendig',
    );

    DateTime? savedValue;

    if (feld.inhaltsTag != null) {
      final inhaltsTag = feld.inhaltsTag!;
      final prefs = ref.watch(sharedPreferencesProvider);
      final savedString = prefs.getString('field_time_$inhaltsTag');

      savedValue = savedString != null ? DateTime.tryParse(savedString) : null;
    }

    final decoration = InputDecoration(
      labelText: feld.angezeigterName,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintText: feld.anweisung,
      hintStyle: const TextStyle(color: Colors.grey),
      isDense: true,
      border: const OutlineInputBorder(borderRadius: formularFieldBorderRadius),
      labelStyle: const TextStyle(color: Colors.black),
    );

    return FormBuilderDateTimePicker(
      name: feld.slotName,
      inputType: InputType.time,
      decoration: decoration,
      validator: optional ? null : validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.next,
      initialValue: savedValue,
      format: DateFormat('HH:mm', 'de_DE'),
    );
  }
}

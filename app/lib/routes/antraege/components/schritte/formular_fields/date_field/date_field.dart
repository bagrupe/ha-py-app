// ignore_for_file: inference_failure_on_function_invocation

import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/formular_field_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

/// Typalias für die Daten eines Datumsformularfelds.
typedef FormularDateFieldData = Fragment_FormularFeld__DateFormularFeld;

/// Widget zur Darstellung eines Formularfelds für die Datumseingabe.
class FormularDateField extends ConsumerWidget {
  /// Erstellt ein Datumsformularfeld mit den angegebenen Daten und Optionalität.
  const FormularDateField({
    required this.feld,
    super.key,
    this.optional = false,
  });

  /// Die Daten des Formularfelds.
  final FormularDateFieldData feld;

  /// Gibt an, ob das Feld optional ist.
  final bool optional;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final validator = FormBuilderValidators.required(
      errorText: 'Diese Angabe ist zwingend notwendig',
    );

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
      inputType: InputType.date,
      decoration: decoration,
      validator: optional ? null : validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.next,
      format: DateFormat('dd.MM.yyyy'),
    );
  }
}

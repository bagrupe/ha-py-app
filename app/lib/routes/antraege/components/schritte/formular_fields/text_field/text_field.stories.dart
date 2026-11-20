import 'package:app/common/widgetbook/helpers.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/text_field/text_field.dart';
import 'package:flutter/material.dart' hide TextFormField;
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'TextField', type: FormularTextField)
Widget textField(BuildContext context) =>
    FormularTextField(feld: formularFeldData(context).toStringFormularFeld());

@UseCase(name: 'SelectField', type: FormularTextField)
Widget selectTextField(BuildContext context) => FormularTextField(
  feld: formularFeldData(
    context,
  ).toStringFormularFeld(options: ['Option 1', 'Option 2', 'Option 3']),
);

@UseCase(name: 'MultilineField', type: FormularTextField)
Widget multilineTextField(BuildContext context) => FormularTextField(
  feld: formularFeldData(context).toStringFormularFeld(multiline: true),
);

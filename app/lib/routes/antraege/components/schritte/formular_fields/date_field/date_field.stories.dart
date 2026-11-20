import 'package:app/common/widgetbook/helpers.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/date_field/date_field.dart';
import 'package:flutter/material.dart' hide TextFormField;
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'DateField', type: FormularDateField)
Widget dateField(BuildContext context) =>
    FormularDateField(feld: formularFeldData(context).toDateFormularFeld());

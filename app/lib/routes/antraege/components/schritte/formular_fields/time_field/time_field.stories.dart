import 'package:app/common/widgetbook/helpers.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/time_field/time_field.dart';
import 'package:flutter/material.dart' hide TextFormField;
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'TimeField', type: FormularTimeField)
Widget timeField(BuildContext context) =>
    FormularTimeField(feld: formularFeldData(context).toTimeFormularFeld());

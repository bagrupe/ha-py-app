import 'package:app/common/widgetbook/helpers.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/checkbox_list_field/checkbox_list_field.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Checkbox Field', type: FormularCheckboxListField)
Widget checkboxField(BuildContext context) => FormularCheckboxListField(
  feld: formularFeldData(context).toCheckboxFormularFeld(),
);

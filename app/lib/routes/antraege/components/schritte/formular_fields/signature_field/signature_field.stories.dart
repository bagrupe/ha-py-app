import 'package:app/common/widgetbook/helpers.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/signature_field/signature_field.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'SigningField', type: FormularSignatureField)
Widget signingField(BuildContext context) => FormularSignatureField(
  feld: formularFeldData(context).toSignatureFormularFeld(),
);

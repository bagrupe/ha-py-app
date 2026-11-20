import 'package:app/common/widgetbook/helpers.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/image_field/upload_field.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'DefaultImageField', type: FormularUploadField)
Widget defaultImageField(BuildContext context) =>
    FormularUploadField(feld: formularFeldData(context).toUploadFormularFeld());

@UseCase(name: 'MultiImageField', type: FormularUploadField)
Widget multiImageField(BuildContext context) => FormularUploadField(
  feld: formularFeldData(context).toUploadFormularFeld(multi: true),
);

@UseCase(name: 'DokumentField', type: FormularUploadField)
Widget documentField(BuildContext context) => FormularUploadField(
  feld: formularFeldData(
    context,
  ).toUploadFormularFeld(multi: true, document: true),
);

@UseCase(name: 'FotoField', type: FormularUploadField)
Widget fotoField(BuildContext context) => FormularUploadField(
  feld: formularFeldData(
    context,
  ).toUploadFormularFeld().copyWith(slotName: 'foto'),
);

@UseCase(name: 'UnterschriftField', type: FormularUploadField)
Widget unterschriftField(BuildContext context) => FormularUploadField(
  feld: formularFeldData(
    context,
  ).toUploadFormularFeld().copyWith(slotName: 'unterschrift'),
);

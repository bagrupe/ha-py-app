import 'package:app/common/expressions/expression.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/checkbox_list_field/checkbox_list_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/date_field/date_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/image_field/upload_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/signature_field/signature_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/text_field/text_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/time_field/time_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/uebersicht_field.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

FormularFeldData formularFeldData(BuildContext context) {
  return FormularFeldData(
    $__typename: 'FormularFeld',
    slotName: 'default',
    angezeigterName: context.knobs.string(label: 'Name', initialValue: 'Name'),
    anweisung: context.knobs.string(
      label: 'Anweisung',
      initialValue: 'Tragen Sie hier einen Wert ein',
    ),
    istRelevant: boolExpressionFromJson('true'),
    pflichtfeld: context.knobs.boolean(label: 'Pflichtfeld'),
  );
}

extension TypedFeldData on FormularFeldData {
  FormularTextFeldData toStringFormularFeld({
    bool multiline = false,
    List<String>? options,
  }) {
    final stringOptions = (options ?? [])
        .map(
          (e) => Fragment_FormularFeld__StringFormularFeld_stringOptions(
            key: e,
            value: e,
          ).toJson(),
        )
        .toList();

    return FormularTextFeldData.fromJson(
      toJson()
        ..['multiline'] = multiline
        ..['stringOptions'] = stringOptions
        ..['validationType'] = 'DEFAULT',
    );
  }

  FormularImageFeldData toUploadFormularFeld({
    bool multi = false,
    bool document = false,
  }) => FormularImageFeldData.fromJson(
    toJson()
      ..['multi'] = multi
      ..['document'] = document
      ..['brauchtFreigabe'] = false,
  );

  FormularCheckboxFeldData toCheckboxFormularFeld({
    bool defaultChecked = false,
  }) => FormularCheckboxFeldData.fromJson(
    toJson()
      ..['checkOptions'] = [
        Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions(
          key: 'key1',
          label: 'Unchecked',
          defaultChecked: false,
        ).toJson(),
        Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions(
          key: 'key2',
          label: 'Unchecked 2',
          defaultChecked: false,
        ).toJson(),
      ],
  );

  FormularDateFieldData toDateFormularFeld() =>
      FormularDateFieldData.fromJson(toJson());

  FormularTimeFieldData toTimeFormularFeld() =>
      FormularTimeFieldData.fromJson(toJson());

  FormularSignatureFeldData toSignatureFormularFeld() =>
      FormularSignatureFeldData.fromJson(toJson());

  FormularAnzeigeTextBlockFeldData toAnzeigeTextBlockFormularFeld({
    String text = 'Beispieltext',
  }) => FormularAnzeigeTextBlockFeldData.fromJson(toJson()..['text'] = text);
}

typedef FormularAnzeigeTextBlockFeldData =
    Fragment_FormularFeld__AnzeigeTextBlockFeld;

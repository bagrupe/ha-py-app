import 'package:app/common/widgetbook/helpers.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/location_field/location_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/location_field/selection_map.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'LocationField', type: FormularLocationField)
Widget locationField(BuildContext context) => Scaffold(
  body: FormularLocationField(
    feld: formularFeldData(context).copyWith(slotName: 'location'),
  ),
);

@UseCase(name: 'SelectionMap', type: SelectionMap)
Widget selectionMap(BuildContext context) =>
    SelectionMap(onSelect: print, onCancel: () => debugPrint('Cancelled'));

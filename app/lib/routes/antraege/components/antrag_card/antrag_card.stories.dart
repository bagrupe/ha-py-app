import 'package:app/routes/antraege/common/antrag_state.dart';
import 'package:app/routes/antraege/components/antrag_card/antrag_card.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Antrag in Bearbeitung', type: AntragCard)
Widget antragInBearbeitung(BuildContext context) => AntragCard(
  id: 'example',
  title: context.knobs.string(label: 'Antragsname', initialValue: 'Antrag X'),
  state: AntragState.kommune,
  lastChange: DateTime.now(),
);

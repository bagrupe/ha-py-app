import 'package:app/routes/antraege/common/antrag_state.dart';
import 'package:app/routes/antraege/components/antrag_detail_status_chip/antrag_detail_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Antrag Detail Status Chip', type: AntragDetailStatusChip)
Widget antragDetailStatusChip(BuildContext context) => AntragDetailStatusChip(
  state: context.knobs.object.dropdown(
    label: 'Status',
    options: AntragState.values,
    labelBuilder: (state) => state.toLabel(),
  ),
);

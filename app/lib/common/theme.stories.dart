import 'package:app/components/heading/heading.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

/// Definiert einen UseCase für das Widget Heading mit einem konfigurierbaren Titel.
/// [context] wird verwendet, um interaktive Eingaben (Knobs) für die Vorschau zu erhalten.
@UseCase(name: 'Theme', type: Heading)
Widget heading(BuildContext context) {
  return Heading(
    context.knobs.string(label: 'Titel', initialValue: 'Beispiel'),
  );
}

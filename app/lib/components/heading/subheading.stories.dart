import 'package:app/components/heading/subheading.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Titel', type: SubHeading)
Widget subheading(BuildContext context) =>
    SubHeading(context.knobs.string(label: 'Titel', initialValue: 'Beispiel'));

@UseCase(name: 'Background & Icon Button', type: SubHeading)
Widget subheadingWithButton(BuildContext context) => SubHeading(
  context.knobs.string(label: 'Titel', initialValue: 'Beispiel'),
  background: true,
  icon: const Icon(Icons.edit),
  onTapIcon: () {},
);

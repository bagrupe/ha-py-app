import 'package:app/components/heading/heading_with_divider.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Titel', type: HeadingWithDivider)
Widget headingWithDivider(BuildContext context) => HeadingWithDivider(
  title: context.knobs.string(label: 'Titel', initialValue: 'Beispiel 1'),
);

@UseCase(name: 'TitelInPrimaryColor', type: HeadingWithDivider)
Widget headingWithDividerInPrimary(BuildContext context) => HeadingWithDivider(
  title: context.knobs.string(label: 'Titel', initialValue: 'Beispiel 1'),
  primary: true,
);

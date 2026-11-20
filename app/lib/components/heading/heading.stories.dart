import 'package:app/components/heading/heading.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Titel', type: Heading)
Widget heading(BuildContext context) =>
    Heading(context.knobs.string(label: 'Titel', initialValue: 'Beispiel'));

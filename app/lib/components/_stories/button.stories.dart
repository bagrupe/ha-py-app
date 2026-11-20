import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'OutlinedButton', type: OutlinedButton)
Widget outlinedButton(BuildContext context) => OutlinedButton(
  onPressed: () {},
  child: Text(
    context.knobs.string(label: 'Button-Text', initialValue: 'Click me!'),
  ),
);

import 'package:app/components/filter_button/filter_button.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Filter', type: FilterButton)
Widget filterButton(BuildContext context) =>
    FilterButton(text: 'Filter', onPressed: () {});

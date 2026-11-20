import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

// TODO fix the logo not respecting the region

@UseCase(name: 'Common App Bar', type: CommonAppBar)
Widget commonAppBar(BuildContext context) => Scaffold(
  appBar: CommonAppBar(
    title: Text(context.knobs.string(label: 'Titel', initialValue: 'Titel')),
    logo: context.knobs.boolean(label: 'Logo', initialValue: true),
  ),
);

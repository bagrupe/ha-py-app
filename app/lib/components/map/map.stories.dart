import 'package:app/components/map/map.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Map', type: KommunalAppMap)
Widget baseMap(BuildContext context) => const KommunalAppMap(
  // Position of ATMINA HQ
  defaultPosition: [52.3741275, 9.7433711],
  withShowcase: true,
);

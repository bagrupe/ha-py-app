import 'package:app/components/searchbar/searchbar.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Searchbar', type: Searchbar)
Widget searchbar(BuildContext context) => Searchbar(onChanged: (_) {});

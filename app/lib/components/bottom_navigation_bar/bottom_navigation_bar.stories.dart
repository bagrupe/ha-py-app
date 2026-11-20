import 'package:app/components/bottom_navigation_bar/app_bottom_navigation_bar/app_bottom_navigation_bar.dart';
import 'package:app/components/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'BottomNavigation', type: AppBottomNavigationBar)
Widget bottomNavigation(BuildContext context) => const Align(
  alignment: Alignment.bottomCenter,
  child: MainBottomNavigationBar(currentIndex: 1),
);

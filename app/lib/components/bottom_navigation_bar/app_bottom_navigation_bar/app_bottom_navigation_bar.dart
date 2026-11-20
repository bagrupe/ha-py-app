import 'package:app/common/util/scaler.dart';
import 'package:app/components/bottom_navigation_bar/parts/a11y_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppBottomNavigationBar extends ConsumerWidget {
  const AppBottomNavigationBar({
    required this.currentIndex,
    required this.items,
    super.key,
    this.onTap,
  });

  final int currentIndex;
  final List<AppBottomNavigationBarItem> items;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isA11yMode = MediaQuery.textScalerOf(context).isA11yMode;

    if (isA11yMode) {
      return A11yBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: items,
      );
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      items: items
          .map(
            (item) => BottomNavigationBarItem(
              icon: item.badgeCount > 0
                  ? Badge.count(count: item.badgeCount, child: item.icon)
                  : item.icon,
              label: item.label,
            ),
          )
          .toList(),
    );
  }
}

class AppBottomNavigationBarItem {
  const AppBottomNavigationBarItem({
    required this.label,
    required this.icon,
    this.badgeCount = 0,
  });

  final String label;
  final Widget icon;
  final int badgeCount;
}

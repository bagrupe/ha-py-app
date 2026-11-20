import 'package:app/common/extensions/string.dart';
import 'package:app/components/bottom_navigation_bar/app_bottom_navigation_bar/app_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

/// An accessibility-friendly bottom navigation bar widget that displays only wrapping text labels and hides icons.
class A11yBottomNavigationBar extends StatelessWidget {
  const A11yBottomNavigationBar({
    required this.currentIndex,
    required this.items,
    super.key,
    this.onTap,
  });

  /// The currently selected index.
  final int currentIndex;

  /// The list of items to display.
  final List<AppBottomNavigationBarItem> items;

  /// The callback when an item is tapped.
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.of(
      context,
    ).textScaler.clamp(minScaleFactor: 1, maxScaleFactor: 2);
    final theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color:
            theme.bottomNavigationBarTheme.backgroundColor ?? theme.canvasColor,
        border: Border(top: BorderSide(color: theme.dividerColor, width: 0.5)),
      ),
      child: SafeArea(
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == currentIndex;
            final hasBadge = item.badgeCount > 0;
            final displayLabel = hasBadge
                ? '${item.label} (${item.badgeCount})'
                : item.label;

            final textHeight = displayLabel
                .sizeFromStyle(
                  TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? (theme.bottomNavigationBarTheme.selectedItemColor ??
                              theme.primaryColor)
                        : (theme.bottomNavigationBarTheme.unselectedItemColor ??
                              theme.hintColor),
                  ),
                  scaler: scaler,
                  availableSpace:
                      (MediaQuery.sizeOf(context).width -
                          32 -
                          8 * (items.length - 1)) /
                      items.length,
                )
                .height;

            final tabHeight = textHeight + 16 + 8;
            return Flexible(
              child: Semantics(
                button: true,
                selected: isSelected,
                label: displayLabel,
                child: InkWell(
                  onTap: onTap != null ? () => onTap!(index) : null,
                  child: Container(
                    height: tabHeight,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 4,
                    ),
                    child: Center(
                      child: Text(
                        displayLabel,
                        textScaler: scaler,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? (theme
                                        .bottomNavigationBarTheme
                                        .selectedItemColor ??
                                    theme.primaryColor)
                              : (theme
                                        .bottomNavigationBarTheme
                                        .unselectedItemColor ??
                                    theme.hintColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

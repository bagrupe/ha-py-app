import 'package:flutter/material.dart';

/// Displays a compact icon on a circular themed background.
class RoundedMetaIcon extends StatelessWidget {
  /// Creates a rounded metadata icon with optional surrounding [padding].
  const RoundedMetaIcon({
    this.icon = Icons.check,
    this.padding = const EdgeInsets.symmetric(horizontal: 4),
    super.key,
  });

  /// Icon displayed in the center of the circle.
  final IconData icon;

  /// Space added around the circular icon.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 16,
      height: 16,
      margin: padding,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.primaryContainer,
      ),
      child: Icon(icon, size: 14, color: theme.colorScheme.primary),
    );
  }
}

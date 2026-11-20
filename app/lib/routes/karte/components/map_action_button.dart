import 'package:flutter/material.dart';

/// Circular icon button for map actions with accessible labels.
class MapActionButton extends StatelessWidget {
  const MapActionButton({
    required this.iconData,
    required this.onPressed,
    required this.semanticsLabel,
    required this.tooltip,
    super.key,
    this.size = 48,
    this.iconSize = 24,
    this.backgroundColor = Colors.white,
    this.iconColor,
    this.shadowColor,
  });

  /// Icon displayed inside the action button.
  final IconData iconData;

  /// Callback triggered when the action button is pressed.
  final VoidCallback onPressed;

  /// Accessible label announced by screen readers.
  final String semanticsLabel;

  /// Tooltip text shown for pointer and long-press interactions.
  final String tooltip;

  /// Width and height of the circular button.
  final double size;

  /// Size of the icon inside the button.
  final double iconSize;

  /// Background color of the circular button.
  final Color backgroundColor;

  /// Optional icon color override.
  final Color? iconColor;

  /// Optional shadow color override.
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      enabled: true,
      label: semanticsLabel,
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: backgroundColor,
          shape: CircleBorder(
            side: BorderSide(color: colorScheme.onSurface, width: 1.5),
          ),
          elevation: 6,
          shadowColor: shadowColor ?? Colors.black.withValues(alpha: 0.25),
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: SizedBox.square(
              dimension: size,
              child: ExcludeSemantics(
                child: Icon(
                  iconData,
                  size: iconSize,
                  color: iconColor ?? colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

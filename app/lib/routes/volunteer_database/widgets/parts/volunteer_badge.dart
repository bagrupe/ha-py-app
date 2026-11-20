import 'package:flutter/material.dart';

/// Compact metadata badge used by volunteer marketplace cards.
class VolunteerBadge extends StatelessWidget {
  /// Creates a badge with [text] and an optional leading [icon].
  const VolunteerBadge({
    required this.text,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.fontWeight,
    super.key,
  });

  /// Optional background override for status badges.
  final Color? backgroundColor;

  /// Optional foreground override for status badges.
  final Color? foregroundColor;

  /// Optional font weight override for the badge label.
  final FontWeight? fontWeight;

  /// Optional icon displayed before [text].
  final IconData? icon;

  /// Text displayed inside the badge.
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 4, 8, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: backgroundColor ?? theme.colorScheme.surfaceContainerLowest,
        border: Border.all(
          color: backgroundColor ?? theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ExcludeSemantics(
                child: Icon(
                  icon,
                  size: 14,
                  color: foregroundColor ?? theme.colorScheme.onSurface,
                ),
              ),
            )
          else
            const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.titleLarge?.copyWith(
              color: foregroundColor ?? theme.colorScheme.onSurface,
              fontWeight: fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}

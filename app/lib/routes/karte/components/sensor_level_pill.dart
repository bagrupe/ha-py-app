import 'package:app/common/design_tokens.dart';
import 'package:flutter/material.dart';

/// Colored pill showing the current danger level (e.g. "Safe", "Warning").
class SensorLevelPill extends StatelessWidget {
  const SensorLevelPill({required this.color, required this.label, super.key});

  /// Background color of the pill (color of the current danger zone).
  final Color color;

  /// Short label to display.
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: DesignTokens.white),
      ),
    );
  }
}

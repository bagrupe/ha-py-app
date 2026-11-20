import 'package:app/common/design_tokens.dart';
import 'package:app/common/extensions/sensor_type_extension.dart';
import 'package:flutter/material.dart';

/// Shows a colored hint box with the CMS-configured title and description
/// for a sensor's current danger level.
class SensorLevelHint extends StatelessWidget {
  const SensorLevelHint({
    required this.levelIndex,
    required this.text,
    super.key,
  });

  /// Index of the current danger level (0=safe .. 3=critical).
  final int levelIndex;

  final WarningLevelText text;

  static const _backgroundColors = [
    DesignTokens.green100,
    DesignTokens.yellow100,
    DesignTokens.orange100,
    DesignTokens.red200,
  ];

  static const _textColors = [
    DesignTokens.green900,
    DesignTokens.yellow900,
    DesignTokens.orange900,
    DesignTokens.red900,
  ];

  @override
  Widget build(BuildContext context) {
    final title = text.title;
    final description = text.description;
    if (title == null && description == null) return const SizedBox.shrink();

    final index = levelIndex.clamp(0, 3);
    final color = _textColors[index];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _backgroundColors[index],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Row(
              children: [
                Icon(Icons.info_outline, color: color, size: 24),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(color: color),
                  ),
                ),
              ],
            ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                description,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: color),
              ),
            ),
        ],
      ),
    );
  }
}

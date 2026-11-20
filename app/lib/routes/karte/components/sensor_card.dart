import 'package:app/common/design_tokens.dart';
import 'package:flutter/material.dart';

class SensorCard extends StatelessWidget {
  const SensorCard({
    required this.title,
    required this.value,
    required this.unit,

    this.description,
    this.footer,
    this.extraValueContent,
    this.belowContent,
    super.key,
  });

  final String title;
  final String? value;
  final String? unit;
  final String? description;
  final String? footer;
  final Widget? extraValueContent;
  final Widget? belowContent;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: DesignTokens.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DesignTokens.gray300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 6, left: 12, top: 14),
            child: Text(
              title,
              style: textTheme.headlineSmall?.copyWith(
                color: DesignTokens.gray700,
              ),
            ),
          ),
          if (value != null)
            Padding(
              padding: EdgeInsets.only(
                right: 12,
                left: 12,
                bottom: belowContent != null ? 0 : 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Text(
                          value!,
                          style: textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          unit ?? '',
                          style: textTheme.headlineMedium?.copyWith(
                            color: primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          if (belowContent != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: belowContent,
            ),
        ],
      ),
    );
  }
}

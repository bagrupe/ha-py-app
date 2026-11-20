import 'package:app/common/design_tokens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays a labeled idea detail value.
class IdeaDetailField extends StatelessWidget {
  /// Creates a labeled detail field.
  const IdeaDetailField({required this.label, required this.value, super.key});

  /// Field label shown before the value.
  final String label;

  /// Field value shown below the label.
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: 'application.melder.detail_field_semantics'.tr(
        namedArgs: {'label': label, 'value': value},
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: DesignTokens.gray500,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(value, style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

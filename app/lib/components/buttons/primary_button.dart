import 'package:app/common/design_tokens.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    this.onPressed,
    this.trailingIconData,
    this.leadingIconData,
    super.key,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? trailingIconData;
  final IconData? leadingIconData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: DesignTokens.white,
        side: BorderSide(color: theme.colorScheme.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leadingIconData != null)
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 16),
              child: Icon(
                trailingIconData,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: leadingIconData != null ? 8 : 16),
              child: Text(
                label,
                style: theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          if (trailingIconData != null)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 16),
              child: Icon(
                trailingIconData,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }
}

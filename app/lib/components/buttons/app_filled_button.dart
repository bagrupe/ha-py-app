import 'package:flutter/material.dart';

/// Displays the shared primary filled action button used by app workflows.
class AppFilledButton extends StatelessWidget {
  /// Creates a primary filled action button.
  const AppFilledButton({
    required this.label,
    required this.onPressed,
    this.semanticLabel,
    this.isLoading = false,
    this.trailingIcon,
    super.key,
  });

  /// Text displayed inside the button.
  final String label;

  /// Action invoked when the enabled button is pressed.
  final VoidCallback? onPressed;

  /// Accessible label announced instead of the visible text.
  final String? semanticLabel;

  /// Whether the button displays progress and blocks interaction.
  final bool isLoading;

  /// Optional icon displayed after the label.
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foregroundColor = theme.colorScheme.onPrimary;
    final height = MediaQuery.textScalerOf(
      context,
    ).scale(48).clamp(48.0, 500.0);

    return Semantics(
      button: true,
      label: semanticLabel ?? label,
      enabled: onPressed != null && !isLoading,
      excludeSemantics: true,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: foregroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: isLoading
              ? SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: foregroundColor,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: foregroundColor,
                        ),
                      ),
                    ),
                    if (trailingIcon != null) Icon(trailingIcon),
                  ],
                ),
        ),
      ),
    );
  }
}

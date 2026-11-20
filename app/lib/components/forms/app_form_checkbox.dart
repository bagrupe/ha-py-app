import 'package:app/common/design_tokens.dart';
import 'package:flutter/material.dart';

/// checkbox field with label and optional validation message.
class AppFormCheckbox extends StatelessWidget {
  /// Creates a checkbox field with label and optional validation error text.
  const AppFormCheckbox({
    required this.value,
    required this.label,
    required this.onChanged,
    this.errorText,
    super.key,
  });

  /// Whether the checkbox is checked.
  final bool value;

  /// The label displayed next to the checkbox.
  final String label;

  /// The optional validation error text shown below the checkbox.
  final String? errorText;

  /// Called when the checkbox value changes.
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = errorText != null;

    return Semantics(
      checked: value,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: value,
                isError: hasError,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                checkColor: Theme.of(context).colorScheme.onSurface,
                side: WidgetStateBorderSide.resolveWith((states) {
                  if (states.contains(WidgetState.error)) {
                    return BorderSide(color: theme.colorScheme.error);
                  }

                  return BorderSide(color: theme.colorScheme.primary);
                }),
                fillColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return DesignTokens.white;
                  }

                  return DesignTokens.gray300;
                }),
                onChanged: (newValue) => onChanged(newValue ?? false),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: DesignTokens.gray900,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 4),
              child: Text(
                errorText!,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

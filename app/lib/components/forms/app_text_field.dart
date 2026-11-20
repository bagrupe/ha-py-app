import 'package:app/common/util/text_scaling.dart';
import 'package:flutter/material.dart';

/// Reusable text field with shared app form styling.
class AppTextField extends StatelessWidget {
  /// Creates a styled app text field.
  const AppTextField({
    required this.label,
    required this.onChanged,
    this.helperText,
    this.initialValue,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.enabled = true,
    super.key,
  });

  /// The label displayed in the text field.
  final String label;

  /// The helper text displayed below the text field
  final String? helperText;

  /// The initial text value for the field.
  final String? initialValue;

  /// The optional validation error text.
  final String? errorText;

  /// The keyboard type used by the field.
  final TextInputType? keyboardType;

  /// The input action shown on the keyboard.
  final TextInputAction? textInputAction;

  /// Autofill hints for platform autofill services.
  final Iterable<String>? autofillHints;

  /// Called when the text value changes.
  final ValueChanged<String> onChanged;

  /// Whether the field can be edited. When `false`, renders read-only/greyed out — e.g. for data
  /// managed elsewhere (BundID) that the user can view but not change here.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    const borderRadius = 5.0;
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      onChanged: onChanged,
      enabled: enabled,
      decoration: InputDecoration(
        helperMaxLines: TextScaling.maxLines(context, 3),
        helperText: helperText,
        helperStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        labelText: label,
        errorMaxLines: TextScaling.maxLines(context, 5),
        errorText: errorText,
        errorStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.error,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: theme.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: scheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
      ),
    );
  }
}

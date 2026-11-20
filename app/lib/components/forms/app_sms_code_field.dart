import 'package:app/common/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

/// Six digit SMS code input with shared app form styling.
class AppSmsCodeField extends StatelessWidget {
  /// Creates the six digit SMS code input.
  const AppSmsCodeField({
    required this.onChanged,
    required this.semanticLabel,
    this.hasError = false,
    super.key,
  });

  /// Whether the field should use error styling.
  final bool hasError;

  /// Screen reader label for the grouped SMS input.
  final String semanticLabel;

  /// Called whenever the combined six digit code changes.
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final defaultPinTheme = PinTheme(
      width: 42,
      constraints: const BoxConstraints(minHeight: 42),
      padding: const EdgeInsets.symmetric(vertical: 11),
      textStyle: theme.textTheme.bodyLarge,
      decoration: BoxDecoration(
        border: Border.all(color: DesignTokens.gray300),
        borderRadius: BorderRadius.circular(5),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: theme.primaryColor),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: theme.colorScheme.error),
    );

    return Semantics(
      label: semanticLabel,
      textField: true,
      child: Pinput(
        length: 6,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        separatorBuilder: (_) => const SizedBox.shrink(),
        defaultPinTheme: defaultPinTheme,
        animationDuration: Duration.zero,
        focusedPinTheme: focusedPinTheme,
        errorPinTheme: errorPinTheme,
        forceErrorState: hasError,
        pinAnimationType: PinAnimationType.none,
        onChanged: onChanged,
      ),
    );
  }
}

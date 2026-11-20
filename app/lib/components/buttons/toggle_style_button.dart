import 'package:app/common/design_tokens.dart';
import 'package:flutter/material.dart';

/// A button styled as a toggle button, used for selections or status changes.
class ToggleStyleButton extends StatelessWidget {
  /// Creates a toggle-styled button.
  const ToggleStyleButton({
    required this.onPressed,
    required this.child,
    this.isSelected = false,
    this.minSize = const Size(48, 48),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    super.key,
  });

  /// Callback when the button is pressed. Pass `null` to disable the button.
  final VoidCallback? onPressed;

  /// The widget to display inside the button.
  final Widget child;

  /// Whether the button is currently in its selected state.
  final bool isSelected;

  /// The minimum size of the button.
  final Size minSize;

  /// The padding inside the button.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    final baseStyle = TextButton.styleFrom(
      padding: padding,
      minimumSize: minSize,
      textStyle: const TextStyle(fontWeight: FontWeight.w700),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    final selectionStyle = isSelected
        ? TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: color,
          )
        : TextButton.styleFrom(
            foregroundColor: DesignTokens.gray900,
            backgroundColor: DesignTokens.gray100,
            side: const BorderSide(color: DesignTokens.gray900),
          );

    final style = baseStyle.merge(selectionStyle);

    return TextButton(onPressed: onPressed, style: style, child: child);
  }
}

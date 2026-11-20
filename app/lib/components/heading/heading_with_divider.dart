import 'package:app/common/design_tokens.dart';
import 'package:app/common/extensions/text_theme.dart';
import 'package:flutter/material.dart';

/// Ein Widget, das eine Überschrift mit einem Trennstrich anzeigt.
/// Die Überschrift kann optional im primären Stil dargestellt werden.
class HeadingWithDivider extends StatelessWidget {
  /// Erstellt eine Überschrift mit Trennstrich.
  ///
  /// [title] ist der anzuzeigende Text der Überschrift.
  /// [primary] bestimmt, ob der primäre Textstil verwendet wird.
  const HeadingWithDivider({
    required this.title,
    super.key,
    this.primary = false,
  });

  final String title;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: primary
              ? theme.colorTextTheme.headlineSmall
              : theme.textTheme.headlineSmall,
        ),
        const Expanded(
          child: Divider(indent: 12, height: 1, color: DesignTokens.gray300),
        ),
      ],
    );
  }
}

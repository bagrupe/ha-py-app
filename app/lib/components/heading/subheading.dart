// ignore_for_file: inference_failure_on_function_return_type

import 'package:app/common/design_tokens.dart';
import 'package:flutter/material.dart';

/// Ein Widget, das eine Unterüberschrift mit optionalem Icon und Hintergrund darstellt.
class SubHeading extends StatelessWidget {
  /// Erstellt eine Unterüberschrift mit Text, optionalem Icon, Hintergrund und Abständen.
  const SubHeading(
    this.text, {
    super.key,
    this.icon,
    this.onTapIcon,
    this.background = false,
    this.margin = const EdgeInsets.only(right: 20),
    this.paddingLeft = 20,
  });

  /// Der anzuzeigende Text der Unterüberschrift.
  final String text;

  /// Ein optionales Icon, das rechts neben dem Text angezeigt wird.
  final Widget? icon;

  /// Bestimmt, ob ein Hintergrund hinter der Unterüberschrift angezeigt wird.
  final bool background;

  /// Eine optionale Funktion, die beim Tippen auf das Icon ausgeführt wird.
  final Function()? onTapIcon;

  /// Der äußere Abstand um das Widget herum.
  final EdgeInsetsGeometry margin;

  /// Der linke Innenabstand des Textes.
  final double paddingLeft;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Widget widget = Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: textTheme.headlineSmall),
    );

    final icon = this.icon;
    final onTapIcon = this.onTapIcon;

    if (icon != null) {
      final iconInnerWidget = Padding(
        padding: const EdgeInsets.all(8),
        child: icon,
      );
      final iconWidget = onTapIcon != null
          ? InkWell(onTap: onTapIcon, child: iconInnerWidget)
          : iconInnerWidget;

      widget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Align(alignment: Alignment.centerLeft, child: widget),
          ),
          iconWidget,
        ],
      );
    }

    return Padding(
      padding: margin,
      child: Material(
        color: background ? DesignTokens.gray100 : null,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            paddingLeft,
            background && icon == null ? 6 : 0,
            icon == null ? 8.0 : 0,
            background && icon == null ? 6 : 0,
          ),
          child: widget,
        ),
      ),
    );
  }
}

import 'package:app/common/design_tokens.dart';
import 'package:flutter/material.dart';

/// Ein Button mit einem Filter-Icon und Text, der eine Aktion bei Betätigung ausführt.
class FilterButton extends StatelessWidget {
  /// Erzeugt einen FilterButton mit dem angezeigten Text und der auszuführenden Funktion.
  const FilterButton({required this.text, required this.onPressed, super.key});

  /// Der anzuzeigende Text des Buttons.
  final String text;

  /// Die Funktion, die beim Drücken des Buttons ausgeführt wird.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final outlineButtonStyle = Theme.of(context).outlinedButtonTheme;
    final textTheme = Theme.of(context).textTheme;
    return OutlinedButton.icon(
      style: outlineButtonStyle.style?.copyWith(
        shadowColor: const WidgetStatePropertyAll(Colors.grey),
        backgroundColor: const WidgetStatePropertyAll(Colors.white),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        side: const WidgetStatePropertyAll(
          BorderSide(color: DesignTokens.gray300),
        ),
      ),
      label: Text(text, style: textTheme.headlineSmall),
      icon: Icon(
        Icons.filter_alt_outlined,
        color: textTheme.headlineSmall?.color,
      ),
      onPressed: onPressed,
    );
  }
}

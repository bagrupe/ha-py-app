import 'package:flutter/material.dart';

/// Ein Widget, das eine Überschrift mit optionalem horizontalem Abstand anzeigt.
class Heading extends StatelessWidget {
  /// Erstellt eine Überschrift mit dem angegebenen Text und optionalem horizontalen Abstand.
  const Heading(this.text, {super.key, this.horizontalPadding = true});

  /// Der anzuzeigende Text der Überschrift.
  final String text;

  /// Bestimmt, ob horizontaler Abstand um die Überschrift herum eingefügt wird.
  final bool horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ? 20.0 : 0,
        vertical: 16,
      ),
      child: Text(text, style: textTheme.headlineMedium),
    );
  }
}

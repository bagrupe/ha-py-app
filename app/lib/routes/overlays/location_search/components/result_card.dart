import 'package:flutter/material.dart';

/// Eine Karte, die ein beliebiges Widget als Inhalt anzeigt und ein einheitliches Design mit abgerundeten Ecken und Schatten verwendet.
class ResultCard extends StatelessWidget {
  /// Erstellt eine ResultCard mit dem angegebenen Inhalt.
  const ResultCard({required this.child, super.key});

  /// Das Widget, das innerhalb der Karte angezeigt wird.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: child,
    );
  }
}

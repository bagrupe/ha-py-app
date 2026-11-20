import 'package:flutter/material.dart';

/// Ein runder Button für Kartensteuerungen mit einem Icon.
/// Führt eine Aktion aus, wenn er gedrückt wird.
class MapControlButton extends StatelessWidget {
  /// Erstellt einen MapControlButton mit den angegebenen Eigenschaften.
  const MapControlButton({
    required this.onPressed,
    required this.icon,
    super.key,
    this.colored = false,
  });

  /// Die Funktion, die beim Drücken des Buttons ausgeführt wird.
  final VoidCallback onPressed;

  /// Das anzuzeigende Icon im Button.
  final IconData icon;

  /// Bestimmt, ob der Button farbig dargestellt wird.
  final bool colored;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: Ink(
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: CircleBorder(),
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          color: colored ? primary : null,
        ),
      ),
    );
  }
}

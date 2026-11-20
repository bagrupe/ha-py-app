import 'package:app/common/design_tokens.dart';
import 'package:flutter/material.dart';

/// Ein Button, der nur ein Icon anzeigt und eine Aktion bei Betätigung ausführt.
class IconOnlyButton extends StatelessWidget {
  /// Erstellt einen IconOnlyButton mit dem angegebenen Icon und der onPressed-Funktion.
  const IconOnlyButton({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  /// Das anzuzeigende Icon.
  final IconData icon;

  /// Die Funktion, die beim Drücken des Buttons ausgeführt wird.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Ink(
        width: 32,
        height: 32,
        decoration: ShapeDecoration(
          color: DesignTokens.gray100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          icon: Icon(icon, color: theme.primaryColor),
        ),
      ),
    );
  }
}

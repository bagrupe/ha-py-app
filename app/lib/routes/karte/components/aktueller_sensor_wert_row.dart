import 'package:app/common/design_tokens.dart';
import 'package:app/common/extensions/text_theme.dart';
import 'package:flutter/material.dart';

/// Zeigt eine Zeile mit dem aktuellen Sensorwert an.
/// Nutzt abwechselnde Hintergrundfarben zur besseren Lesbarkeit.
class AktuellerSensorWertRow extends StatelessWidget {
  /// Erstellt eine neue Zeile mit Sensorname und Wert.
  const AktuellerSensorWertRow({
    required this.name,
    required this.value,
    required this.even,
    super.key,
  });

  /// Name des Sensors oder der Messgröße.
  final String name;

  /// Aktueller Wert des Sensors als String.
  final String value;

  /// Gibt an, ob die Zeile gerade (even) ist für die Hintergrundfarbe.
  final bool even;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTextTheme = Theme.of(context).colorTextTheme;

    return ColoredBox(
      color: even ? DesignTokens.gray100 : DesignTokens.gray50,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: textTheme.bodySmall),
            Text(value, style: colorTextTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

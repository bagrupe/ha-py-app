import 'package:app/routes/antraege/common/antrag_state.dart';
import 'package:flutter/material.dart';

/// Widget zur Darstellung eines Status-Chips für einen Antrag.
/// Zeigt den Status mit passendem Icon und Farben an.
class AntragDetailStatusChip extends StatelessWidget {
  /// Erzeugt einen Status-Chip mit dem angegebenen AntragState.
  const AntragDetailStatusChip({required this.state, super.key});

  /// Der darzustellende Status des Antrags.
  final AntragState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (IconData iconData, Color fgColor, Color bgColor) = state
        .toRenderDetails(theme);

    return Chip(
      label: Text(
        state.toLabel(),
        style: theme.textTheme.titleLarge!.copyWith(color: fgColor),
      ),
      avatar: Icon(iconData, color: fgColor),
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}

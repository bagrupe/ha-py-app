// ignore_for_file: inference_failure_on_function_return_type

import 'package:app/components/heading/subheading.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:app/routes/antraege/components/schritte/abstract_schritt.dart';
import 'package:app/routes/antraege/components/schritte/formular_schritt.dart';
import 'package:app/routes/antraege/components/schritte/formular_uebersicht.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Widget zur Darstellung einer Übersicht mehrerer Schritte mit interaktiven Titeln.
/// Zeigt für jeden Schritt optional einen Titel mit Icon und die zugehörige Übersicht an.
/// Die Funktion [onTapSchritt] wird beim Tippen auf das Icon des jeweiligen Schritts aufgerufen.
class SchritteUebersicht extends StatelessWidget {
  const SchritteUebersicht({
    required this.schritte,
    required this.slots,
    required this.slotErrors,
    required this.onTapSchritt,
    super.key,
  });
  final List<SchrittData> schritte;
  final EditableSlots slots;
  final EditableSlots slotErrors;
  final Function(int) onTapSchritt;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: schritte.expandIndexed((i, schritt) {
        final widget = _getSchrittUebersicht(schritt);
        final titel = schritt.titel;
        return [
          if (titel != null) ...[
            SubHeading(
              titel,
              icon: const Icon(Icons.edit_note),
              background: true,
              onTapIcon: () => onTapSchritt(i),
            ),
            const SizedBox(height: 12),
          ],
          if (widget != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: widget,
            ),
        ];
      }).toList(),
    );
  }

  /// Liefert das passende Übersichts-Widget für den übergebenen Schritt zurück.
  /// Unterstützt aktuell nur FormularSchrittData und gibt ansonsten null zurück.
  Widget? _getSchrittUebersicht(SchrittData schritt) {
    switch (schritt) {
      case final FormularSchrittData formular:
        return FormularSchrittUebersicht(
          schritt: formular,
          slots: slots,
          slotErrors: slotErrors,
        );
    }

    return null;
  }
}

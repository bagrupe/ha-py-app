// ignore_for_file: no_default_cases

import 'package:app/routes/antraege/antrag_daten_bestaetigen.dart';
import 'package:app/routes/antraege/antrag_schritt.dart';
import 'package:app/routes/antraege/antrag_senden.dart';
import 'package:app/routes/antraege/bezahlen_schritt.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget, das basierend auf dem aktuellen Status des Antrags den passenden Schritt anzeigt.
/// Optional können für bestimmte Status eigene Widgets übergeben werden.
class AntragSchritte extends ConsumerWidget {
  /// Erstellt eine Instanz von AntragSchritte mit optionalen Status-Überschreibungen.
  const AntragSchritte({super.key, this.statusOverrides});

  /// Map zur Überschreibung der Standard-Widgets für bestimmte Antragsstatus.
  final Map<AntragClientStatus, Widget>? statusOverrides;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(antragProgressProvider)?.clientStatus;

    final override = statusOverrides?[status];
    if (override != null) return override;

    switch (status) {
      case AntragClientStatus.editing:
      case AntragClientStatus.amending:
        return const AntragSchrittPage();
      case AntragClientStatus.confirming:
        return const AntragBestaetigenPage();
      case AntragClientStatus.paying:
        return const AntragBezahlenPage();
      default:
        return const AntragSendenPage();
    }
  }
}

import 'package:app/routes/antraege/common/antrag_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget zur Darstellung eines auswählbaren Antragsprozesses in einer Liste.
/// Zeigt den Namen des Prozesses und ein Icon, das je nach Typ des Prozesses variiert.
class AntragSelectItem extends ConsumerWidget {
  /// Erzeugt ein neues Widget mit dem gegebenen Prozess.
  const AntragSelectItem({required this.prozess, super.key});

  /// Der darzustellende Prozess mit seinen Informationen.
  final ProzessOrLeistung prozess;

  /// Baut das Widget und reagiert auf Benutzerinteraktionen.
  /// Nutzt den [WidgetRef] für den Zugriff auf Provider und den [BuildContext] für UI-Kontext.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: () => startAntrag(prozess, ref, context),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(prozess.name)),
          Icon(
            prozess is AntragAuswahlServicePortalLink
                ? Icons.open_in_new
                : Icons.arrow_forward,
            color: theme.primaryColor,
          ),
        ],
      ),
    );
  }
}

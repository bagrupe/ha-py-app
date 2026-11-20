import 'package:app/components/heading/subheading.dart';
import 'package:app/graphql/__generated__/ausfuehrung.graphql.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Alias für einen Eintrag in der Ausführungs-Historie.
typedef AusfuehrungHistoriePoint =
    Query_AusfuehrungHistorie_ausfuehrung_historie;

/// Widget zur Darstellung eines einzelnen Eintrags in der Detail-Historie eines Antrags.
class AntragDetailHistorieItem extends StatelessWidget {
  /// Creates the widget for a single history entry.
  const AntragDetailHistorieItem({required this.historiePoint, super.key});

  /// Die Daten des Historieneintrags.
  final AusfuehrungHistoriePoint historiePoint;

  /// Umgibt das übergebene Widget mit einem linken schwarzen Rand.
  Widget _withLeftBorder(Widget child) {
    return DecoratedBox(
      decoration: const BoxDecoration(border: Border(left: BorderSide())),
      position: DecorationPosition.foreground,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final beschreibung = historiePoint.statusAenderungBeschreibung;
    final message = historiePoint.nachricht?.trim();
    final hasMessage = message != null && message.isNotEmpty;
    final description = Padding(
      padding: EdgeInsets.fromLTRB(
        18,
        beschreibung == null && !hasMessage ? 0 : 16,
        18,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (beschreibung != null && beschreibung.isNotEmpty)
            Text(beschreibung, style: theme.textTheme.bodySmall),
          if (hasMessage) ...[
            if (beschreibung != null && beschreibung.isNotEmpty)
              const SizedBox(height: 12),
            Text(message, style: theme.textTheme.bodySmall),
          ],
        ],
      ),
    );

    final aenderung = historiePoint.statusAenderung;
    final dateFormat = DateFormat('dd.MM.yyyy');
    final subHeading =
        '${dateFormat.format(historiePoint.createdAt)}${aenderung != null ? ' - $aenderung' : ''}';

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _withLeftBorder(
            SubHeading(subHeading, margin: EdgeInsets.zero, background: true),
          ),
          _withLeftBorder(description),
        ],
      ),
    );
  }
}

import 'package:app/common/design_tokens.dart';
import 'package:app/graphql/__generated__/maengel.graphql.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

typedef AusfuehrungHistorie = Query_Mangel_kommune_mangelAusfuehrung_historie;

/// Widget zur Darstellung der Historie eines Mangels.
/// Zeigt eine Liste von Änderungen mit Zeitstempel und Beschreibung an.
class MangelHistorie extends StatelessWidget {
  /// Erstellt ein MangelHistorie-Widget mit der übergebenen Historie.
  const MangelHistorie({required this.historie, super.key});

  /// Liste der Historieneinträge eines Mangels.
  final List<AusfuehrungHistorie> historie;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    if (historie.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: Text('Keine Historie vorhanden.')),
      );
    }

    final sortedHistorie = historie.sorted(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );

    return Container(
      margin: const EdgeInsets.all(16),
      color: DesignTokens.gray100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: sortedHistorie
              .asMap()
              .map(
                (index, h) => MapEntry(
                  index,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        index == 0 ? 'Letzte Änderung' : 'Aktualisierung',
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(h.statusAenderung ?? '', style: textTheme.bodySmall),
                      if (h.nachricht?.trim() case final message?
                          when message.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(message, style: textTheme.bodySmall),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              )
              .values
              .toList(),
        ),
      ),
    );
  }
}

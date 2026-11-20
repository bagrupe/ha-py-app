import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/heading/heading.dart';
import 'package:app/graphql/__generated__/ausfuehrung.graphql.dart';
import 'package:app/routes/antraege/common/antrag_state.dart';
import 'package:app/routes/antraege/components/antrag_detail_historie_item.dart';
import 'package:app/routes/antraege/components/antrag_detail_status_chip/antrag_detail_status_chip.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Seite zur Anzeige der Details eines Antrags anhand seiner ID.
/// Zeigt den Status, den Namen des Prozesses und die Historie des Antrags an.
class AntragDetailPage extends StatelessWidget {
  /// Erzeugt eine neue Detailseite für den Antrag mit der gegebenen ID.
  const AntragDetailPage({required this.id, super.key});

  /// Die eindeutige ID des anzuzeigenden Antrags.
  final String id;

  /// Baut die Benutzeroberfläche der Detailseite.
  /// Zeigt Ladezustand, Fehler oder die Antragsdetails mit Historie an.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const CommonAppBar(title: Text('Antrag')),
      body: Query_AusfuehrungHistorie_Widget(
        options: Options_Query_AusfuehrungHistorie(
          variables: Variables_Query_AusfuehrungHistorie(id: id),
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (result.hasException) {
            return const Center(
              child: Text(
                'Beim Abrufen der Daten ist ein Fehler aufgetreten.\n'
                'Bitte probieren Sie es später noch einmal!',
                textAlign: TextAlign.start,
              ),
            );
          }

          final ausfuehrung = result.parsedData!.ausfuehrung;
          final historie = ausfuehrung.historie;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 24),
                child: AntragDetailStatusChip(
                  state: AntragState.fromStatus(ausfuehrung.status),
                ),
              ),
              Heading(ausfuehrung.prozessVersion.prozess.name),
              if (historie.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'Es ist noch keine Historie vorhanden.',
                    style: textTheme.bodySmall,
                  ),
                )
              else
                Expanded(
                  child: ListView(
                    children: historie
                        .mapIndexed(
                          (i, e) => AntragDetailHistorieItem(
                            key: Key(i.toString()),
                            historiePoint: e,
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

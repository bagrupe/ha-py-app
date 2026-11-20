import 'package:app/components/lists/empty_state.dart';
import 'package:app/routes/termine/components/abfall/abfalltermin_card.dart';
import 'package:app/routes/termine/components/termin_card/termin_card.dart';
import 'package:app/routes/termine/termine.dart';
import 'package:app/routes/termine/veranstaltungs_termin.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Widget zur Anzeige einer Liste von Terminen, bestehend aus Veranstaltungs- und Abfallkalenderterminen.
class TermineListView extends StatelessWidget {
  /// Erstellt eine TermineListView mit den übergebenen Terminlisten.
  const TermineListView({
    required this.veranstaltungen,
    required this.abfallkalenderTermine,
    this.hasNextPage = false,
    this.isFetchingMore = false,
    super.key,
  });

  /// Liste der Veranstaltungstermine, die angezeigt werden sollen.
  final List<VeranstaltungsTermin> veranstaltungen;

  /// Liste der Abfallkalendertermine, die angezeigt werden sollen.
  final List<AbfallkalenderTermin> abfallkalenderTermine;

  /// Ob weitere Seiten verfügbar sind.
  final bool hasNextPage;

  /// Ob gerade weitere Daten geladen werden.
  final bool isFetchingMore;

  @override
  Widget build(BuildContext context) {
    final abfallkalenderAndVeranstaltungsTermine =
        [...veranstaltungen, ...abfallkalenderTermine]
          ..sortBy<DateTime>((element) {
            if (element is AbfallkalenderTermin) {
              return DateTime.parse(element.datum);
            } else if (element is VeranstaltungsTermin) {
              return element.start;
            } else {
              return DateTime.now();
            }
          });

    if (abfallkalenderAndVeranstaltungsTermine.isEmpty) {
      return const ListEmptyState(
        message: 'Mit dem aktuellen Filter wurden keine Termine gefunden',
      );
    }

    final itemCount =
        abfallkalenderAndVeranstaltungsTermine.length +
        (hasNextPage || isFetchingMore ? 1 : 0);

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == abfallkalenderAndVeranstaltungsTermine.length) {
          return const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final termin = abfallkalenderAndVeranstaltungsTermine[index];
        final nextWidget = termin is VeranstaltungsTermin
            ? _TerminCard(termin: termin)
            : termin is AbfallkalenderTermin
            ? _AbfallTerminCard(termin: termin)
            : const SizedBox();

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: nextWidget,
        );
      },
    );
  }
}

class _AbfallTerminCard extends StatelessWidget {
  const _AbfallTerminCard({required this.termin});

  final AbfallkalenderTermin termin;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE - dd.MM.yyyy');
    final startDate = DateTime.parse(termin.datum);

    return AbfallTerminCard(
      title: termin.fraktion,
      teaser: termin.turnus,
      date: dateFormat.format(startDate),
    );
  }
}

class _TerminCard extends StatelessWidget {
  const _TerminCard({required this.termin});

  final VeranstaltungsTermin termin;

  @override
  Widget build(BuildContext context) {
    return TerminCard(
      termin: termin,
      onTap: () {
        context.push('/termine/${termin.veranstaltungsId}', extra: termin);
      },
    );
  }
}

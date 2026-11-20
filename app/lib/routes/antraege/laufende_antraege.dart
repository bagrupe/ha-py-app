import 'package:app/common/ausfuehrungen_provider.dart';
import 'package:app/components/heading/heading.dart';
import 'package:app/components/lists/empty_state.dart';
import 'package:app/components/lists/error_state.dart';
import 'package:app/components/lists/loading_state.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/__generated__/schritte.graphql.dart';
import 'package:app/routes/antraege/common/antrag_meta.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:app/routes/antraege/common/antrag_state.dart';
import 'package:app/routes/antraege/components/antrag_card/antrag_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Widget zur Anzeige der laufenden Anträge des Nutzers.
/// Zeigt eine Liste der Anträge mit Status und ermöglicht Navigation zu Details oder Fortsetzung.
class LaufendeAntraege extends ConsumerWidget {
  const LaufendeAntraege({super.key});

  /// Öffnet die Detailseite eines Antrags oder setzt den Antrag fort, falls er in Bearbeitung ist.
  /// [a] ist die Ausführung des Antrags, [context] der Build-Kontext, [ref] der Provider-Referenz.
  Future<void> _showDetailOrContinue(
    Query_Ausfuehrungen_my__Buerger_ausfuehrungen a,
    BuildContext context,
    WidgetRef ref,
  ) async {
    if (a.status != Enum_AusfuehrungStatus.BEARBEITUNG_DURCH_BUERGER) {
      await context.push('/antraege/detail/${a.id}');
    } else {
      final progress = ref.read(antragProgressProvider.notifier);
      await progress.continueAusfuehrung(id: a.id);

      ref
          .read(antragMetaProvider.notifier)
          .setMeta(
            const AntragMeta(
              'Anträge',
              'Erfolgreich abgesendet!',
              'Antrag fortsetzen',
              '/antraege',
            ),
          );
      if (context.mounted) {
        context.replace('/antraege/schritt');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ausfuehrungenProvider = ref.watch(ausfuehrungProvider);
    return ausfuehrungenProvider.when(
      data: (ausfuehrungen) {
        if (ausfuehrungen.isEmpty) {
          return const ListEmptyState(
            message: 'Noch keine Anträge abgeschickt',
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Heading('Laufende Anträge'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RefreshIndicator(
                  onRefresh: () => ref.refresh(ausfuehrungProvider.future),
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: ausfuehrungen.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final a = ausfuehrungen[index];
                      return AntragCard(
                        id: a.id,
                        state: AntragState.fromStatus(a.status),
                        title: a.prozessVersion.prozess.name,
                        lastChange: a.updatedAt,
                        onTap: () => _showDetailOrContinue(a, context, ref),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
      error: (error, stack) => ListErrorState(
        message: 'Fehler beim Laden der Daten.',
        onRetry: () => ref.invalidate(ausfuehrungProvider),
      ),
      loading: () => const ListLoadingState(),
    );
  }
}

import 'package:app/common/kommune.dart';
import 'package:app/components/html_rich_text.dart';
import 'package:app/graphql/__generated__/karten_lizenzen.graphql.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Dialogfenster zur Anzeige von Lizenzinformationen für Karten.
/// Nutzt eine GraphQL-Abfrage, um die Lizenzen der aktuellen Kommune zu laden.
class KartenLizenzDialog extends ConsumerWidget {
  const KartenLizenzDialog({super.key});

  /// Baut das Widget und führt die Abfrage der Kartenlizenzen aus.
  /// Zeigt die Lizenzinformationen in einem AlertDialog an.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kommuneId = ref.watch(kommuneProvider).requireValue.bereichAId;

    return Query_Kartenlizenzen_Widget(
      options: Options_Query_Kartenlizenzen(
        variables: Variables_Query_Kartenlizenzen(kommuneId: kommuneId),
      ),
      builder: (result, {fetchMore, refetch}) {
        return AlertDialog(
          title: const Text('Lizenzinformationen'),
          content: SingleChildScrollView(
            child: HtmlRichText(
              html:
                  result.parsedData?.kommune.lizenzen.kartenlizenzenHtml ?? '',
              textSizeModifier: 0.75,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Schließen'),
            ),
          ],
        );
      },
    );
  }
}

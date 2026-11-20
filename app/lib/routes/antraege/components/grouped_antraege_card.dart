import 'package:app/common/design_tokens.dart';
import 'package:app/common/extensions/iterable.dart';
import 'package:app/routes/antraege/common/antrag_select.dart';
import 'package:app/routes/antraege/components/antrag_select_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Widget zur gruppierten Darstellung mehrerer Anträge mit einem Titel.
/// Zeigt eine Vorschau der Anträge und ermöglicht das Navigieren zu einer Detailübersicht.
class GroupedAntraegeCard extends ConsumerWidget {
  /// Erzeugt eine neue Instanz mit Titel und Liste von Prozessen.
  const GroupedAntraegeCard({
    required this.title,
    required this.prozesse,
    super.key,
  });

  /// Titel der Gruppe, die über den Anträgen angezeigt wird.
  final String title;

  /// Liste der anzuzeigenden Prozesse oder Leistungen.
  final List<ProzessOrLeistung> prozesse;

  static const double borderRadius = 8;
  static const double borderWidth = 1;

  /// Baut das Widget mit dekoriertem Rahmen, Titel und einer Vorschau der Anträge.
  /// Bei Klick auf "Weitere Anträge" wird zur Detailseite navigiert.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    const padding = 15.0;

    final subListProzesse = prozesse.sublist(
      0,
      prozesse.length <= 2 ? prozesse.length : 3,
    );

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: DesignTokens.gray300),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(borderRadius)),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: DesignTokens.gray100,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(padding),
                        child: Text(
                          title,
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                    ),
                    ...subListProzesse
                        .map<Widget>((p) => AntragSelectItem(prozess: p))
                        .joinWithElement(
                          const SizedBox(
                            height: 1,
                            width: double.infinity,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: DesignTokens.gray100,
                              ),
                            ),
                          ),
                        ),
                    InkWell(
                      onTap: () => {
                        context.push(
                          '/antraege/antrag-subgroup-select',
                          extra: (title, prozesse),
                        ),
                      },
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: DesignTokens.gray100,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(padding),
                          child: Align(
                            child: Text(
                              'Weitere Anträge',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

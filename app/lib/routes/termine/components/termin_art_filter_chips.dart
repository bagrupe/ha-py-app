import 'package:app/common/abfall/abfall_filter.dart';
import 'package:app/common/abfall/abfall_provider.dart';
import 'package:app/common/design_tokens.dart';
import 'package:app/common/extensions/text_theme.dart';
import 'package:app/common/kommune.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/routes/termine/common/model/termin_art_filter_type.dart';
import 'package:app/routes/termine/common/termine_provider.dart';
import 'package:app/routes/termine/components/abfall/abfall_filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget zur Anzeige einer horizontalen Liste von Filter-Chips zur Auswahl der Terminart.
class TerminArtFilterChips extends ConsumerWidget {
  const TerminArtFilterChips({super.key});

  /// Baut die Filter-Chips basierend auf der aktuellen Kommune und den gespeicherten Einstellungen.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kommune = ref.watch(kommuneProvider).value;
    final prefs = ref.watch(sharedPreferencesProvider);
    final standortId = ref.watch(abfallConfigProvider).filter.standort;

    if (kommune == null) return const SizedBox.shrink();
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero,
      children: [
        TerminArtFilterChip(
          label: 'Alle',
          filterType: TerminArtFilterType.alle,
          onPressed: () => ref.read(terminArtFilterProvider.notifier).state =
              TerminArtFilterType.alle,
        ),
        if (kommune.abfallkalenderEnabled) ...[
          const SizedBox(width: 12),
          TerminArtFilterChip(
            label: 'Abfall',
            filterType: TerminArtFilterType.abfall,
            onPressed: () {
              ref.read(terminArtFilterProvider.notifier).state =
                  TerminArtFilterType.abfall;

              if (standortId?.isEmpty ?? true) {
                showModalBottomSheet<String?>(
                  isScrollControlled: true,
                  enableDrag: false,
                  isDismissible: false,
                  useSafeArea: true,
                  context: context,
                  builder: (context) {
                    return AbfallFilterSheet(
                      onConfirm: (String nextFilter) {
                        prefs.setString(AbfallFilterKeys.ortId, nextFilter);
                        Navigator.pop(context);
                      },
                      onCancel: () => Navigator.pop(context),
                    );
                  },
                );
              }
            },
          ),
          const SizedBox(width: 12),
          TerminArtFilterChip(
            label: 'Veranstaltungen',
            filterType: TerminArtFilterType.veranstaltung,
            onPressed: () => ref.read(terminArtFilterProvider.notifier).state =
                TerminArtFilterType.veranstaltung,
          ),
        ],
      ],
    );
  }
}

/// Einzelner Filter-Chip zur Auswahl einer Terminart mit visuellem Zustand und Callback.
class TerminArtFilterChip extends ConsumerWidget {
  /// Erstellt einen TerminArtFilterChip mit Beschriftung, Filtertyp und Callback.
  const TerminArtFilterChip({
    required this.label,
    required this.filterType,
    required this.onPressed,
    super.key,
  });

  /// Beschriftung des Chips.
  final String label;

  /// Zugehöriger Filtertyp des Chips.
  final TerminArtFilterType filterType;

  /// Callback, der beim Drücken des Chips ausgeführt wird.
  final VoidCallback onPressed;

  /// Baut den Chip mit entsprechender Hintergrundfarbe und Textstil je nach aktivem Filter.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentActiveFiler = ref.watch(terminArtFilterProvider);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: currentActiveFiler == filterType
            ? theme.primaryColorLight
            : DesignTokens.gray100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: currentActiveFiler == filterType
              ? theme.colorTextTheme.bodySmall
              : theme.textTheme.bodySmall,
        ),
      ),
    );
  }
}

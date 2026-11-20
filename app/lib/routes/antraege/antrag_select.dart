import 'package:app/common/extensions/iterable.dart';
import 'package:app/components/lists/error_state.dart';
import 'package:app/components/lists/loading_state.dart';
import 'package:app/components/searchbar/searchbar.dart';
import 'package:app/routes/antraege/antrag_select_provider.dart';
import 'package:app/routes/antraege/common/antrag_select.dart';
import 'package:app/routes/antraege/components/antrag_list_view.dart';
import 'package:app/routes/antraege/components/grouped_antraege_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget for selecting an application, with search and grouped display.
/// Loads the municipality's available processes/services via
/// [antragSelectionProvider] and shows them grouped or filtered.
class AntragSelect extends ConsumerStatefulWidget {
  const AntragSelect({super.key});

  @override
  ConsumerState<AntragSelect> createState() => _AntragSelectPageState();
}

class _AntragSelectPageState extends ConsumerState<AntragSelect> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final antragSelection = ref.watch(antragSelectionProvider);

    return switch (antragSelection) {
      AsyncData(:final value) => _buildContent(theme, value),
      AsyncError() => ListErrorState(
        message: 'application.error.error_loading'.tr(),
        onRetry: () => ref.invalidate(antragSelectionProvider),
      ),
      _ => const ListLoadingState(),
    };
  }

  Widget _buildContent(ThemeData theme, AntragSelectionList antragSelection) {
    final prozesse = antragSelection.items
        .where(
          (prozess) => prozess is! AntragAuswahlProzess || prozess.tags.isEmpty,
        )
        .toList();

    final groupedProzesse = <String, List<ProzessOrLeistung>>{};
    for (final group in antragSelection.groups) {
      final prozesseInGroup = prozesse
          .where((p) => p.group?.name == group.name)
          .toList();

      if (prozesseInGroup.isNotEmpty) {
        groupedProzesse[group.name] = prozesseInGroup;
      }
    }

    final filteredProzesse = prozesse.where(
      (p) => p.name.toLowerCase().contains(searchText.toLowerCase()),
    );

    return RefreshIndicator(
      onRefresh: ref.read(antragSelectionProvider.notifier).reload,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Was möchten Sie beantragen?',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                Searchbar(
                  value: searchText,
                  onChanged: (text) => setState(() => searchText = text),
                ),
                const SizedBox(height: 24),
                if (searchText.isEmpty)
                  ...groupedProzesse.entries
                      .map<Widget>(
                        (entry) => GroupedAntraegeCard(
                          title: entry.key,
                          prozesse: entry.value,
                        ),
                      )
                      .joinWithElement(const SizedBox(height: 20)),
                if (searchText.isNotEmpty)
                  filteredProzesse.isNotEmpty
                      ? ListViewAntraege(prozesse: filteredProzesse)
                      : const Align(
                          child: Text('Keine passenden Anträge gefunden'),
                        ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

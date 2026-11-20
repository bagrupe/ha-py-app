// ignore_for_file: inference_failure_on_function_return_type

import 'package:app/common/design_tokens.dart';
import 'package:app/common/gemeinde_prefs.dart';
import 'package:app/common/kommune.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/components/heading/heading.dart';
import 'package:app/graphql/__generated__/veranstaltungskalender-filter.graphql.dart';
import 'package:app/routes/termine/common/termine_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String selectedCategoriesPrefsKey = 'selectedVeranstaltungsKategorien';
const String selectedDateRangePrefsKey = 'selectedDateRangePrefsKey';

class VeranstaltungFilterSheet extends ConsumerStatefulWidget {
  const VeranstaltungFilterSheet({required this.onCancel, super.key});
  final Function() onCancel;

  @override
  ConsumerState<VeranstaltungFilterSheet> createState() =>
      _VeranstaltungFilterSheetState();
}

class _VeranstaltungFilterSheetState
    extends ConsumerState<VeranstaltungFilterSheet> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final kommune = ref.watch(kommuneProvider).value;
    final kommuneBereichBId = kommune?.bereichBId;
    final kommuneBereichAId = kommune?.bereichAId;
    final prefs = ref.watch(sharedPreferencesProvider);
    final gemeinden = ref.watch(gemeindeFilterProvider).currentGemeindePrefs;
    final tempGemeinden = ref.watch(tempGemeindeProvider);
    final categories = prefs.getStringList(selectedCategoriesPrefsKey) ?? [];

    if (kommuneBereichBId == null || kommuneBereichAId == null) {
      return const SizedBox.shrink();
    }

    return Query_VeranstaltungskalenderFilter_Widget(
      options: Options_Query_VeranstaltungskalenderFilter(
        variables: Variables_Query_VeranstaltungskalenderFilter(
          kommuneId: kommuneBereichBId,
          kommuneBereichAId: kommuneBereichAId,
        ),
      ),
      builder: (result, {fetchMore, refetch}) {
        final theme = Theme.of(context);

        if (result.isLoading) return const SizedBox(height: 12);

        final parsedData = result.parsedData!;

        final availableCategories =
            parsedData.veranstaltungskalenderKategories?.docs ?? [];
        final availableGemeinden = parsedData.kommune.untereinheiten;
        final maybeSelectedDateRange =
            prefs.getStringList(selectedDateRangePrefsKey) ?? [];
        final dateTimeRange = maybeSelectedDateRange.isNotEmpty
            ? DateTimeRange(
                start: DateTime.parse(maybeSelectedDateRange[0]),
                end: DateTime.parse(maybeSelectedDateRange[1]),
              )
            : null;

        final initialSelectedCategories = availableCategories
            .where((c) => categories.contains(c.id))
            .map((c) => c.id)
            .toList();

        final initialSelectedGemeinden = availableGemeinden
            .where((c) => gemeinden.contains(c.id))
            .map((c) => c.id)
            .toList();

        final initialSelectedTempGemeinden = availableGemeinden
            .where((c) => tempGemeinden.contains(c.id))
            .map((c) => c.id)
            .toList();

        return Material(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Heading('Filter'),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: IconButton(
                        onPressed: () => widget.onCancel(),
                        icon: const Icon(
                          Icons.close,
                          color: DesignTokens.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(width: 8),
                      FormBuilder(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kategorien',
                              style: theme.textTheme.headlineSmall,
                            ),
                            FormBuilderCheckboxGroup(
                              wrapAlignment: WrapAlignment.spaceBetween,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              name: selectedCategoriesPrefsKey,
                              initialValue: initialSelectedCategories,
                              options: availableCategories.nonNulls.map((c) {
                                return FormBuilderFieldOption(
                                  value: c.id,
                                  child: Row(children: [Text(c.label)]),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                            FormBuilderDateRangePicker(
                              initialValue: dateTimeRange,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 180),
                              ),
                              name: selectedDateRangePrefsKey,
                              clearIcon: const Icon(Icons.clear),
                              decoration: const InputDecoration(
                                hintText: 'Zeitraum auswählen',
                                isDense: true,
                                suffixIcon: Icon(Icons.calendar_month),
                                label: Text('Datum'),
                              ),
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                _formKey
                                    .currentState
                                    ?.fields[selectedDateRangePrefsKey]
                                    ?.didChange(null);
                              },
                              child: Text(
                                'Datumsfilter zurücksetzen',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Gemeinden',
                              style: theme.textTheme.headlineSmall,
                            ),
                            FormBuilderCheckboxGroup(
                              wrapAlignment: WrapAlignment.spaceBetween,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              initialValue:
                                  initialSelectedTempGemeinden.isNotEmpty
                                  ? initialSelectedTempGemeinden
                                  : initialSelectedGemeinden,
                              name: selectedGemeindeFilterPrefKey,
                              options: availableGemeinden.nonNulls.map((s) {
                                return FormBuilderFieldOption(
                                  value: s.id,
                                  child: Row(children: [Text(s.name)]),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          final maybeSelectedCategories = _formKey
                              .currentState
                              ?.fields[selectedCategoriesPrefsKey]
                              ?.value;

                          final nextSelectedCategories =
                              switch (maybeSelectedCategories) {
                                List<String?>() =>
                                  maybeSelectedCategories.nonNulls.toList(),
                                _ => <String>[],
                              };

                          prefs.setStringList(
                            selectedCategoriesPrefsKey,
                            nextSelectedCategories,
                          );

                          final maybeSelectedGemeinden = _formKey
                              .currentState
                              ?.fields[selectedGemeindeFilterPrefKey]
                              ?.value;

                          final nextSelectedTempGemeinden =
                              switch (maybeSelectedGemeinden) {
                                List<String?>() =>
                                  maybeSelectedGemeinden.nonNulls.toList(),
                                _ => <String>[],
                              };

                          ref.read(tempGemeindeProvider.notifier).state =
                              nextSelectedTempGemeinden;

                          final maybeDateRange = _formKey
                              .currentState
                              ?.fields[selectedDateRangePrefsKey]
                              ?.value;

                          final nextSelectedDateRange =
                              switch (maybeDateRange) {
                                DateTimeRange() => [
                                  maybeDateRange.start.toString(),
                                  maybeDateRange.end
                                      .add(
                                        const Duration(hours: 23, minutes: 59),
                                      )
                                      .toString(),
                                ].nonNulls.toList(),
                                _ => <String>[],
                              };

                          prefs.setStringList(
                            selectedDateRangePrefsKey,
                            nextSelectedDateRange,
                          );

                          Navigator.pop(context);
                        },
                        child: const Text('Filter Übernehmen'),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

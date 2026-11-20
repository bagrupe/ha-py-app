// ignore_for_file: inference_failure_on_function_return_type

import 'package:app/common/abfall/abfall_benachrichtigungen.dart';
import 'package:app/common/abfall/abfall_filter.dart';
import 'package:app/common/kommune.dart';
import 'package:app/graphql/__generated__/termine.graphql.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget zur Anzeige und Verwaltung des Filters für Abfalltermine.
/// Nimmt initiale Filter- und Benachrichtigungseinstellungen entgegen und gibt bei Bestätigung die neuen Werte zurück.
class AbfallTermineFilter extends ConsumerStatefulWidget {
  const AbfallTermineFilter({
    required this.initialFilter,
    required this.onConfirm,
    required this.initialBenachrichtigungen,
    super.key,
  });
  final Function(
    AbfallFilter nextFilter,
    AbfallBenachrichtigungen nextBenachrichtigungen,
  )
  onConfirm;
  final AbfallFilter initialFilter;
  final AbfallBenachrichtigungen initialBenachrichtigungen;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AbfallTermineFilterState();
}

class _AbfallTermineFilterState extends ConsumerState<AbfallTermineFilter> {
  @override
  Widget build(BuildContext context) {
    return TermineFilterForm(
      widget.initialFilter,
      widget.onConfirm,
      widget.initialBenachrichtigungen,
    );
  }
}

/// Formular-Widget zur detaillierten Eingabe der Filterkriterien für Abfalltermine.
/// Verwendet ValueNotifier zur Verwaltung der Eingabewerte und gibt bei Bestätigung die aktualisierten Filter zurück.
class TermineFilterForm extends ConsumerStatefulWidget {
  const TermineFilterForm(
    this.initialFilter,
    this.onConfirm,
    this.initialBenachrichtigungen, {
    super.key,
  });
  final Function(
    AbfallFilter nextFilter,
    AbfallBenachrichtigungen nextBenachrichtigungen,
  )
  onConfirm;

  final AbfallFilter initialFilter;
  final AbfallBenachrichtigungen initialBenachrichtigungen;

  @override
  ConsumerState<TermineFilterForm> createState() =>
      _AbfallTermineFilterFormState();
}

class _AbfallTermineFilterFormState extends ConsumerState<TermineFilterForm> {
  @override
  void initState() {
    final initialValue = widget.initialFilter;
    _ortId = ValueNotifier<String?>(initialValue.ort);
    _anfangsbuchstabe = ValueNotifier<String?>(initialValue.anfangsbuchstabe);
    _strassenId = ValueNotifier<String?>(initialValue.strasse);
    _standortId = ValueNotifier<String?>(initialValue.standort);
    _fraktionen = ValueNotifier<String?>(initialValue.fraktionen);
    _benachrichtigungEnabled = ValueNotifier<bool?>(
      widget.initialBenachrichtigungen.enabled,
    );
    super.initState();
  }

  ValueNotifier<String?> _ortId = ValueNotifier<String>('');
  ValueNotifier<String?> _anfangsbuchstabe = ValueNotifier<String>('');
  ValueNotifier<String?> _strassenId = ValueNotifier<String>('');
  ValueNotifier<String?> _standortId = ValueNotifier<String>('');
  ValueNotifier<String?> _fraktionen = ValueNotifier<String>('');
  ValueNotifier<bool?> _benachrichtigungEnabled = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    final kommune = ref.watch(kommuneProvider).value;
    final theme = Theme.of(context);
    if (kommune == null) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ValueListenableBuilder(
          valueListenable: _standortId,
          builder: (context, value, child) {
            if (value?.isEmpty ?? true) return const SizedBox.shrink();
            return Query_AbfallkalenderFraktionen_Widget(
              options: Options_Query_AbfallkalenderFraktionen(
                variables: Variables_Query_AbfallkalenderFraktionen(
                  kommuneId: kommune.bereichAId,
                  standortId: value ?? '',
                ),
              ),
              builder: (result, {fetchMore, refetch}) {
                if (result.isLoading) {
                  return const SizedBox(height: 12);
                }
                final activateAll =
                    widget.initialFilter.standort == null ||
                    widget.initialFilter.fraktionen == null;

                if (activateAll) {
                  _fraktionen.value = result.parsedData?.kommune.fraktionen
                      .map((e) => e.id)
                      .join(',');
                }

                return ValueListenableBuilder<String?>(
                  valueListenable: _fraktionen,
                  builder: (context, currentFraktionene, child) {
                    return Column(
                      children: [
                        ...?result.parsedData?.kommune.fraktionen.map((e) {
                          return CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            value:
                                currentFraktionene?.split(',').contains(e.id) ??
                                false,
                            title: Text(e.name),
                            onChanged: (nextValue) {
                              final checkedKeys = currentFraktionene?.split(
                                ',',
                              );
                              if (checkedKeys?.contains(e.id) ?? false) {
                                checkedKeys?.remove(e.id);
                              } else {
                                checkedKeys?.add(e.id);
                              }
                              _fraktionen.value = checkedKeys?.join(',');
                            },
                          );
                        }),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Individuelle Termine der Abfuhr für Ihre Adresse.',
            style: theme.textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 32),
        Query_AbfallkalenderOrte_Widget(
          options: Options_Query_AbfallkalenderOrte(
            variables: Variables_Query_AbfallkalenderOrte(
              kommuneId: kommune.bereichAId,
            ),
          ),
          builder: (result, {fetchMore, refetch}) {
            return FormBuilderDropdown<String>(
              initialValue: result.isLoading ? null : _ortId.value,
              decoration: const InputDecoration(
                label: Text('Ort'),
                hintText: 'Bitte wählen Sie Ihre Gemeinde aus',
              ),
              onChanged: (nextValue) {
                _ortId.value = nextValue;
                _anfangsbuchstabe.value = null;
                _strassenId.value = null;
                _standortId.value = null;
              },
              name: 'Ort',
              items:
                  result.parsedData?.kommune.orte
                      .map(
                        (e) =>
                            DropdownMenuItem(value: e.id, child: Text(e.name)),
                      )
                      .toList() ??
                  [],
            );
          },
        ),
        const SizedBox(height: 18),
        ValueListenableBuilder<String?>(
          valueListenable: _ortId,
          builder: (context, value, child) {
            return Query_AbfallkalenderStrassen_Widget(
              options: Options_Query_AbfallkalenderStrassen(
                variables: Variables_Query_AbfallkalenderStrassen(
                  kommuneId: kommune.bereichAId,
                  ortId: value ?? '',
                ),
              ),
              builder: (result, {fetchMore, refetch}) {
                return FormBuilderDropdown<String>(
                  initialValue: result.isLoading
                      ? null
                      : _anfangsbuchstabe.value,
                  decoration: const InputDecoration(
                    label: Text('Anfangsbuchstabe Ihrer Straße'),
                    hintText: 'Anfangsbuchstabe Ihrer Straße',
                  ),
                  name: 'Anfangsbuchstabe Ihrer Straße',
                  items:
                      result.parsedData?.kommune.strassen
                          .map((e) => e.name[0])
                          .toSet()
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList() ??
                      [],
                  onChanged: (nextValue) {
                    _anfangsbuchstabe.value = nextValue;
                    _strassenId.value = null;
                    _standortId.value = null;
                  },
                );
              },
            );
          },
        ),
        const SizedBox(height: 18),
        ValueListenableBuilder<String?>(
          valueListenable: _anfangsbuchstabe,
          builder: (context, value, child) {
            return Query_AbfallkalenderStrassen_Widget(
              options: Options_Query_AbfallkalenderStrassen(
                variables: Variables_Query_AbfallkalenderStrassen(
                  kommuneId: kommune.bereichAId,
                  ortId: _ortId.value ?? '',
                ),
              ),
              builder: (result, {fetchMore, refetch}) {
                final filteredStrassen =
                    result.parsedData?.kommune.strassen
                        .where(
                          (e) =>
                              e.name.startsWith(_anfangsbuchstabe.value ?? ''),
                        )
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.id,
                            child: Text(e.name),
                          ),
                        )
                        .toList() ??
                    [];
                return FormBuilderDropdown<String>(
                  initialValue: result.isLoading ? null : _strassenId.value,
                  name: 'Straße',
                  decoration: const InputDecoration(
                    label: Text('Straße'),
                    hintText: 'Bitte wählen Sie Ihre Straße aus',
                  ),
                  items: filteredStrassen,
                  onChanged: (nextValue) {
                    _strassenId.value = nextValue;
                    _standortId.value = null;
                  },
                );
              },
            );
          },
        ),
        const SizedBox(height: 18),
        ValueListenableBuilder(
          valueListenable: _strassenId,
          builder: (context, value, child) {
            return Query_AbfallkalenderStandorte_Widget(
              options: Options_Query_AbfallkalenderStandorte(
                variables: Variables_Query_AbfallkalenderStandorte(
                  kommuneId: kommune.bereichAId,
                  strassenId: _strassenId.value ?? '',
                ),
              ),
              builder: (result, {fetchMore, refetch}) {
                return FormBuilderDropdown<String>(
                  initialValue: result.isLoading ? null : _standortId.value,
                  decoration: const InputDecoration(
                    label: Text('Hausnummer'),
                    hintText: 'Bitte wählen Sie Ihre Hausnummer aus',
                  ),
                  name: 'Hausnummer',
                  items:
                      result.parsedData?.kommune.standorte
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.nr),
                            ),
                          )
                          .toList() ??
                      [],
                  onChanged: (nextValue) {
                    _standortId.value = nextValue;
                  },
                );
              },
            );
          },
        ),
        const SizedBox(height: 18),
        ValueListenableBuilder(
          valueListenable: _standortId,
          builder: (context, value, child) {
            return ValueListenableBuilder(
              valueListenable: _benachrichtigungEnabled,
              builder: (context, value, child) {
                return CheckboxListTile(
                  value: value ?? false,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Benachrichtigungen erhalten'),
                  onChanged: (nextValue) {
                    _benachrichtigungEnabled.value = nextValue;
                  },
                );
              },
            );
          },
        ),
        const SizedBox(height: 18),
        ValueListenableBuilder(
          valueListenable: _standortId,
          builder: (context, value, child) {
            return OutlinedButton(
              onPressed: value == null || value.isEmpty
                  ? null
                  : () => widget.onConfirm(
                      AbfallFilter(
                        ort: _ortId.value,
                        anfangsbuchstabe: _anfangsbuchstabe.value,
                        strasse: _strassenId.value,
                        standort: _standortId.value,
                        fraktionen: _fraktionen.value,
                      ),
                      widget.initialBenachrichtigungen.copyWith(
                        enabled: _benachrichtigungEnabled.value ?? false,
                      ),
                    ),
              child: const Text('Filter Übernehmen'),
            );
          },
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}

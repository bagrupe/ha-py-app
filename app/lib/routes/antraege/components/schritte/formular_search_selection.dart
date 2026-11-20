part of 'formular_schritt.dart';

/// Provides search selection for a form step.
extension _FormularSearchSelection on FormularSchritt {
  void _syncSearchSelectionsToForm() {
    final form = _formKey.currentState;
    if (form == null || _searchSelections.isEmpty) return;

    _inCleanup = true;
    try {
      for (final selection in _searchSelections.values) {
        for (final step in selection.steps) {
          form.setInternalFieldValue(step.field.slotName, step.option.key);
        }
      }
    } finally {
      _inCleanup = false;
    }
  }

  Map<String, dynamic> _valuesWithSearchSelections(
    Map<String, dynamic> values,
  ) {
    final effectiveValues = Map<String, dynamic>.from(values);
    for (final selection in _searchSelections.values) {
      for (final step in selection.steps) {
        effectiveValues[step.field.slotName] = step.option.key;
      }
    }
    return effectiveValues;
  }

  void _discardInvalidSearchSelections() {
    final values = _formKey.currentState?.instantValue;
    if (values == null) return;

    final invalidRoots = _searchSelections.entries
        .where(
          (entry) => !entry.value.steps.every(
            (step) => values[step.field.slotName] == step.option.key,
          ),
        )
        .map((entry) => entry.key)
        .toList();
    for (final rootSlot in invalidRoots) {
      _searchSelections.remove(rootSlot);
      _clearPersistedSearchSelection(
        rootSlot,
        _prozessVersionId,
        _searchSelectionNotifier,
      );
    }
  }

  void _applySearchResult(
    CascadeEntry entry,
    EvaluatingVisitorService evaluatingVisitor,
    String? prozessVersionId,
    SearchCategorySelectionNotifier? searchSelectionNotifier,
  ) {
    final form = _formKey.currentState!;
    _relevanzDebounce?.cancel();
    _inCleanup = true;
    try {
      for (final step in entry.steps) {
        final registeredField = form.fields[step.field.slotName];
        if (registeredField != null) {
          registeredField.didChange(step.option.key);
        } else {
          form.setInternalFieldValue(step.field.slotName, step.option.key);
        }
      }
    } finally {
      _inCleanup = false;
    }
    final rootSlot = entry.steps.first.field.slotName;
    _searchSelections[rootSlot] = entry;
    if (prozessVersionId != null && searchSelectionNotifier != null) {
      searchSelectionNotifier.setSelection(
        _selectionKey(prozessVersionId, rootSlot),
        {for (final step in entry.steps) step.field.slotName: step.option.key},
      );
    }
    _letzteTriggerWerte = _triggerValuesKey(form.instantValue);
    _letzteFormWerte = Map<String, dynamic>.from(form.instantValue);
    unawaited(_updateRelevance(evaluatingVisitor));
  }

  CascadeEntry? _activeSearchSelection(
    String rootSlot,
    Map<String, dynamic> slots,
  ) {
    final selection = _searchSelections[rootSlot];
    if (selection == null) return null;
    final stillSelected = selection.steps.every(
      (step) => slots[step.field.slotName] == step.option.key,
    );
    if (stillSelected) return selection;
    _searchSelections.remove(rootSlot);
    return null;
  }
}

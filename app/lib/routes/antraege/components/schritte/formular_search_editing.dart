part of 'formular_schritt.dart';

/// Provides search editing for a form step.
extension _FormularSearchEditing on FormularSchritt {
  void _editSearchSelection(
    String rootSlot,
    String? prozessVersionId,
    SearchCategorySelectionNotifier? searchSelectionNotifier,
  ) {
    final selection = _searchSelections.remove(rootSlot);
    final form = _formKey.currentState;
    if (selection != null && form != null) {
      _inCleanup = true;
      try {
        for (final step in selection.steps) {
          form.setInternalFieldValue(step.field.slotName, step.option.key);
        }
      } finally {
        _inCleanup = false;
      }
    }
    _clearPersistedSearchSelection(
      rootSlot,
      prozessVersionId,
      searchSelectionNotifier,
    );
    if (form != null) _stream.add(form.instantValue);
  }

  void _clearSearchSelection(
    String rootSlot,
    CascadeEntry selection,
    String? prozessVersionId,
    SearchCategorySelectionNotifier? searchSelectionNotifier,
  ) {
    final form = _formKey.currentState;
    if (form == null) return;

    _relevanzDebounce?.cancel();
    _searchSelections.remove(rootSlot);
    _clearPersistedSearchSelection(
      rootSlot,
      prozessVersionId,
      searchSelectionNotifier,
    );
    _inCleanup = true;
    try {
      for (final step in selection.steps.reversed) {
        FormularSchritt._clearFormValue(form, step.field.slotName);
      }
    } finally {
      _inCleanup = false;
    }
    _letzteTriggerWerte = _triggerValuesKey(form.instantValue);
    _letzteFormWerte = Map<String, dynamic>.from(form.instantValue);
    _stream.add(form.instantValue);
  }

  String _selectionKey(String prozessVersionId, String rootSlot) =>
      searchCategorySelectionKey(
        prozessVersionId: prozessVersionId,
        schrittId: schritt.id,
        rootSlot: rootSlot,
      );

  void _clearPersistedSearchSelection(
    String rootSlot,
    String? prozessVersionId,
    SearchCategorySelectionNotifier? searchSelectionNotifier,
  ) {
    if (prozessVersionId == null || searchSelectionNotifier == null) return;
    searchSelectionNotifier.clearSelection(
      _selectionKey(prozessVersionId, rootSlot),
    );
  }

  void _clearCascadeDescendants(
    String clearedSlot,
    EvaluatingVisitorService evaluatingVisitor,
  ) {
    final form = _formKey.currentState;
    if (form == null) return;

    final descendants = <String>{};
    var parents = <String>{clearedSlot};
    while (parents.isNotEmpty) {
      final children = _cascadeParentByChild.entries
          .where((entry) => parents.contains(entry.value))
          .map((entry) => entry.key)
          .where(descendants.add)
          .toSet();
      parents = children;
    }

    _relevanzDebounce?.cancel();
    _inCleanup = true;
    try {
      for (final slot in descendants) {
        FormularSchritt._clearFormValue(form, slot);
      }
    } finally {
      _inCleanup = false;
    }

    _relevanzAusgeloestDurchKategorieAenderung = true;
    _letzteTriggerWerte = _triggerValuesKey(form.instantValue);
    _letzteFormWerte = Map<String, dynamic>.from(form.instantValue);
    _stream.add(form.instantValue);
    unawaited(_updateRelevance(evaluatingVisitor));
  }
}

part of 'formular_schritt.dart';

/// Provides search index for a form step.
extension _FormularSearchIndex on FormularSchritt {
  Future<List<CascadeEntry>> _visibleSearchEntries(
    FormularTextFeldData rootField,
    EvaluatingVisitorService evaluatingVisitor,
  ) async {
    final index = await _searchIndex(rootField, evaluatingVisitor);
    return index.visibleEntries(
      evaluatingVisitor,
      _formKey.currentState!.instantValue,
    );
  }

  Future<CascadeSearchIndex> _searchIndex(
    FormularTextFeldData rootField,
    EvaluatingVisitorService evaluatingVisitor,
  ) async {
    try {
      return await _searchIndices.putIfAbsent(
        rootField.slotName,
        () => CascadeSearchIndex.build(
          rootField,
          schritt.felder.whereType<FormularTextFeldData>(),
          evaluatingVisitor,
        ),
      );
    } catch (_) {
      _searchIndices.remove(rootField.slotName)?.ignore();
      rethrow;
    }
  }

  Future<void> _restoreSearchSelections(
    EvaluatingVisitorService evaluatingVisitor,
    Map<String, dynamic> slots,
    Map<String, SearchCategoryPath> persistedSelections,
    String prozessVersionId,
  ) async {
    final rootFields = schritt.felder.whereType<FormularTextFeldData>().where(
      (field) =>
          field.durchsuchbar &&
          field.stringOptions.isNotEmpty &&
          !_cascadeChildSlots.contains(field.slotName),
    );
    for (final rootField in rootFields) {
      if (_activeSearchSelection(rootField.slotName, slots) != null) continue;
      final persistedPath =
          persistedSelections[_selectionKey(
            prozessVersionId,
            rootField.slotName,
          )];
      if (persistedPath == null || persistedPath.isEmpty) continue;

      final index = await _searchIndex(rootField, evaluatingVisitor);
      for (final entry in index.entries) {
        final matchesPersistedPath =
            entry.steps.length == persistedPath.length &&
            entry.steps.every(
              (step) => persistedPath[step.field.slotName] == step.option.key,
            );
        final matchesCurrentValues = entry.steps.every(
          (step) => slots[step.field.slotName] == step.option.key,
        );
        if (matchesPersistedPath && matchesCurrentValues) {
          _searchSelections[rootField.slotName] = entry;
          break;
        }
      }
    }
  }

  /// Keeps options whose relevance expression is absent or evaluates to true.
  /// Option relevance is checked independently of the parent field.
  Future<List<TextFeldOption>> _visibleOptionsAsync(
    FormularTextFeldData feld,
    EvaluatingVisitorService evaluatingVisitor,
    Map<String, dynamic> slots, {
    Map<String, Future<bool>>? relevanceCache,
  }) async {
    final bewertet = await feld.stringOptions.map((option) async {
      final istRelevant = option.istRelevant;
      final relevant =
          istRelevant == null ||
          await (relevanceCache?.putIfAbsent(
                istRelevant.expression,
                () => evaluatingVisitor.evaluateBool(istRelevant, slots),
              ) ??
              evaluatingVisitor.evaluateBool(istRelevant, slots));
      return (option: option, relevant: relevant);
    }).wait;

    return bewertet.where((b) => b.relevant).map((b) => b.option).toList();
  }
}

part of 'formular_schritt.dart';

/// Provides cascade structure for a form step.
extension _FormularCascadeStructure on FormularSchritt {
  Map<String, String> _computeCascadeParentsByChild() {
    final optionFields = schritt.felder
        .whereType<FormularTextFeldData>()
        .where((f) => f.stringOptions.isNotEmpty)
        .toList();
    final optionSlots = optionFields.map((f) => f.slotName).toSet();
    final parentByChild = <String, String>{};
    for (final field in optionFields) {
      final parents = FormularSchritt._slotReferenzPattern
          .allMatches(field.istRelevant.expression)
          .map((m) => m.group(1)!)
          .where(optionSlots.contains)
          .toSet();
      if (parents.length == 1) {
        parentByChild[field.slotName] = parents.single;
      }
    }

    return parentByChild;
  }

  String _rootFor(String slot) {
    var root = slot;
    final visited = <String>{};
    while (true) {
      final parent = _cascadeParentByChild[root];
      if (parent == null || !visited.add(root)) break;
      root = parent;
    }
    return root;
  }

  bool _hasEmptyCascadeAncestor(String slot, Map<String, dynamic> formValues) {
    if (!_searchableCascadeSlots.contains(slot)) return false;
    var current = slot;
    final visited = <String>{};
    while (visited.add(current)) {
      final parent = _cascadeParentByChild[current];
      if (parent == null) return false;
      if (formValues[parent] == null) return true;
      current = parent;
    }
    return false;
  }

  Set<String> _computeSearchableCascadeSlots() {
    final searchableRoots = schritt.felder
        .whereType<FormularTextFeldData>()
        .where((field) => field.durchsuchbar && field.stringOptions.isNotEmpty)
        .map((field) => field.slotName)
        .toSet();
    return {
      ...searchableRoots,
      for (final entry in _cascadeRootsByChild.entries)
        if (searchableRoots.contains(entry.value)) entry.key,
    };
  }

  Set<String> _computeCascadeParentSlots() {
    final searchableSlots = _searchableCascadeSlots;
    return schritt.felder
        .whereType<FormularTextFeldData>()
        .expand(
          (field) => FormularSchritt._slotReferenzPattern
              .allMatches(field.istRelevant.expression)
              .map((match) => match.group(1)!),
        )
        .where(searchableSlots.contains)
        .toSet();
  }

  Set<String> _computeRelevanceTriggerSlots() {
    final gefunden = <String>{};
    for (final feld in schritt.felder) {
      gefunden.addAll(
        FormularSchritt._slotReferenzPattern
            .allMatches(feld.istRelevant.expression)
            .map((m) => m.group(1)!),
      );
      if (feld is FormularTextFeldData) {
        for (final option in feld.stringOptions) {
          final ausdruck = option.istRelevant;
          if (ausdruck == null) continue;
          gefunden.addAll(
            FormularSchritt._slotReferenzPattern
                .allMatches(ausdruck.expression)
                .map((m) => m.group(1)!),
          );
        }
      }
    }
    return gefunden;
  }

  String _triggerValuesKey(Map<String, dynamic> slots) {
    final keys = _relevanzTriggerSlots.toList()..sort();
    Object? vergleichbar(dynamic value) =>
        value is FormLocation ? value.position.toJson() : value;
    return keys.map((k) => '$k=${vergleichbar(slots[k])}').join('|');
  }
}

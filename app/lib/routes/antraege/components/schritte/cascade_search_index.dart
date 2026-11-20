import 'package:app/common/expressions/evaluating_visitor_service.dart';
import 'package:app/routes/antraege/components/schritte/cascade_entry.dart';
import 'package:app/routes/antraege/components/schritte/cascade_step.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/location_field/location_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/text_field/text_field.dart';

final RegExp _slotReferencePattern = RegExp(r"slot\('([^']+)'\)");

Set<String> _referencedSlots(String expression) => _slotReferencePattern
    .allMatches(expression)
    .map((m) => m.group(1)!)
    .toSet();

String? _comparisonValueForSlot(String expression, String slotName) =>
    RegExp(
          "slot\\('${RegExp.escape(slotName)}'\\)\\s*==\\s*'((?:[^'\\\\]|\\\\.)*)'",
        )
        .firstMatch(expression)
        ?.group(1)
        ?.replaceAllMapped(RegExp(r'\\(.)'), (m) => m.group(1)!);

class CascadeSearchIndex {
  CascadeSearchIndex._(this.entries, this._relevanceSlots);

  final List<CascadeEntry> entries;
  final Set<String> _relevanceSlots;
  final Map<String, Future<List<CascadeEntry>>> _visibleByRelevanceKey = {};

  static Future<CascadeSearchIndex> build(
    FormularTextFeldData rootField,
    Iterable<FormularTextFeldData> fields,
    EvaluatingVisitorService evaluatingVisitor,
  ) async {
    final fieldsList = fields.toList();
    final optionSlots = fieldsList
        .where((field) => field.stringOptions.isNotEmpty)
        .map((field) => field.slotName)
        .toSet();
    final childFieldsBySlot = <String, List<FormularTextFeldData>>{};
    for (final field in fieldsList) {
      if (field.slotName == rootField.slotName || field.stringOptions.isEmpty) {
        continue;
      }
      final referencedOptionSlots = _referencedSlots(
        field.istRelevant.expression,
      ).where(optionSlots.contains).toSet();
      if (referencedOptionSlots.length != 1) continue;
      childFieldsBySlot
          .putIfAbsent(referencedOptionSlots.single, () => [])
          .add(field);
    }

    final entries = <CascadeEntry>[];
    final relevanceSlots = <String>{};

    Future<void> descend(
      FormularTextFeldData field,
      List<CascadeStep> path,
    ) async {
      final childFields = (childFieldsBySlot[field.slotName] ?? []).where(
        (f) => !path.any((s) => s.field.slotName == f.slotName),
      );
      relevanceSlots.addAll(_referencedSlots(field.istRelevant.expression));
      for (final option in field.stringOptions) {
        final optionRelevance = option.istRelevant;
        if (optionRelevance != null) {
          relevanceSlots.addAll(_referencedSlots(optionRelevance.expression));
        }

        final childPath = [...path, CascadeStep(field, option)];
        final pathSlots = {
          for (final step in childPath) step.field.slotName: step.option.key,
        };
        var hasChild = false;
        for (final childField in childFields) {
          final comparisonValue = _comparisonValueForSlot(
            childField.istRelevant.expression,
            field.slotName,
          );
          final belongsToOption = comparisonValue != null
              ? comparisonValue == option.key
              : await evaluatingVisitor.evaluateBool(
                  childField.istRelevant,
                  pathSlots,
                );
          if (belongsToOption) {
            hasChild = true;
            await descend(childField, childPath);
          }
        }
        if (!hasChild) entries.add(CascadeEntry(childPath));
      }
    }

    await descend(rootField, const []);
    relevanceSlots.removeAll(optionSlots);
    return CascadeSearchIndex._(entries, relevanceSlots);
  }

  Future<List<CascadeEntry>> visibleEntries(
    EvaluatingVisitorService evaluatingVisitor,
    Map<String, dynamic> slots,
  ) async {
    final relevanceKey = (_relevanceSlots.toList()..sort())
        .map((k) {
          final value = slots[k];
          return '$k=${value is FormLocation ? value.position.toJson() : value}';
        })
        .join('|');
    return _visibleByRelevanceKey.putIfAbsent(relevanceKey, () async {
      final visibility = await entries.map((entry) async {
        final pathSlots = Map<String, dynamic>.from(slots);
        for (final step in entry.steps) {
          if (!await evaluatingVisitor.evaluateBool(
            step.field.istRelevant,
            pathSlots,
          )) {
            return false;
          }
          pathSlots[step.field.slotName] = step.option.key;
          final optionRelevance = step.option.istRelevant;
          if (optionRelevance != null &&
              !await evaluatingVisitor.evaluateBool(
                optionRelevance,
                pathSlots,
              )) {
            return false;
          }
        }
        return true;
      }).wait;
      return [
        for (var i = 0; i < entries.length; i++)
          if (visibility[i]) entries[i],
      ];
    });
  }

  static List<CascadeEntry> search(
    List<CascadeEntry> entries,
    String query, {
    int limit = 20,
  }) {
    final words = normalizeSearchText(
      query,
    ).split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return const [];

    int rank(CascadeEntry e) {
      final label = e.labelSearchText;
      if (label.startsWith(words.first)) return 0;
      if (label
          .split(RegExp(r'[\s\-/]+'))
          .any((w) => w.startsWith(words.first))) {
        return 1;
      }
      if (words.any(label.contains)) return 2;
      return 3;
    }

    final matches =
        [
          for (final e in entries)
            if (words.every(e.searchText.contains)) (entry: e, rank: rank(e)),
        ]..sort((a, b) {
          final byRank = a.rank.compareTo(b.rank);
          if (byRank != 0) return byRank;
          final byDepth = a.entry.steps.length.compareTo(b.entry.steps.length);
          if (byDepth != 0) return byDepth;
          return a.entry.label.compareTo(b.entry.label);
        });

    return matches.take(limit).map((m) => m.entry).toList();
  }
}

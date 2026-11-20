import 'package:app/routes/antraege/components/schritte/cascade_step.dart';

class CascadeEntry {
  CascadeEntry(this.steps)
    : searchText = normalizeSearchText(
        steps.map((s) => s.option.value).join(' '),
      ),
      labelSearchText = normalizeSearchText(steps.last.option.value);

  final List<CascadeStep> steps;
  final String searchText;
  final String labelSearchText;

  String get label => steps.last.option.value;

  String get pathLabel => steps.map((s) => s.option.value).join(' › ');

  List<String> get parentLabels =>
      steps.take(steps.length - 1).map((s) => s.option.value).toList();
}

String normalizeSearchText(String text) => text
    .toLowerCase()
    .replaceAll('ä', 'ae')
    .replaceAll('ö', 'oe')
    .replaceAll('ü', 'ue')
    .replaceAll('ß', 'ss');

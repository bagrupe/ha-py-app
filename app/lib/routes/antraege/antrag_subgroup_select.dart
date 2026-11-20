import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/routes/antraege/common/antrag_select.dart';
import 'package:app/routes/antraege/components/antrag_list_view.dart';
import 'package:flutter/material.dart';

/// Typdefinition für die Eigenschaften des AntragSubGroupSelect-Widgets.
/// Enthält einen Titel und eine Liste von Prozessen und Leistungen.
typedef AntragSubGroupSelectProps = (
  String title,
  List<ProzessOrLeistung> prozesse,
);

/// Widget zur Anzeige einer Untergruppe von Anträgen mit Titel und Liste.
/// Zeigt eine Überschrift und eine Liste der übergebenen Prozesse an.
class AntragSubgroupSelect extends StatelessWidget {
  /// Erzeugt eine neue Instanz mit den angegebenen Prozessen und Gruppennamen.
  const AntragSubgroupSelect({
    required this.prozesse,
    required this.gruppenName,
    super.key,
  });

  /// Liste der Prozesse und Leistungen, die angezeigt werden sollen.
  final List<ProzessOrLeistung> prozesse;

  /// Name der Gruppe, der als Überschrift dargestellt wird.
  final String gruppenName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const CommonAppBar(title: Text('Service')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(gruppenName, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 24),
            ListViewAntraege(prozesse: prozesse),
          ],
        ),
      ),
    );
  }
}

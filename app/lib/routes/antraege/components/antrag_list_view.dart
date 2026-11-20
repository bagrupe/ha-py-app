import 'package:app/routes/antraege/common/antrag_select.dart';
import 'package:app/routes/antraege/components/antrag_select_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget, das eine Liste von Prozessen oder Leistungen anzeigt.
/// Erwartet eine Iterable von Prozessen, die als Listenelemente dargestellt werden.
class ListViewAntraege extends ConsumerWidget {
  /// Erzeugt eine Instanz von ListViewAntraege mit den übergebenen Prozessen.
  const ListViewAntraege({required this.prozesse, super.key});

  /// Die anzuzeigenden Prozesse oder Leistungen.
  final Iterable<ProzessOrLeistung> prozesse;

  /// Baut das Widget mit einer getrennten ListView, die für jeden Prozess ein Listenelement rendert.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: prozesse.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) =>
          AntragSelectItem(prozess: prozesse.elementAt(index)),
    );
  }
}

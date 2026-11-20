// ignore_for_file: no_default_cases

import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/__generated__/schritte.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql/client.dart';

/// Liefert eine asynchrone Liste von Ausführungen des aktuellen Bürgers aus dem Backend.
final ausfuehrungProvider = FutureProvider((ref) async {
  final graphqlClient = ref.watch(graphqlClientProvider);

  final res = await graphqlClient.query_Ausfuehrungen(
    Options_Query_Ausfuehrungen(fetchPolicy: FetchPolicy.networkOnly),
  );

  final my = res.parsedData?.my;

  if (my is! Query_Ausfuehrungen_my__Buerger) {
    return List<Query_Ausfuehrungen_my__Buerger_ausfuehrungen>.empty();
  }

  return my.ausfuehrungen;
});

/// Enthält Zähler für verschiedene Status von Ausführungen.
class AusfuehrungenCounts {
  /// Erstellt eine Instanz mit den angegebenen Zählerwerten.
  AusfuehrungenCounts({
    required this.bearbeitungDurchBuerger,
    required this.bearbeitungDurchKommune,
    required this.laufend,
    required this.abgeschlossen,
  });

  /// Liefert eine Instanz mit allen Zählern auf null.
  factory AusfuehrungenCounts.zero() {
    return AusfuehrungenCounts(
      bearbeitungDurchBuerger: 0,
      bearbeitungDurchKommune: 0,
      laufend: 0,
      abgeschlossen: 0,
    );
  }
  final int bearbeitungDurchBuerger;
  final int bearbeitungDurchKommune;
  final int laufend;
  final int abgeschlossen;
}

/// Liefert die aggregierten Zähler der Ausführungen nach Status.
final ausfuehrungenCountProvider = Provider<AusfuehrungenCounts>((ref) {
  final ausfuehrungenListe = ref.watch(ausfuehrungProvider);

  if (ausfuehrungenListe is! AsyncData) {
    return AusfuehrungenCounts.zero();
  }

  var bearbeitungDurchBuerger = 0;
  var bearbeitungDurchKommune = 0;
  var abgeschlossen = 0;

  for (final ausfuehrung in ausfuehrungenListe.requireValue) {
    switch (ausfuehrung.status) {
      case Enum_AusfuehrungStatus.BEARBEITUNG_DURCH_BUERGER:
        bearbeitungDurchBuerger++;
      case Enum_AusfuehrungStatus.BEARBEITUNG_DURCH_KOMMUNE:
        bearbeitungDurchKommune++;
      case Enum_AusfuehrungStatus.ABGESCHLOSSEN:
        abgeschlossen++;
      default:
        break;
    }
  }

  return AusfuehrungenCounts(
    bearbeitungDurchBuerger: bearbeitungDurchBuerger,
    bearbeitungDurchKommune: bearbeitungDurchKommune,
    laufend: bearbeitungDurchBuerger + bearbeitungDurchKommune,
    abgeschlossen: abgeschlossen,
  );
});

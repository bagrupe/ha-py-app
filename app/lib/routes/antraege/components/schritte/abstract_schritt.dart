import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef SchrittData = Fragment_Schritt;

/// Abstrakte Basisklasse für einen Schritt mit generischen Schrittdaten.
/// Stellt die Grundstruktur und Methoden für die Darstellung und Verwaltung eines Schritts bereit.
abstract class AbstractSchritt<T extends SchrittData> {
  /// Erstellt eine Instanz mit den übergebenen Schrittdaten.
  AbstractSchritt(this.schritt);

  /// Die Daten des Schritts.
  final T schritt;

  ValueListenable<bool>? get contentReadyListenable => null;

  /// Baut das Widget für den Schritt basierend auf dem Kontext und dem Riverpod-Ref.
  Widget build(BuildContext context, WidgetRef ref);

  /// Liefert die editierbaren Slots und zugehörigen Fehler zurück.
  (EditableSlots slots, EditableSlots errors) getSlots();

  /// Prüft, ob der Schritt vollständig ausgefüllt ist.
  /// Standardmäßig wird true zurückgegeben.
  bool isComplete() => true;

  /// Releases resources held by this step. Called when it is evicted from the schritt cache.
  void dispose() {}
}

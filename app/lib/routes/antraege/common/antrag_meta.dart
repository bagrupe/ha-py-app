import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repräsentiert Metadaten eines Antrags mit Titel, Texten und Rückkehr-Route.
@immutable
class AntragMeta {
  /// Erstellt eine Instanz von AntragMeta mit den angegebenen Werten.
  const AntragMeta(
    this.title,
    this.completedText,
    this.completionButtonText,
    this.returnRoute,
  );

  /// Erstellt eine leere Instanz von AntragMeta mit leeren Strings.
  const AntragMeta.empty()
    : title = '',
      completedText = '',
      completionButtonText = '',
      returnRoute = '';
  final String title;
  final String completedText;
  final String completionButtonText;
  final String returnRoute;
}

/// Notifier zur Verwaltung des Zustands von AntragMeta.
class AntragMetaNotifer extends Notifier<AntragMeta> {
  @override
  AntragMeta build() {
    return const AntragMeta.empty();
  }

  /// Setzt die aktuellen Metadaten auf den übergebenen AntragMeta-Wert.
  void setMeta(AntragMeta meta) {
    state = meta;
  }

  /// Setzt den Zustand zurück auf eine leere AntragMeta-Instanz.
  void endProzess() {
    state = const AntragMeta.empty();
  }
}

/// Provider für den AntragMeta-Notifier zur Zustandsverwaltung.
final antragMetaProvider = NotifierProvider<AntragMetaNotifer, AntragMeta>(
  AntragMetaNotifer.new,
);

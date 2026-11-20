import 'package:app/routes/antraege/components/schritte/abstract_schritt.dart';

/// Erweiterung für SchrittData zur Bereitstellung eines Standardtitels.
extension SchrittExtensions on SchrittData {
  /// Gibt den Titel zurück oder einen Platzhalter, falls kein Titel gesetzt ist.
  String get defaultedTitel => titel ?? 'Fehlender Titel';
}

import 'package:go_router/go_router.dart';

/// Erweiterung für GoRouterState zur Bestimmung der Standard-Weiterleitung.
extension DefaultRedirect on GoRouterState {
  /// Gibt den neuen Pfad zurück, wenn der aktuelle Pfad dem gematchten Pfad entspricht, sonst den aktuellen Pfad.
  ///
  /// [newLocation] ist der Pfad, zu dem weitergeleitet werden soll, falls die Bedingung erfüllt ist.
  String defaultRedirect(String newLocation) =>
      uri.path == matchedLocation ? newLocation : uri.path;
}

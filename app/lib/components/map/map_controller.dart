import 'dart:async';

import 'package:app/components/map/map_animation_ticker_provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

/// Steuert die Karte der Kommunal-App mit Unterstützung für Animationen und Markierungen.
class KommunalAppMapController extends AnimatedMapController {
  /// Initialisiert den Kartencontroller mit einem internen MapController und einem TickerProvider für Animationen.
  KommunalAppMapController()
    : super(
        mapController: MapController(),
        vsync: MapAnimationTickerProvider(),
      );

  /// Liefert den internen MapController.
  MapController get map => mapController;

  final StreamController<LatLng?> _markedPositions =
      StreamController.broadcast();

  /// Stream, der markierte Positionen ausgibt (null = keine Markierung).
  late final markedPosition = _markedPositions.stream;

  /// Fügt eine markierte Position hinzu.
  /// [position] ist die geografische Position, die markiert werden soll.
  void markPosition(LatLng position) {
    _markedPositions.sink.add(position);
  }

  /// Entfernt die aktuelle Positionsmarkierung von der Karte.
  void clearMarkedPosition() {
    _markedPositions.sink.add(null);
  }
}

/// Fehlerklasse, die ausgelöst wird, wenn der Kartencontroller außerhalb des erlaubten Kontexts verwendet wird.
class _ErrorKommunalAppMapController extends KommunalAppMapController {
  _ErrorKommunalAppMapController() {
    throw Exception(
      'The mapControllerProvider was used outside of the KommunalApp widget which is not allowed!',
    );
  }
}

/// Family-Provider, der Instanzen von KommunalAppMapController erzeugt.
final mapControllerFamily = Provider.family(
  (ref, _) => KommunalAppMapController(),
);

/// Standard-Provider für den Kartencontroller, der einen Fehler wirft, wenn er nicht überschrieben wird.
final mapControllerProvider = Provider<KommunalAppMapController>(
  (ref) => _ErrorKommunalAppMapController(),
);

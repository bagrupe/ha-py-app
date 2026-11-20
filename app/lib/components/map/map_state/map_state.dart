import 'dart:async';

import 'package:app/components/map/map_controller.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'map_state.freezed.dart';

/// Repräsentiert den Zustand der Karte mit Zentrum, Zoomstufe und Rotation.
/// Repräsentiert den Zustand der Karte mit Zentrum, Zoomstufe und Rotation.
@freezed
abstract class MapState with _$MapState {
  /// Erstellt eine neue Instanz von [MapState].
  /// [center] ist der Mittelpunkt der Karte, [zoom] die Zoomstufe, [rotation] der Rotationswinkel.
  const factory MapState({
    required LatLng center,
    required double zoom,
    required double rotation,
  }) = _MapState;

  const MapState._();

  static const initialRotation = 0.0;
}

/// Verwaltet den Zustand der Karte und reagiert auf Kartenereignisse.
class MapNotifier extends Notifier<MapState> {
  StreamSubscription<MapEvent>? _mapEventSubscription;

  @override
  /// Initialisiert den Kartenstatus und abonniert Kartenereignisse.
  MapState build() {
    final controller = ref.watch(mapControllerProvider);

    ref.onDispose(() {
      _mapEventSubscription?.cancel();
    });

    _mapEventSubscription?.cancel();
    _mapEventSubscription = _subscribeMapEvents(controller.map.mapEventStream);

    return MapState(
      center: controller.map.camera.center,
      zoom: controller.map.camera.zoom,
      rotation: MapState.initialRotation,
    );
  }

  /// Abonniert den Stream von Kartenereignissen und aktualisiert den Zustand entsprechend.
  StreamSubscription<MapEvent> _subscribeMapEvents(Stream<MapEvent> events) {
    return events.listen((event) {
      switch (event) {
        case MapEventRotate():
          state = state.copyWith(rotation: event.camera.rotation % 360);
        case MapEventMove():
          state = state.copyWith(
            center: event.camera.center,
            zoom: event.camera.zoom,
          );
      }
    });
  }
}

/// Provider für den aktuellen Kartenstatus mit Abhängigkeit vom Kartencontroller.
final mapStateProvider = NotifierProvider<MapNotifier, MapState>(
  MapNotifier.new,
  dependencies: [mapControllerProvider],
);

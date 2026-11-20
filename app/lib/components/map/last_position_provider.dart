import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Ein StateNotifier, der die letzte bekannte Kartenposition verwaltet.
class LastPositionNotifier extends StateNotifier<MapCamera?> {
  /// Initialisiert den Notifier mit einem anfänglichen Wert von null.
  LastPositionNotifier() : super(null);

  /// Setzt die letzte bekannte Kartenposition.
  /// [position] ist die neue Position, die gespeichert werden soll.
  void setLastPosition(MapCamera position) {
    state = position;
  }
}

/// Ein Provider, der den aktuellen Zustand der letzten Kartenposition bereitstellt.
final lastPositionProvider =
    StateNotifierProvider<LastPositionNotifier, MapCamera?>((ref) {
      return LastPositionNotifier();
    });

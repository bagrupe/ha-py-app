import 'package:flutter/scheduler.dart';

/// Ein TickerProvider, der Ticker für Kartenanimationen bereitstellt.
class MapAnimationTickerProvider implements TickerProvider {
  /// Erstellt einen neuen Ticker, der bei jedem Tick die übergebene Callback-Funktion ausführt.
  /// [onTick] ist die Funktion, die bei jedem Tick aufgerufen wird.
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}

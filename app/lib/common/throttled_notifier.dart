import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

/// Ein Notifier, der Updates von einer Quelle mit einer zeitlichen Drosselung weitergibt.
class ThrottledNotifier<T> extends Notifier<T> {
  /// Erstellt einen ThrottledNotifier mit der gegebenen Quelle und Drosselungsdauer.
  ThrottledNotifier(this._source, this._duration);

  final ProviderListenable<T> _source;
  final Duration _duration;
  Timer? _timer;
  DateTime _lastUpdate = DateTime(0);
  ProviderSubscription<T>? _subscription;

  /// Baut den Notifier auf und startet das Abonnieren der Quelle mit Drosselung.
  @override
  T build() {
    ref.onDispose(() {
      _timer?.cancel();
      _subscription?.close();
    });

    _timer?.cancel();
    _subscription?.close();

    _subscription = ref.listen(_source, (_, next) {
      final elapsed = DateTime.now().difference(_lastUpdate);

      if (elapsed >= _duration) {
        // Update immediately
        _update(next);
      } else {
        // Cancel pending update
        if (_timer?.isActive ?? false) {
          _timer!.cancel();
        }
        // Schedule throttled update
        _timer = Timer(_duration - elapsed, () {
          _update(next);
        });
      }
    });

    _lastUpdate = DateTime.now();

    return ref.read(_source);
  }

  /// Aktualisiert den Zustand und setzt die Zeit des letzten Updates.
  void _update(T value) {
    state = value;
    _lastUpdate = DateTime.now();
  }
}

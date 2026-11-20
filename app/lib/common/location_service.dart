// ignore_for_file: inference_failure_on_function_invocation

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Dienst zur Verwaltung von Standortberechtigungen und Positionsabfragen.
class LocationService with ChangeNotifier {
  @visibleForTesting
  static Position? mockLocation;

  static bool? lastEmit;
  static final StreamController<bool> _grantedController =
      StreamController.broadcast();

  /// Stream, der Änderungen der Standortberechtigung ausgibt.
  static final Stream<bool> grantedStream = _grantedController.stream;

  static Future<bool>? _ongoingPermissionRequest;

  static bool _isGranted(LocationPermission p) =>
      p == LocationPermission.always || p == LocationPermission.whileInUse;

  static void _emit(bool granted) {
    if (granted != lastEmit) {
      _grantedController.sink.add(granted);
    }

    lastEmit = granted;
  }

  /// Aktualisiert den Berechtigungs-Stream durch Abfrage des aktuellen Status.
  static Future<void> updateGranted({bool force = false}) async {
    final oldLastEmit = lastEmit;
    final granted = await permissionGranted;

    final didEmit = oldLastEmit != granted;
    if (!didEmit && force) _grantedController.sink.add(granted);
  }

  /// Prüft asynchron, ob Standortberechtigung erteilt wurde.
  static Future<bool> get permissionGranted async {
    final granted = await Geolocator.checkPermission().then(_isGranted);
    _emit(granted);
    return granted;
  }

  static Stream<Position>? _internalStream;

  /// Liefert einen Stream mit Positionsupdates, optional mit Einstellungen.
  static Stream<Position> _getPositionStream({
    LocationSettings? locationSettings,
  }) {
    if (_internalStream != null) return _internalStream!;

    final positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    );

    return _internalStream = _wrapStream(positionStream);
  }

  static Stream<Position> _wrapStream(Stream<Position> incoming) {
    return incoming.asBroadcastStream(
      onCancel: (subscription) {
        subscription.cancel();
        _internalStream = null;
      },
    );
  }

  static Future<void> _showApplicationSettingsDialog(
    BuildContext context,
  ) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        void close() {
          Navigator.of(ctx).pop();
        }

        return AlertDialog(
          title: const Text('Standortfreigabe benötigt'),
          content: const Text(
            'Dieses Feature benötigt Zugang zur aktuellen Position. App-Einstellungen öffnen?',
          ),
          actions: [
            TextButton(onPressed: close, child: const Text('Abbrechen')),
            TextButton(
              onPressed: () {
                Geolocator.openAppSettings();
                close();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  /// Fordert Standortberechtigung an und zeigt ggf. Dialog bei dauerhafter Ablehnung.
  static Future<bool> requestPermission({BuildContext? context}) async {
    if (_ongoingPermissionRequest != null) {
      return _ongoingPermissionRequest!;
    }

    final completer = Completer<bool>();
    _ongoingPermissionRequest = completer.future;

    try {
      final currentStatus = await Geolocator.checkPermission();
      if (_isGranted(currentStatus)) {
        completer.complete(true);
        return true;
      }

      final requestResult = await Geolocator.requestPermission();
      if (requestResult == LocationPermission.deniedForever) {
        if (context != null && context.mounted) {
          await _showApplicationSettingsDialog(context);
        }

        completer.complete(false);
        return false;
      }

      final granted = _isGranted(requestResult);
      _emit(granted);
      completer.complete(granted);
      return granted;
    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      _ongoingPermissionRequest = null;
    }
  }

  static Future<Position> _getCurrentPosition(
    LocationAccuracy desiredAccuracy,
  ) async {
    if (mockLocation != null) return mockLocation!;

    final lastKnown = await Geolocator.getLastKnownPosition();
    if (lastKnown != null) return lastKnown;

    return _getPositionStream(
      locationSettings: LocationSettings(accuracy: desiredAccuracy),
    ).first;
  }

  /// Liefert die aktuelle Position, optional mit Berechtigungsanfrage.
  static Future<Position> getCurrentPosition({
    bool request = true,
    BuildContext? context,
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
  }) async => returnWithLocationPermission(
    () => _getCurrentPosition(desiredAccuracy),
    request: request,
    context: context,
  );

  /// Liefert einen Stream mit Positionsupdates, optional mit Berechtigungsanfrage.
  static Future<Stream<Position>> getPositionStream({
    bool request = true,
    BuildContext? context,
  }) => returnWithLocationPermission(
    _getPositionStream,
    request: request,
    context: context,
  );

  /// Liefert die zuletzt bekannte Position, falls Berechtigung vorliegt.
  static Future<Position?> getLastKnownPosition() async {
    final isGranted = await permissionGranted;

    if (!isGranted) return null;

    return Geolocator.getLastKnownPosition();
  }

  /// Führt die Funktion nur aus, wenn Standortberechtigung vorliegt.
  ///
  /// Fordert Berechtigung an, falls gewünscht. Zeigt bei dauerhafter Ablehnung
  /// optional einen Dialog, wenn ein Kontext übergeben wird.
  /// Wirft eine Ausnahme, wenn keine Berechtigung erlangt werden kann.
  static Future<T> returnWithLocationPermission<T>(
    FutureOr<T> Function() producer, {
    bool request = true,
    BuildContext? context,
  }) async {
    final isGranted = await permissionGranted;

    if (isGranted) {
      return producer();
    }

    if (request && context != null && context.mounted) {
      final requestSuccess = await requestPermission(context: context);
      if (requestSuccess) return producer();
    }

    throw Exception('Location permission not granted');
  }
}

/// Beobachtet den App-Lebenszyklus und aktualisiert Berechtigungen beim Fortsetzen.
class LocationLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      LocationService.updateGranted();
    }
  }
}

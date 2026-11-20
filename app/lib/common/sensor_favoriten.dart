// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:app/common/notifications/firebase_push.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _sensorFavoritenKey = 'sensor_favoriten_key';

/// Represents the sensor favorites state as a list of IDs.
@immutable
class SensorFavoritenState {
  /// Creates a new state with the given list of favorite IDs.
  const SensorFavoritenState(this.favoritenIds);
  final List<String> favoritenIds;

  /// Checks whether the given ID is marked as a favorite.
  bool isFavorit(String id) => favoritenIds.contains(id);

  /// Returns a new state with the given ID added.
  SensorFavoritenState withAdded(String id) =>
      SensorFavoritenState([...favoritenIds, id]);

  /// Returns a new state with the given ID removed.
  SensorFavoritenState withRemoved(String id) =>
      SensorFavoritenState(favoritenIds.where((x) => x != id).toList());
}

/// Notifier for managing and persisting sensor favorites.
class SensorFavoritenNotifier extends Notifier<SensorFavoritenState> {
  @override
  /// Initializes the state with the favorites stored in SharedPreferences.
  SensorFavoritenState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final favoritenIds = prefs.getStringList(_sensorFavoritenKey) ?? [];

    if (isFirebasePushAvailable) unawaited(_resubscribeAll(favoritenIds));

    return SensorFavoritenState(favoritenIds);
  }

  Future<void> _resubscribeAll(List<String> favoritenIds) async {
    for (final id in favoritenIds) {
      try {
        await FirebaseMessaging.instance.subscribeToTopic('sensor-$id');
      } catch (e) {
        // A single failure (e.g. on the iOS Simulator, or no network
        // connection at app start) must not block resubscribing the
        // remaining favorites, so no rethrow here.
        if (kDebugMode) print('Failed to resubscribe sensor favorite $id: $e');
      }
    }
  }

  /// Adds a favorite ID and persists the state.
  void addFavorit(String id) {
    state = state.withAdded(id);
    _persist();
  }

  /// Removes a favorite ID and persists the state.
  void removeFavorit(String id) {
    state = state.withRemoved(id);
    _persist();
  }

  /// Persists the current favorites list to SharedPreferences.
  void _persist() {
    final prefs = ref.read(sharedPreferencesProvider);

    prefs.setStringList(_sensorFavoritenKey, state.favoritenIds);
  }
}

/// Provider for the sensor favorites notifier and its state.
final sensorFavoritenProvider =
    NotifierProvider<SensorFavoritenNotifier, SensorFavoritenState>(
      SensorFavoritenNotifier.new,
    );

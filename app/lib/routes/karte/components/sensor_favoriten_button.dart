import 'dart:async';

import 'package:app/common/notifications/firebase_push.dart';
import 'package:app/common/sensor_favoriten.dart';
import 'package:app/components/buttons/toggle_style_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A button that allows toggling a sensor's favorite status.
///
/// Uses Riverpod to observe and manage the global state of favorites.
/// Toggling also (un)subscribes from the sensor's Firebase push topic, so
/// favorited sensors trigger a push notification when a threshold is crossed.
class SensorFavoritenButton extends ConsumerStatefulWidget {
  /// Creates a favorite toggle button for the sensor identified by [id].
  const SensorFavoritenButton({required this.id, super.key});

  /// The unique identifier of the sensor to be favorited or unfavorited.
  final String id;

  @override
  ConsumerState<SensorFavoritenButton> createState() =>
      _SensorFavoritenButtonState();
}

class _SensorFavoritenButtonState extends ConsumerState<SensorFavoritenButton> {
  bool _isLoading = false;

  Future<void> _toggle(bool newFavorit) async {
    setState(() => _isLoading = true);

    final notifier = ref.read(sensorFavoritenProvider.notifier);
    if (newFavorit) {
      notifier.addFavorit(widget.id);
    } else {
      notifier.removeFavorit(widget.id);
    }

    try {
      if (!isFirebasePushAvailable) return;

      if (newFavorit) {
        await FirebaseMessaging.instance.subscribeToTopic(
          'sensor-${widget.id}',
        );
      } else {
        await FirebaseMessaging.instance.unsubscribeFromTopic(
          'sensor-${widget.id}',
        );
      }
    } catch (e) {
      // On iOS Simulator, FirebaseMessaging throws an unknown error, so we ignore it in debug mode.
      if (kDebugMode) return;

      // Revert the optimistic update so the stored favorite status never
      // stays out of sync with the actual push topic subscription.
      if (newFavorit) {
        notifier.removeFavorit(widget.id);
      } else {
        notifier.addFavorit(widget.id);
      }
      rethrow;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriten = ref.watch(sensorFavoritenProvider);
    final isFavorit = favoriten.isFavorit(widget.id);

    return ToggleStyleButton(
      onPressed: _isLoading ? null : () => unawaited(_toggle(!isFavorit)),
      isSelected: isFavorit,
      minSize: const Size(44, 44),
      padding: EdgeInsets.zero,
      child: Icon(
        Symbols.bookmark_star,
        size: 24,
        color: isFavorit ? Colors.white : null,
      ),
    );
  }
}

// ignore_for_file: cascade_invocations

import 'package:app/components/map/controls/map_control_button.dart';
import 'package:app/components/map/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ein Button, der die Kartenansicht auf Norden ausrichtet.
class NorthMapButton extends ConsumerWidget {
  const NorthMapButton({super.key});

  /// Führt eine Animation aus, die die Karte auf Norden zurückdreht.
  /// [ref] wird verwendet, um den MapController zu lesen.
  void _northMap(WidgetRef ref) {
    final mapController = ref.read(mapControllerProvider);

    mapController.animatedRotateReset();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MapControlButton(
      onPressed: () => _northMap(ref),
      icon: Icons.explore_outlined,
    );
  }
}

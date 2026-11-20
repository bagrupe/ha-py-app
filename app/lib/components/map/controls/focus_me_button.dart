import 'package:app/common/extensions/position.dart';
import 'package:app/common/kommune.dart';
import 'package:app/common/location_service.dart';
import 'package:app/components/map/controls/map_control_button.dart';
import 'package:app/components/map/map_controller.dart';
import 'package:app/components/map/map_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ein Button, der die Karte auf die aktuelle Position des Nutzers oder eine Standardposition zentriert.
class FocusMeButton extends ConsumerWidget {
  const FocusMeButton({super.key});

  /// Zentriert die Karte auf die aktuelle Position des Nutzers oder auf eine Standardposition.
  /// Nutzt dazu die Standortberechtigung und den letzten bekannten Standort.
  /// [ref] wird verwendet, um auf Provider-Daten zuzugreifen.
  /// [context] wird für UI-bezogene Operationen benötigt.
  Future<void> _focusMe(WidgetRef ref, BuildContext context) async {
    final defaultPositionArray =
        ref
            .read(kommuneProvider)
            .value
            ?.defaultPosition
            .whereType<double>()
            .toList() ??
        KommuneIds.hapyMapPosition;

    final defaultPosition = MapValues.centerFrom(defaultPositionArray);

    await LocationService.requestPermission(context: context);
    final lastKnownPosition = (await LocationService.getLastKnownPosition())
        ?.toLatLng();

    if (!context.mounted) return;
    final mapController = ref.read(mapControllerProvider);
    mapController.map.move(
      lastKnownPosition != null && MapValues.isValidCenter(lastKnownPosition)
          ? lastKnownPosition
          : defaultPosition,
      mapController.mapController.camera.zoom,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MapControlButton(
      onPressed: () => _focusMe(ref, context),
      icon: Icons.my_location_outlined,
    );
  }
}

import 'package:app/common/kommune.dart';
import 'package:app/components/map/map.dart';
import 'package:app/components/map/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

/// Typdefinition für eine Callback-Funktion, die eine Position auf der Karte übergibt.
typedef MapSelectionCallback = void Function(LatLng);

/// Widget zur Auswahl eines Standorts auf einer Karte mit einem zentralen Marker.
/// Zeigt eine Karte an, auf der der Nutzer die Position durch Verschieben des Kartenausschnitts bestimmen kann.
class SelectionMap extends ConsumerStatefulWidget {
  /// Erstellt eine SelectionMap mit den angegebenen Callbacks und optionalem Kartenmittelpunkt.
  const SelectionMap({
    required this.onSelect,
    required this.onCancel,
    super.key,
    this.center,
  });
  static const controllerProviderName = 'selection-map';

  /// Callback, der bei Auswahl einer Position aufgerufen wird.
  final MapSelectionCallback onSelect;

  /// Callback, der bei Abbruch der Auswahl aufgerufen wird.
  final VoidCallback onCancel;

  /// Optionaler initialer Mittelpunkt der Karte.
  final LatLng? center;

  @override
  ConsumerState<SelectionMap> createState() => _SelectionMapState();
}

/// Zustand der SelectionMap, der die Karte und die Steuerung verwaltet.
class _SelectionMapState extends ConsumerState<SelectionMap> {
  static const _centerMarkerSize = 40.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mapController = ref.watch(
      mapControllerFamily(SelectionMap.controllerProviderName),
    );

    final defaultPosition =
        ref
            .watch(kommuneProvider)
            .value
            ?.defaultPosition
            .whereType<double>()
            .toList() ??
        KommuneIds.hapyMapPosition;

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              KommunalAppMap(
                center: widget.center,
                controller: mapController,
                defaultPosition: defaultPosition,
                withShowcase: false,
              ),
              Transform.translate(
                offset: const Offset(0, -(_centerMarkerSize / 2)),
                child: Center(
                  child: Icon(
                    Icons.place,
                    color: theme.colorScheme.primary,
                    size: _centerMarkerSize,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 12, 0, 20),
                child: Text(
                  'Verschieben Sie den Kartenausschnitt um mit dem Marker die Position des Mangels zu markieren.',
                ),
              ),
              FilledButton(
                onPressed: () =>
                    widget.onSelect(mapController.mapController.camera.center),
                child: const Text('Auswählen'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: widget.onCancel,
                child: const Text('Abbrechen'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

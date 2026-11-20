import 'package:app/common/shared_preferences.dart';
import 'package:app/components/map/controls/controls_menu.dart';
import 'package:app/components/map/controls/filter_menu.dart';
import 'package:app/routes/karte/karte.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showcaseview/showcaseview.dart';

final GlobalKey filterIntroKey = GlobalKey();

/// Eine Widget-Schicht, die die Steuerungselemente der Karte anzeigt.
/// Zeigt optional eine Einführung mit Showcase an, wenn [withShowcase] aktiviert ist.
class MapControlsLayer extends ConsumerStatefulWidget {
  /// Erstellt eine neue Instanz von [MapControlsLayer].
  /// [withShowcase] steuert die Anzeige der Einführung.
  const MapControlsLayer({required this.withShowcase, super.key});

  /// Gibt an, ob die Einführung mit Showcase angezeigt werden soll.
  final bool withShowcase;

  @override
  ConsumerState<MapControlsLayer> createState() => _MapControlsLayerState();
}

/// Zustandsklasse für [MapControlsLayer], die den Showcase-Lifecycle verwaltet.
class _MapControlsLayerState extends ConsumerState<MapControlsLayer> {
  bool _showcaseStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startShowcaseIfNeeded();
  }

  @override
  void dispose() {
    // Showcase beenden, wenn das Widget entfernt wird (z.B. bei Navigation)
    if (_showcaseStarted) {
      try {
        final showcaseContext = filterIntroKey.currentContext;
        if (showcaseContext != null) {
          ShowcaseView.get().dismiss();
        }
      } catch (e) {
        // Fehler ignorieren, falls der Kontext nicht mehr gültig ist
      }
    }
    super.dispose();
  }

  /// Startet den Showcase, wenn die Bedingungen erfüllt sind.
  void _startShowcaseIfNeeded() {
    final prefs = ref.read(sharedPreferencesProvider);
    final introShown = prefs.getBool(karteIntroShownKey);

    if (widget.withShowcase &&
        (introShown == null || introShown == false) &&
        !_showcaseStarted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showcaseStarted = true;
        ShowcaseView.get().startShowCase([filterIntroKey, mapControlsIntroKey]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.withShowcase)
            Showcase(
              key: filterIntroKey,
              description:
                  'Hier kann eingestellt werden, was auf der Karte angezeigt werden soll.',
              targetBorderRadius: const BorderRadius.all(Radius.circular(8)),
              child: const FilterMenu(),
            )
          else
            const FilterMenu(),
          Flexible(child: ControlsMenu(withShowcase: widget.withShowcase)),
        ],
      ),
    );
  }
}

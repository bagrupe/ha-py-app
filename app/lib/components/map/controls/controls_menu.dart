import 'dart:math';

import 'package:app/components/map/controls/focus_me_button.dart';
import 'package:app/components/map/controls/map_control_button.dart';
import 'package:app/components/map/controls/north_map_button.dart';
import 'package:app/components/map/controls/search_button.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

final GlobalKey mapControlsIntroKey = GlobalKey();

/// Ein Menü mit Kartensteuerungselementen, das sich auf- und zuklappen lässt.
/// Zeigt optional eine Einführung mit Showcase an.
class ControlsMenu extends StatefulWidget {
  const ControlsMenu({required this.withShowcase, super.key});
  final bool withShowcase;

  @override
  State<ControlsMenu> createState() => _ControlsMenuState();
}

/// Zustandsklasse für [ControlsMenu], verwaltet Animation und Sichtbarkeit der Steuerungselemente.
class _ControlsMenuState extends State<ControlsMenu>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  late final _animation = CurvedAnimation(
    curve: Curves.fastOutSlowIn,
    reverseCurve: Curves.easeOutQuad,
    parent: _animationController,
  );

  /// Schaltet das Menü auf- oder zu und startet die entsprechende Animation.
  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  /// Liefert die Liste der sich ausklappenden Steuerungselemente mit animierter Position.
  List<Widget> get expandingItems {
    const expandingChildren = [
      FocusMeButton(),
      NorthMapButton(),
      SearchButton(),
    ];

    const availableDegrees = 90;
    final expandingItems = <Widget>[];
    final stepSize = availableDegrees / (expandingChildren.length - 1);

    for (
      var i = 0, angleInDegrees = -90.0;
      i < expandingChildren.length;
      i++, angleInDegrees += stepSize
    ) {
      expandingItems.add(
        _ExpandingMenuItem(
          directionInDegrees: angleInDegrees,
          maxDistance: 90,
          progress: _animation,
          child: expandingChildren[i],
        ),
      );
    }

    return expandingItems;
  }

  @override
  Widget build(BuildContext context) {
    final mapControlButton = MapControlButton(
      onPressed: _toggle,
      icon: _isOpen ? Icons.clear : Icons.map,
      colored: true,
    );

    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          ...expandingItems,
          if (widget.withShowcase)
            Showcase(
              key: mapControlsIntroKey,
              targetBorderRadius: BorderRadius.circular(8),
              description:
                  'Hier finden Sie weitere Funktionen der Karte. Zum Beispiel können Sie hier nach einem Ort suchen.',
              child: mapControlButton,
            )
          else
            mapControlButton,
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

/// Ein einzelnes Menüelement, das sich in eine bestimmte Richtung ausklappt und animiert wird.
class _ExpandingMenuItem extends StatelessWidget {
  const _ExpandingMenuItem({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (BuildContext context, Widget? child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (pi / 180.0),
          progress.value * maxDistance,
        );

        return Positioned(
          right: 4.0 + offset.dx,
          top: 4.0 - offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * pi / 2,
            child: child,
          ),
        );
      },
      child: FadeTransition(opacity: progress, child: child),
    );
  }
}

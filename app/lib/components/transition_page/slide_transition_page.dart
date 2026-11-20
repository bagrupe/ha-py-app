import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Eine Seite mit einer benutzerdefinierten Slide-Übergangsanimation.
/// Ermöglicht das Einblenden der Seite mit einer Verschiebung in eine definierte Richtung.
class SlideTransitionPage extends CustomTransitionPage<void> {
  /// Erstellt eine neue SlideTransitionPage mit dem angegebenen Inhalt und optionalen Parametern.
  /// [child] ist das anzuzeigende Widget, [direction] definiert die Richtung der Slide-Animation.
  SlideTransitionPage({
    required super.child,
    super.key,
    super.opaque,
    super.name,
    AxisDirection direction = AxisDirection.up,
  }) : super(
         transitionDuration: const Duration(milliseconds: 250),
         transitionsBuilder: (_, animation, __, child) {
           return SlideTransition(
             position: animation.drive(
               Tween(
                 begin: _getSlideOffset(direction),
                 end: Offset.zero,
               ).chain(CurveTween(curve: Curves.easeInOutCubic)),
             ),
             child: child,
           );
         },
       );

  /// Liefert den Versatz für die Slide-Animation basierend auf der angegebenen Richtung.
  /// [slideDirection] bestimmt die Richtung der Verschiebung.
  static Offset _getSlideOffset(AxisDirection slideDirection) {
    switch (slideDirection) {
      case AxisDirection.left:
        return const Offset(-1, 0);
      case AxisDirection.right:
        return const Offset(1, 0);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.up:
        return const Offset(0, 1);
    }
  }
}

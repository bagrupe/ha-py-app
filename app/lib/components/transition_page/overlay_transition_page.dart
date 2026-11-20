import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Eine Seite mit benutzerdefinierter Übergangsanimation, die als Overlay angezeigt wird.
/// Blendet die Seite mit einem weichen Fade-Effekt ein und zeigt einen unscharfen Hintergrund.
class OverlayTransitionPage<T> extends CustomTransitionPage<T> {
  /// Erstellt eine neue Overlay-Übergangsseite mit dem angegebenen Inhalt und optionalen Parametern.
  /// [child] ist das anzuzeigende Widget.
  OverlayTransitionPage({
    required super.child,
    super.name,
    super.arguments,
    super.restorationId,
    super.key,
  }) : super(
         opaque: false,
         transitionDuration: const Duration(milliseconds: 300),
         transitionsBuilder: (_, animation, __, child) {
           return FadeTransition(
             opacity: animation.drive(
               Tween(
                 // ignore: prefer_int_literals
                 begin: 0.0,
                 // ignore: prefer_int_literals
                 end: 1.0,
               ).chain(CurveTween(curve: Curves.easeInOutCubic)),
             ),
             child: SafeArea(
               child: BackdropFilter(
                 filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                 child: Scaffold(
                   backgroundColor: Colors.black38,
                   body: Center(child: child),
                 ),
               ),
             ),
           );
         },
       );
}

import 'package:app/components/transition_page/overlay_transition_page.dart';
import 'package:app/components/transition_page/slide_transition_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

/// Definiert einen Funktions-Typ, der einen Widget-Builder mit Kontext und Router-Status beschreibt.
typedef TransitionPageWidgetBuilder =
    Widget Function(BuildContext context, GoRouterState state);

/// Stellt verschiedene Builder für Seitenübergänge bereit.
class TransitionPageBuilders {
  /// Erzeugt eine Seite mit Slide-Übergang in der angegebenen Richtung.
  /// [builder] liefert das anzuzeigende Widget, [direction] bestimmt die Slide-Richtung.
  static GoRouterPageBuilder sliding({
    required TransitionPageWidgetBuilder builder,
    AxisDirection direction = AxisDirection.up,
  }) {
    return (BuildContext context, GoRouterState state) {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return CupertinoPage<void>(
          key: state.pageKey,
          name: state.uri.path,
          child: builder(context, state),
        );
      }
      return SlideTransitionPage(
        name: state.uri.path,
        direction: direction,
        child: builder(context, state),
      );
    };
  }

  /// Erzeugt eine Seite ohne Übergangseffekt.
  /// [builder] liefert das anzuzeigende Widget.
  static GoRouterPageBuilder noTransition({
    required TransitionPageWidgetBuilder builder,
  }) {
    return (BuildContext context, GoRouterState state) =>
        NoTransitionPage(name: state.uri.path, child: builder(context, state));
  }

  /// Erzeugt eine Seite mit einem Dialog-ähnlichen Overlay-Übergang.
  /// [builder] liefert das anzuzeigende Widget.
  static GoRouterPageBuilder dialogTransition({
    required TransitionPageWidgetBuilder builder,
  }) {
    return (BuildContext context, GoRouterState state) => OverlayTransitionPage(
      name: state.uri.path,
      child: builder(context, state),
    );
  }
}

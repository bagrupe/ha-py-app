// ignore_for_file: strict_raw_type

import 'package:flutter/widgets.dart';
import 'package:matomo_tracker/matomo_tracker.dart';

/// Beobachtet Navigationsereignisse und sendet Seitenaufrufe an Matomo.
class MatomoRouterObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _sendScreenView(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _sendScreenView(previousRoute);
    }
  }

  /// Sendet einen Seitenaufruf an Matomo, wenn der Tracker initialisiert ist.
  /// [route] ist die aktuelle Route, deren Name als Seitenname verwendet wird.
  void _sendScreenView(Route route) {
    if (!MatomoTracker.instance.initialized) return;

    if (route is PageRoute) {
      final screenName = route.settings.name;

      if (screenName != null) {
        MatomoTracker.instance.trackPageViewWithName(
          actionName: 'Visited $screenName',
        );
      }
    }
  }
}

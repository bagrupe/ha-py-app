import 'package:app/common/dev_tools_enabled.dart';
import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/common/volunteer_database/volunteer_database_enabled_notifier.dart';
import 'package:app/routes/aktuelles/aktuelles.dart';
import 'package:app/routes/antraege/antraege.dart';
import 'package:app/routes/datenschutz/datenschutz.dart';
import 'package:app/routes/datenschutz/datenschutz_intro.dart';
import 'package:app/routes/deeplinks/deeplinks.dart';
import 'package:app/routes/dev_console/dev_console.dart';
import 'package:app/routes/error/not_found_error_page.dart';
import 'package:app/routes/impressum.dart';
import 'package:app/routes/karte/karte.dart';
import 'package:app/routes/matomo_router_observer.dart';
import 'package:app/routes/onboarding/onboarding.dart';
import 'package:app/routes/onboarding/onboarding_intro.dart';
import 'package:app/routes/overlays/overlays.dart';
import 'package:app/routes/profil/profil.dart';
import 'package:app/routes/root.dart';
import 'package:app/routes/termine/termine.dart';
import 'package:app/routes/volunteer_database/views/eb_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Vorherige Instanz des GoRouter zur Wiederverwendung der Navigation.
GoRouter? _previousRouter;

/// Provider für die zentrale Router-Instanz der App, die die Navigation steuert.
final routerProvider = Provider((ref) {
  final refreshListenable = ValueNotifier(0);
  ref
    ..listen(volunteerAuthProvider, (_, __) {
      refreshListenable.value++;
    })
    ..listen(volunteerDatabaseEnabledProvider, (_, __) {
      refreshListenable.value++;
    })
    ..onDispose(refreshListenable.dispose);

  return _previousRouter = GoRouter(
    refreshListenable: refreshListenable,
    errorPageBuilder: (context, state) {
      return MaterialPage(key: state.pageKey, child: const NotFoundErrorPage());
    },
    navigatorKey: rootNavigatorKey,
    initialLocation:
        _previousRouter?.routerDelegate.currentConfiguration.fullPath ??
        (kIsWeb ? '/aktuelles' : '/datenschutz-intro'),
    debugLogDiagnostics: kDebugMode,
    observers: [SentryNavigatorObserver(), MatomoRouterObserver()],
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return RootScaffold(navigationShell: navigationShell);
        },
        branches: [
          _aktuellesShellBranch(),
          _karteShellBranch,
          _ehrenamtsdatenbankShellBranch(ref),
          _antraegeShellBranch,
          _termineShellBranch,
          _profilShellBranch,
        ],
      ),
      deeplinksRoute(ref),
      notFoundErrorRoute(),
      if (devToolsEnabled) devConsoleRoute,
      overlaysRoute,
      onboardingRoute(ref),
      onboardingIntroRoute,
      datenschutzIntroRoute(ref),
      datenschutzRoute(),
      impressumRoute(),
    ],
  );
});

/// Globaler NavigatorKey für den Root-Navigator der App.
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNavigator');

/// NavigatorKey für den Bereich "Aktuelles".
/// Wird in der Funktion [_aktuellesShellBranch] verwendet.
/// Ignoriert Warnung, da Dart es als ungenutzt ansieht.
// ignore: unused_element
var _aktuellesNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'aktuellesNavigator',
);

/// NavigatorKey für den Bereich "Karte".
final _karteNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'karteNavigator',
);

/// NavigatorKey for "Ehrenamtsdatenbank".
final _ehrenamtsdatenbankNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'ehrenamtsdatenbankNavigator',
);

/// NavigatorKey für den Bereich "Anträge".
final _antraegeNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'antraegeNavigator',
);

/// NavigatorKey für den Bereich "Termine".
final _termineNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'versanstaltungenNavigator',
);

/// NavigatorKey für den Bereich "Profil".
final _profilNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'profilNavigator',
);

/// Erstellt den Shell-Branch für den Bereich "Aktuelles" mit zugehörigem Navigator und Beobachtern.
StatefulShellBranch _aktuellesShellBranch() => StatefulShellBranch(
  navigatorKey: _aktuellesNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'aktuellesNavigator',
  ),
  observers: [SentryNavigatorObserver(), MatomoRouterObserver()],
  routes: [aktuellesRoute],
);

/// Shell-Branch für den Bereich "Karte" mit zugehörigem Navigator und Beobachtern.
final _karteShellBranch = StatefulShellBranch(
  navigatorKey: _karteNavigatorKey,
  observers: [SentryNavigatorObserver(), MatomoRouterObserver()],
  routes: [karteRoute],
);

/// Shell-Branch für den Bereich "Ehrenamtsdatenbank" mit zugehörigem Navigator und Beobachtern.
StatefulShellBranch _ehrenamtsdatenbankShellBranch(Ref ref) =>
    StatefulShellBranch(
      navigatorKey: _ehrenamtsdatenbankNavigatorKey,
      observers: [SentryNavigatorObserver(), MatomoRouterObserver()],
      routes: [ehrenamtsdatenbankRoute(ref)],
    );

/// Shell-Branch für den Bereich "Anträge" mit zugehörigem Navigator und Beobachtern.
final _antraegeShellBranch = StatefulShellBranch(
  navigatorKey: _antraegeNavigatorKey,
  observers: [SentryNavigatorObserver(), MatomoRouterObserver()],
  routes: [antraegeRoute],
);

/// Shell-Branch für den Bereich "Termine" mit zugehörigem Navigator und Beobachtern.
final _termineShellBranch = StatefulShellBranch(
  navigatorKey: _termineNavigatorKey,
  observers: [SentryNavigatorObserver(), MatomoRouterObserver()],
  routes: [termineRoute],
);

/// Shell-Branch für den Bereich "Profil" mit zugehörigem Navigator und Beobachtern.
final _profilShellBranch = StatefulShellBranch(
  navigatorKey: _profilNavigatorKey,
  observers: [SentryNavigatorObserver(), MatomoRouterObserver()],
  routes: [profilRoute],
);

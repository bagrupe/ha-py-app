import 'package:app/app/app.dart';
import 'package:app/common/notifications/firebase_push.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/routes/karte/karte.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:patrol/patrol.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
 * When the map is unmounted while loading the tiles, a CancellationException is raised.
 * It's raised as silent error, meaning it's ignored in production builds but stil shown in debug by default.
 * As we can only run debug-builds on iOS Simulators, we have to explicitly ignore silent errors in our test.
 */
void silenceSilentErrors() {
  final original = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.silent) return;

    original?.call(details);
  };
}

Future<void> launchApp(PatrolIntegrationTester $) async {
  silenceSilentErrors();

  SharedPreferences.setMockInitialValues({karteIntroShownKey: true});
  final prefs = await SharedPreferences.getInstance();

  await initializeFirebasePush();

  await $.pumpWidgetAndSettle(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const App(),
    ),
  );
}

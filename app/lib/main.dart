import 'package:app/app/app.dart';
import 'package:app/app/app_initializer.dart';
import 'package:app/app/localized_app.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/common/startup.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stack_trace/stack_trace.dart';

/// Entry point of the app, initializes error handling, start state and Sentry.
/// Runs the app with necessary providers.
void main() async {
  if (kDebugMode) {
    // Turns `Failed assertion: 'asynchronous gap'` into something useful.
    FlutterError.demangleStackTrace = (StackTrace stack) {
      if (stack is Trace) return stack.vmTrace;
      if (stack is Chain) return stack.toTrace().vmTrace;
      return stack;
    };
  }

  final (initialState, prefs) = await startUp();

  await EasyLocalization.ensureInitialized();

  await SentryFlutter.init(
    (options) {
      const release = String.fromEnvironment(
        'SENTRY_RELEASE',
        defaultValue: 'none',
      );
      const environment = String.fromEnvironment(
        'SENTRY_ENVIRONMENT',
        defaultValue: 'local',
      );
      const dsn = String.fromEnvironment('SENTRY_DSN');

      options
        ..release = release
        ..environment = environment
        ..dsn = kDebugMode || environment == 'local' || dsn.isEmpty ? '' : dsn;
      const sampleRate = kDebugMode ? 0.0 : 1.0;
      options
        ..tracesSampleRate = sampleRate
        ..sampleRate = sampleRate
        ..enableBreadcrumbTrackingForCurrentPlatform();
    },
    appRunner: () {
      if (kIsWeb) WidgetsFlutterBinding.ensureInitialized();

      return runApp(
        ProviderScope(
          overrides: [
            initialStateProvider.overrideWithValue(initialState),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: SentryUserInteractionWidget(
            child: const LocalizedApp(child: AppInitializer(child: App())),
          ),
        ),
      );
    },
  );
}

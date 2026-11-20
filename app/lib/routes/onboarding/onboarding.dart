import 'package:app/common/shared_preferences.dart';
import 'package:app/common/startup.dart';
import 'package:app/components/transition_page/transition_page_builders.dart';
import 'package:app/routes/onboarding/onboarding_intro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Definiert die Route für den Onboarding-Prozess der App.
/// Nutzt den übergebenen Ref, um den Status des Onboardings und die Startseite zu ermitteln.
/// Leitet abhängig vom Onboarding-Status auf die entsprechende Seite weiter.
GoRoute onboardingRoute(Ref ref) => GoRoute(
  path: '/onboarding',
  pageBuilder: TransitionPageBuilders.sliding(
    builder: (_, __) => const OnboardingIntroPage(),
  ),
  redirect: (_, __) {
    if (kIsWeb) return '/aktuelles';
    final prefs = ref.watch(sharedPreferencesProvider);
    final initialData = ref.read(initialStateProvider);

    final onboardingCompleted =
        prefs.getBool(onboardingIntroCompletedKey) ?? false;

    if (!onboardingCompleted) return '/onboarding-intro';

    if (onboardingCompleted) {
      return initialData.initialRoute ?? '/aktuelles';
    }

    return null;
  },
);

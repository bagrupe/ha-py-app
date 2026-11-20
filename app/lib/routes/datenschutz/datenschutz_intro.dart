import 'package:app/common/shared_preferences.dart';
import 'package:app/common/startup.dart';
import 'package:app/components/transition_page/transition_page_builders.dart';
import 'package:app/routes/datenschutz/datenschutz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Erzeugt eine Route für die Datenschutz-Einführungsseite.
/// Nutzt [ref] zum Zugriff auf Provider, um den Weiterleitungsstatus basierend auf gespeicherten Präferenzen zu bestimmen.
GoRoute datenschutzIntroRoute(Ref ref) => GoRoute(
  path: '/datenschutz-intro',
  pageBuilder: TransitionPageBuilders.sliding(
    builder: (_, __) => const DatenschutzerklaerungPage(),
  ),
  redirect: (_, __) {
    if (kIsWeb) return '/aktuelles';
    final prefs = ref.watch(sharedPreferencesProvider);
    final initialData = ref.read(initialStateProvider);

    final dsgvoGelesen = prefs.getBool(dsgvoGelesenKey) ?? false;

    if (!dsgvoGelesen) return '/datenschutz';

    if (dsgvoGelesen) {
      return initialData.initialRoute ?? '/onboarding';
    }
    return null;
  },
);

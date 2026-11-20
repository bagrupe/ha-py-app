// ignore_for_file: unawaited_futures, cascade_invocations

import 'package:app/common/abfall/abfall_filter.dart';
import 'package:app/common/abfall/abfall_notifications.dart';
import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/auth/auth.dart';
import 'package:app/common/auth/mitteilungen_provider.dart';
import 'package:app/common/extensions/graphql_client.dart';
import 'package:app/common/gemeinde_prefs.dart';
import 'package:app/common/kommune.dart';
import 'package:app/common/notifications/firebase_push.dart';
import 'package:app/common/notifications/notifications.dart';
import 'package:app/common/poi_category_prefs.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/common/volunteer_database/volunteer_database_enabled_notifier.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/router.dart';
import 'package:app/routes/datenschutz/datenschutz.dart';
import 'package:app/routes/karte/karte.dart';
import 'package:app/routes/onboarding/onboarding_intro.dart';
import 'package:app/routes/termine/components/veranstaltung/veranstaltungen_filter_sheet.dart';
import 'package:app/routes/volunteer_database/views/eb_preview.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Widget für die Entwicklerkonsole zur Anzeige und Steuerung von App-Konfigurationen und Debug-Optionen.
class DevConsole extends ConsumerStatefulWidget {
  const DevConsole({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DevConsoleState();
  }
}

/// State-Klasse für die Entwicklerkonsole, verwaltet UI-Status und Interaktionen.
class _DevConsoleState extends ConsumerState<DevConsole> {
  final TextEditingController textEditingControllerA = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    final kommuneId = config.kommuneId;
    final textTheme = Theme.of(context).textTheme;
    textEditingControllerA.text = config.backendUrl;

    final notifications = ref.watch(notificationsProvider);
    final abfallNotifications = ref.watch(abfallNotificationsProvider);
    final volunteerDatabaseEnabled = ref.watch(
      volunteerDatabaseEnabledProvider,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Dev Console')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (kDebugMode) ...[
              TextFormField(
                controller: textEditingControllerA,
                onFieldSubmitted: (value) {
                  ref.read(appConfigProvider.notifier).setBackendUrl(value);
                },
                decoration: const InputDecoration(
                  labelText: 'Backend URL (Bereich A)',
                  hintText: 'http://localhost:3000',
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () async {
                  await ref.read(asyncAuthProvider.notifier).devOnlyLogout();
                  if (context.mounted) context.go('/onboarding');
                },
                child: const Text('Ausloggen'),
              ),
              const SizedBox(height: 16),
            ],
            Text('Feature Flags', style: textTheme.headlineSmall),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Ehrenamtsdatenbank'),
              subtitle: const Text(
                'Steuert die Sichtbarkeit der Ehrenamtsdatenbank/Volunteer-Features',
              ),
              value: volunteerDatabaseEnabled,
              onChanged: (bool value) {
                ref
                    .read(volunteerDatabaseEnabledProvider.notifier)
                    .setEnabled(value);
              },
            ),
            if (volunteerDatabaseEnabled)
              OutlinedButton(
                onPressed: ref.watch(volunteerAuthProvider) != null
                    ? () {
                        ref.read(volunteerAuthProvider.notifier).signOut();
                        ref.read(routerProvider).go(EBPreviewPage.path);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ehrenamtsdatenbank ausgeloggt'),
                            ),
                          );
                        }
                      }
                    : null,
                child: const Text('Ehrenamtsdatenbank ausloggen'),
              ),
            const SizedBox(height: 16),
            const Text('Kommune'),
            DropdownButton<String>(
              value: kommuneIdByKommuneName.values.contains(kommuneId)
                  ? kommuneId
                  : null,
              onChanged: (String? value) {
                if (value != null) {
                  ref.read(appConfigProvider.notifier).setKommune(value);
                  removeAllPrefs(ref);
                }
              },
              items: kommuneIdByKommuneName.entries
                  .map<DropdownMenuItem<String>>((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.value,
                      child: Text(entry.key),
                    );
                  })
                  .toList(),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                ref.read(appConfigProvider.notifier).reset();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Zurückgesetzt')));
              },
              child: const Text('Einstellungen zurücksetzen'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                final prefs = ref.read(sharedPreferencesProvider);
                prefs.remove(AbfallFilterKeys.abfallFilter);
                prefs.remove(selectedCategoriesPrefsKey);

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Zurückgesetzt')));
              },
              child: const Text('Gespeicherte Filter zurücksetzen'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                final prefs = ref.read(sharedPreferencesProvider);

                final fieldKeys = prefs
                    .getKeys()
                    .where((key) => key.startsWith('field_'))
                    .toList();

                for (final key in fieldKeys) {
                  prefs.remove(key);
                }

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Zurückgesetzt')));
              },
              child: const Text('Gespeicherte Felder zurücksetzen'),
            ),
            if (isFirebasePushAvailable) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () async {
                  await FirebaseMessaging.instance.requestPermission(
                    provisional: true,
                  );
                  final notifications = ref.read(notificationsProvider);
                  await notifications.requestPermission();

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Benachrichtigungen aktiviert'),
                      ),
                    );
                  }
                },
                child: const Text('Benachrichtigungen aktivieren'),
              ),
            ],
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                final prefs = ref.watch(sharedPreferencesProvider);
                prefs.setBool(onboardingIntroCompletedKey, false);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Onboarding aktiviert')),
                  );
                }
              },
              child: const Text('Onboarding aktivieren'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                final prefs = ref.watch(sharedPreferencesProvider);
                prefs.setBool(dsgvoGelesenKey, false);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('DSGVO aktiviert')),
                  );
                }
              },
              child: const Text('DSGVO aktivieren'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                final prefs = ref.watch(sharedPreferencesProvider);
                prefs.setBool(karteIntroShownKey, false);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Karten Intro aktiviert')),
                  );
                }
              },
              child: const Text('Karten Intro aktivieren'),
            ),
            const SizedBox(height: 16),
            Text('Notifications', style: textTheme.headlineSmall),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () async {
                final prefs = ref.read(sharedPreferencesProvider);
                await prefs.remove(mitteilungenLastReadKey);

                final client = ref.read(graphqlClientProvider);
                await client.refetchByName('MyMitteilungen');

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Gesehene Mitteilungen zurückgesetzt'),
                    ),
                  );
                }
              },
              child: const Text('Gesehene Mitteilungen zurücksetzen'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () async {
                final result = await Permission.notification.request();
                if (result == PermissionStatus.denied ||
                    result == PermissionStatus.permanentlyDenied) {
                  openAppSettings();
                }
                await abfallNotifications.schedule();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Abfalltermine abonniert')),
                  );
                }
              },
              child: const Text('Abonniere Abfalltermine'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () async {
                final perm = await Permission.notification.request();
                if (perm == PermissionStatus.denied ||
                    perm == PermissionStatus.permanentlyDenied) {
                  openAppSettings();
                }
                tz_data.initializeTimeZones();
                final berlin = tz.getLocation('Europe/Berlin');
                final when = tz.TZDateTime.now(
                  berlin,
                ).add(const Duration(seconds: 15));
                const testId = 777888001;
                await notifications.schedule(
                  testId,
                  'Abfall (Test)',
                  'Mock: Restmüll – gleicher Kanal/Stack wie echte Abfall-Pushes',
                  when,
                  'abfall',
                  'Abfall',
                  'Benachrichtigungen für die Abfallentsorgungstermine',
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Test geplant für ${when.hour.toString().padLeft(2, '0')}:'
                        '${when.minute.toString().padLeft(2, '0')}:'
                        '${when.second.toString().padLeft(2, '0')} '
                        '(Europe/Berlin), ID $testId',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Test: Abfall-Benachrichtigung in 15 s'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () async {
                await abfallNotifications.deletePending();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'ausstehende Push Notifications für Abfallterminegelöscht',
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                'Lösche ausstehende Push Notifications für Abfalltermine',
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () async {
                await notifications.deleteAllNotifications();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Alle ausstehenden Notifications gelöscht'),
                    ),
                  );
                }
              },
              child: const Text('Lösche alle ausstehenden Notifications'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () async {
                await notifications.printPendingNotifications();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ausstehende Notifications in der Konsole'),
                    ),
                  );
                }
              },
              child: const Text(
                'Zeige ausstehende Notifications in der Konsole',
              ),
            ),
            if (isFirebasePushAvailable) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () async {
                  await notifications.resetToken();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Neues Token: ${notifications.token}'),
                    ),
                  );
                },
                child: const Text('FCM Token zurücksetzen'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'FCM Token: ${ref.watch(notificationsProvider).token}',
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 10),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    textEditingControllerA.dispose();
  }
}

/// Route für die Entwicklerkonsole.
final devConsoleRoute = GoRoute(
  path: '/dev',
  builder: (BuildContext context, GoRouterState state) {
    return const DevConsole();
  },
  parentNavigatorKey: rootNavigatorKey,
);

/// Entfernt alle gespeicherten Präferenzen und setzt Filter zurück.
/// [ref] wird für den Zugriff auf Provider benötigt.
void removeAllPrefs(WidgetRef ref) {
  final poiCategoryFilterNotifier = ref.watch(
    poiCategoryFilterProvider.notifier,
  );
  final gemeindeFilterNotifier = ref.watch(gemeindeFilterProvider.notifier);
  final prefs = ref.read(sharedPreferencesProvider);
  prefs.remove(onboardingIntroCompletedKey);
  prefs.remove(selectedCategoriesPrefsKey);
  prefs.remove(AbfallFilterKeys.abfallFilter);
  poiCategoryFilterNotifier.updatePoiCategories([]);
  gemeindeFilterNotifier.updateGemeindeFilter([]);
  ref.read(volunteerDatabaseEnabledProvider.notifier).reset();
}

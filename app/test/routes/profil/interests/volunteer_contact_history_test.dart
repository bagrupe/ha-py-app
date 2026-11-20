import 'package:app/common/shared_preferences.dart';
import 'package:app/routes/profil/interests/volunteer_contact_history_provider.dart';
import 'package:app/routes/profil/interests/volunteer_whatsapp_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Verifies persistent introductions independently of request status.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Method channel used by the external URL launcher in tests.
  const channel = MethodChannel('plugins.flutter.io/url_launcher');

  /// URLs passed to the external application launcher.
  late List<Uri> launchedUris;

  /// Whether the external application accepts the launch.
  late bool launchSucceeds;

  /// Persisted preferences shared across simulated app restarts.
  late SharedPreferences preferences;

  /// Provider container for the current simulated app session.
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
    );
    launchedUris = [];
    launchSucceeds = true;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          final arguments = call.arguments as Map;
          launchedUris.add(Uri.parse(arguments['url'] as String));
          return launchSucceeds;
        });
  });

  tearDown(() {
    container.dispose();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  /// Opens a chat and records only a successful external launch.
  Future<bool> contact(VolunteerContactHistoryKey key) async {
    final provider = volunteerContactHistoryProvider(key);
    final opened = await VolunteerWhatsAppLauncher.open(
      phoneNumber: '+43 123 456',
      message: container.read(provider) ? null : 'Introduction',
    );
    if (opened) await container.read(provider.notifier).markOpened();
    return opened;
  }

  test(
    'only the first launch includes text, including after restart',
    () async {
      const key = (userId: 'user', entryId: 'entry');
      await contact(key);
      expect(launchedUris.single.queryParameters['text'], 'Introduction');
      await contact(key);
      expect(launchedUris.last.hasQuery, isFalse);

      container.dispose();
      container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      );
      await contact(key);
      expect(launchedUris.last.hasQuery, isFalse);
      expect(launchedUris.last.path, '/43123456');
    },
  );

  test('another entry or user gets their own introduction', () async {
    await contact((userId: 'user', entryId: 'entry'));
    await contact((userId: 'user', entryId: 'other-entry'));
    await contact((userId: 'other-user', entryId: 'entry'));
    expect(
      launchedUris.map((uri) => uri.queryParameters['text']),
      everyElement('Introduction'),
    );
  });

  test('a failed launch does not consume the introduction', () async {
    const key = (userId: 'user', entryId: 'entry');
    launchSucceeds = false;
    expect(await contact(key), isFalse);
    expect(container.read(volunteerContactHistoryProvider(key)), isFalse);
    launchSucceeds = true;
    await contact(key);
    expect(launchedUris.last.queryParameters['text'], 'Introduction');
  });
}

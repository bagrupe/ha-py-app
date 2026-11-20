import 'package:app/common/auth/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('migrateFromSecureStorageToSharedPrefs', () {
    setUp(() {
      // Start each test with empty stores.
      SharedPreferences.setMockInitialValues({});
      FlutterSecureStorage.setMockInitialValues({});
    });

    test(
      'kopiert die BürgerID aus dem SecureStorage in die SharedPreferences',
      () async {
        FlutterSecureStorage.setMockInitialValues({
          secureWeakLoginIdPrefsKey: 'test-buerger-id',
        });

        await migrateFromSecureStorageToSharedPrefs();

        final prefs = await SharedPreferences.getInstance();
        expect(
          prefs.getString(secureWeakLoginIdPrefsKey),
          equals('test-buerger-id'),
        );
      },
    );

    test(
      'löscht die BürgerID aus dem SecureStorage nach der Migration',
      () async {
        FlutterSecureStorage.setMockInitialValues({
          secureWeakLoginIdPrefsKey: 'test-buerger-id',
        });

        await migrateFromSecureStorageToSharedPrefs();

        const storage = FlutterSecureStorage();
        final remaining = await storage.read(key: secureWeakLoginIdPrefsKey);
        expect(remaining, isNull);
      },
    );

    test(
      'ist eine No-op wenn keine BürgerID im SecureStorage vorhanden ist',
      () async {
        // SecureStorage is empty (set in setUp).
        await migrateFromSecureStorageToSharedPrefs();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString(secureWeakLoginIdPrefsKey), isNull);
      },
    );

    test(
      'lässt kryptographische Schlüssel im SecureStorage unberührt',
      () async {
        FlutterSecureStorage.setMockInitialValues({
          secureWeakLoginIdPrefsKey: 'test-buerger-id',
          secureWeakLoginTokenPrefsKey: 'secret-token',
          secureDerivedServerLoginPasswordKey: 'derived-password',
          securePasswordDerivationIterationCountKey: '100000',
        });

        await migrateFromSecureStorageToSharedPrefs();

        const storage = FlutterSecureStorage();
        expect(
          await storage.read(key: secureWeakLoginTokenPrefsKey),
          equals('secret-token'),
          reason: 'weak login token muss im SecureStorage bleiben',
        );
        expect(
          await storage.read(key: secureDerivedServerLoginPasswordKey),
          equals('derived-password'),
          reason: 'abgeleitetes Passwort muss im SecureStorage bleiben',
        );
        expect(
          await storage.read(key: securePasswordDerivationIterationCountKey),
          equals('100000'),
          reason: 'Iterationszahl muss im SecureStorage bleiben',
        );
      },
    );

    test('überschreibt keinen bestehenden SharedPreferences-Wert wenn '
        'SecureStorage leer ist (bereits migriert oder Neuinstallation)', () async {
      SharedPreferences.setMockInitialValues({
        secureWeakLoginIdPrefsKey: 'already-migrated-id',
      });
      // SecureStorage is empty — simulates a second app launch after migration.

      await migrateFromSecureStorageToSharedPrefs();

      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getString(secureWeakLoginIdPrefsKey),
        equals('already-migrated-id'),
        reason:
            'Bereits migrierte ID darf nicht überschrieben oder gelöscht werden',
      );
    });

    test('Neuinstallation: SharedPreferences ist leer, SecureStorage ist leer '
        '→ kein Credential vorhanden', () async {
      // Both stores empty — fresh install.
      await migrateFromSecureStorageToSharedPrefs();

      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getString(secureWeakLoginIdPrefsKey),
        isNull,
        reason: 'Nach Neuinstallation darf keine alte BürgerID vorhanden sein',
      );
    });
  });
}

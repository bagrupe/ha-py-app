import 'package:app/common/shared_preferences.dart';
import 'package:app/common/volunteer_database/pilot_project_unlock_notifier.dart';
import 'package:app/common/volunteer_database/volunteer_database.dart';
import 'package:app/common/volunteer_database/volunteer_database_enabled_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Verifies device activation, persistence and the shared navigation gate.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('invalid and empty codes do not unlock or persist activation', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
    );
    addTearDown(container.dispose);
    final notifier = container.read(pilotProjectUnlockedProvider.notifier);

    for (final code in ['', ' ', 'invalid', '4713 0893']) {
      expect(await notifier.redeem(code), isFalse);
    }
    expect(container.read(pilotProjectUnlockedProvider), isFalse);
    expect(
      container.read(volunteerDatabaseEnabledProvider),
      VolunteerDataBase.isEnabled,
    );
    expect(
      preferences.getBool(PilotProjectUnlockNotifier.preferenceKey),
      isNull,
    );
  });

  for (final code in ['47130892', '  4713 0892  ', ' 47 13\t08 92 ']) {
    test(
      'code "$code" unlocks immediately and survives provider recreation',
      () async {
        SharedPreferences.setMockInitialValues({});
        final preferences = await SharedPreferences.getInstance();
        final container = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
        );
        addTearDown(container.dispose);
        final changes = <bool>[];
        container.listen(volunteerDatabaseEnabledProvider, (_, next) {
          changes.add(next);
        });

        expect(
          await container
              .read(pilotProjectUnlockedProvider.notifier)
              .redeem(code),
          isTrue,
        );
        expect(container.read(volunteerDatabaseEnabledProvider), isTrue);
        if (!VolunteerDataBase.isEnabled) expect(changes, [true]);
        expect(
          preferences.getBool(PilotProjectUnlockNotifier.preferenceKey),
          isTrue,
        );

        final restarted = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
        );
        addTearDown(restarted.dispose);
        expect(restarted.read(pilotProjectUnlockedProvider), isTrue);
        expect(restarted.read(volunteerDatabaseEnabledProvider), isTrue);
        await restarted.read(volunteerDatabaseEnabledProvider.notifier).reset();
        expect(restarted.read(volunteerDatabaseEnabledProvider), isTrue);
      },
    );
  }
}

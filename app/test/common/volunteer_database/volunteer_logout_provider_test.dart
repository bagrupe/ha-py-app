import 'package:app/common/auth/auth.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/common/volunteer_database/volunteer_auth_repository.dart';
import 'package:app/common/volunteer_database/volunteer_logout_provider.dart';
import 'package:app/routes/profil/my_account/my_account_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/delayed_sign_out_notifier.dart';

/// Verifies that navigating away does not interrupt session cleanup.
void main() {
  testWidgets('finishes logout after the initiating widget is unmounted', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      volunteerAuthUserIdStorageKey: 'volunteer-user',
    });
    final preferences = await SharedPreferences.getInstance();
    final auth = DelayedSignOutNotifier();
    var profileLoads = 0;
    var sessionLoads = 0;
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        asyncAuthProvider.overrideWith(() => auth),
        hasStrongSessionProvider.overrideWith((ref) async {
          sessionLoads++;
          return !auth.completion.isCompleted;
        }),
        myAccountProfileProvider.overrideWith((ref) async {
          profileLoads++;
          return null;
        }),
      ],
    );
    addTearDown(container.dispose);
    await container.read(asyncAuthProvider.future);
    await container.read(hasStrongSessionProvider.future);
    await container.read(myAccountProfileProvider.future);

    late Future<void> Function() logout;
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Consumer(
          builder: (context, ref, child) {
            logout = ref.read(volunteerLogoutProvider);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final pendingLogout = logout();
    expect(container.read(volunteerAuthProvider), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    auth.completion.complete();
    await pendingLogout;
    await tester.pump();

    expect(await container.read(hasStrongSessionProvider.future), isFalse);
    await container.read(myAccountProfileProvider.future);
    expect(sessionLoads, 2);
    expect(profileLoads, 2);
    expect(preferences.getString(volunteerAuthUserIdStorageKey), isNull);
    await tester.pump(const Duration(milliseconds: 1));
    expect(tester.takeException(), isNull);
  });
}

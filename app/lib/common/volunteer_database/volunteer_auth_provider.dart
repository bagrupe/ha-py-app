import 'package:app/common/auth/auth.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/common/volunteer_database/volunteer_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the volunteer auth repository.
final volunteerAuthRepositoryProvider = Provider((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return VolunteerAuthRepository(sharedPreferences);
});

/// Notifier for mock volunteer session state with device persistence.
///
/// Holds the authenticated [userId], or `null` when logged out.
class VolunteerAuthNotifier extends Notifier<String?> {
  @override
  String? build() {
    ref.listen(hasStrongSessionProvider, (previous, next) {
      final hasSession = next.value ?? true;
      if (!hasSession && state != null) {
        signOut();
      }
    });

    return ref.read(volunteerAuthRepositoryProvider).read();
  }

  void signIn([String userId = mockVolunteerUserId]) {
    state = userId;
    ref.read(volunteerAuthRepositoryProvider).write(userId);
  }

  /// Clears the volunteer session.
  void signOut() {
    state = null;
    ref.read(volunteerAuthRepositoryProvider).write(null);
  }
}

/// Provider for the volunteer database session user id.
///
/// `null` means logged out; a non-null value triggers profile fetching.
final volunteerAuthProvider = NotifierProvider<VolunteerAuthNotifier, String?>(
  VolunteerAuthNotifier.new,
);

import 'package:shared_preferences/shared_preferences.dart';

/// Legacy storage key for the mock volunteer authentication flag.
const volunteerAuthStorageKey = 'volunteer_auth_authenticated';

/// Storage key for the mock volunteer session user id.
const volunteerAuthUserIdStorageKey = 'volunteer_auth_user_id';

/// Mock user id used for local volunteer sessions.
const mockVolunteerUserId = 'mock-volunteer-user';

/// Repository for persisting mock volunteer authentication state.
///
/// Uses [SharedPreferences] for now and can be swapped for secure storage later.
class VolunteerAuthRepository {
  /// Creates a repository backed by the given [SharedPreferences] instance.
  VolunteerAuthRepository(SharedPreferences prefs) : _sharedPreferences = prefs;

  final SharedPreferences _sharedPreferences;

  /// Returns the stored volunteer session user id, or `null` if logged out.
  String? read() {
    final userId = _sharedPreferences.getString(volunteerAuthUserIdStorageKey);
    if (userId != null) {
      return userId;
    }

    // Migrate legacy bool flag from earlier mock auth.
    final legacyAuthenticated =
        _sharedPreferences.getBool(volunteerAuthStorageKey) ?? false;
    if (!legacyAuthenticated) {
      return null;
    }

    write(mockVolunteerUserId);
    _sharedPreferences.remove(volunteerAuthStorageKey);
    return mockVolunteerUserId;
  }

  /// Persists the given session user id, or clears it when [userId] is `null`.
  void write(String? userId) {
    if (userId == null) {
      _sharedPreferences.remove(volunteerAuthUserIdStorageKey);
      return;
    }
    _sharedPreferences.setString(volunteerAuthUserIdStorageKey, userId);
  }
}

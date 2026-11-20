import 'package:app/common/auth/personal_data.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the selected municipality value from the user's profile.
final profileGemeindeProvider = Provider<String?>((ref) {
  final personalData = ref.watch(personalDataProvider);
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  final personalDataValue = personalData?[PersonalDataKeys.gemeinde];
  final sharedPreferencesValue = sharedPreferences.getString(
    'field_${PersonalDataKeys.gemeinde}',
  );

  return sharedPreferencesValue ?? personalDataValue?.toString();
});

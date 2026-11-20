import 'package:app/common/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stores persistent WhatsApp contact consent for one match.
class VolunteerContactConsentNotifier extends Notifier<bool> {
  /// Creates a consent notifier for [interestId].
  VolunteerContactConsentNotifier(this.interestId);

  /// Backend identifier of the matched interest request.
  final String interestId;

  @override
  bool build() {
    return ref.read(sharedPreferencesProvider).getBool(_preferenceKey) ?? false;
  }

  /// Persists consent for the current match.
  Future<void> grant() async {
    await ref.read(sharedPreferencesProvider).setBool(_preferenceKey, true);
    state = true;
  }

  String get _preferenceKey => 'volunteer_contact_consent_$interestId';
}

/// Persistent contact consent keyed by match identifier.
final volunteerContactConsentProvider =
    NotifierProvider.family<VolunteerContactConsentNotifier, bool, String>(
      VolunteerContactConsentNotifier.new,
    );

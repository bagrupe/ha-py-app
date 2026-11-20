import 'package:app/common/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Identifies one user's contact history for a volunteer entry.
typedef VolunteerContactHistoryKey = ({String userId, String entryId});

/// Persists whether a user has opened WhatsApp for a volunteer entry.
class VolunteerContactHistoryNotifier extends Notifier<bool> {
  /// Creates contact history for [contactKey].
  VolunteerContactHistoryNotifier(this.contactKey);

  /// User and volunteer entry whose contact history is stored.
  final VolunteerContactHistoryKey contactKey;

  /// Storage key with separately encoded user and entry identifiers.
  String get _preferenceKey =>
      'volunteer_contact_opened_${Uri.encodeComponent(contactKey.userId)}/'
      '${Uri.encodeComponent(contactKey.entryId)}';

  @override
  bool build() =>
      ref.read(sharedPreferencesProvider).getBool(_preferenceKey) ?? false;

  /// Records a successful WhatsApp launch independently of request status.
  Future<void> markOpened() async {
    state = true;
    await ref.read(sharedPreferencesProvider).setBool(_preferenceKey, true);
  }
}

/// Persistent WhatsApp launch history keyed by user and volunteer entry.
final volunteerContactHistoryProvider =
    NotifierProvider.family<
      VolunteerContactHistoryNotifier,
      bool,
      VolunteerContactHistoryKey
    >(VolunteerContactHistoryNotifier.new);

import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/common/volunteer_database/volunteer_profile_model.dart';
import 'package:app/common/volunteer_database/volunteer_profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Loads the volunteer profile for the active session.
///
/// Auto-dispose ensures time credits are not cached across unmounts
/// (zero-caching policy for time currency).
class VolunteerProfileNotifier extends AsyncNotifier<VolunteerProfileModel?> {
  @override
  Future<VolunteerProfileModel?> build() async {
    final userId = ref.watch(volunteerAuthProvider);
    if (userId == null) {
      return null;
    }

    return ref.read(volunteerProfileRepositoryProvider).getUserProfile(userId);
  }
}

/// Provider for the authenticated volunteer's profile.
final volunteerProfileProvider =
    AsyncNotifierProvider.autoDispose<
      VolunteerProfileNotifier,
      VolunteerProfileModel?
    >(VolunteerProfileNotifier.new);

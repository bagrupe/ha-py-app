import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/routes/volunteer_database/models/volunteer_interest_overview_model.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_interest_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Loads all sent and received volunteer interest requests.
class VolunteerInterestsNotifier
    extends AsyncNotifier<List<VolunteerInterestOverviewModel>> {
  @override
  Future<List<VolunteerInterestOverviewModel>> build() {
    final userId = ref.watch(volunteerAuthProvider);
    if (userId == null) return Future.value(const []);
    return ref.read(volunteerInterestRepositoryProvider).getInterests();
  }

  /// Reloads the overview from the backend.
  Future<void> refresh() async {
    state = const AsyncLoading<List<VolunteerInterestOverviewModel>>();
    state = await AsyncValue.guard(
      () => ref.read(volunteerInterestRepositoryProvider).getInterests(),
    );
  }
}

/// Backend-backed volunteer interest overview.
final volunteerInterestsProvider =
    AsyncNotifierProvider<
      VolunteerInterestsNotifier,
      List<VolunteerInterestOverviewModel>
    >(VolunteerInterestsNotifier.new);

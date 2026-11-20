import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/routes/profil/interests/volunteer_interests_provider.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_interest_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages a status-changing action for one volunteer interest request.
class VolunteerInterestActionNotifier extends AsyncNotifier<void> {
  /// Creates an action notifier for [interestId].
  VolunteerInterestActionNotifier(this.interestId);

  /// Backend identifier of the interest request.
  final String interestId;

  @override
  Future<void> build() async {}

  /// Updates the request to [status] and reloads the overview.
  Future<void> updateStatus(Enum_EhrenamtsbankAnfrageStatus status) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      await ref
          .read(volunteerInterestRepositoryProvider)
          .updateStatus(interestId: interestId, status: status);
      await ref.read(volunteerInterestsProvider.notifier).refresh();
    });
  }
}

/// Status-changing action state keyed by interest request identifier.
final volunteerInterestActionProvider =
    AsyncNotifierProvider.family<VolunteerInterestActionNotifier, void, String>(
      VolunteerInterestActionNotifier.new,
    );

import 'package:app/common/volunteer_database/volunteer_time_credit_provider.dart';
import 'package:app/routes/profil/interests/volunteer_completion_editing_provider.dart';
import 'package:app/routes/profil/interests/volunteer_interests_provider.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_interest_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages completion mutations for one volunteer interest request.
class VolunteerCompletionActionNotifier extends AsyncNotifier<void> {
  /// Creates an action notifier for [interestId].
  VolunteerCompletionActionNotifier(this.interestId);

  /// Backend identifier of the interest request.
  final String interestId;

  @override
  Future<void> build() async {}

  /// Submits a new completion proposal and refreshes the interest overview.
  Future<bool> propose({
    required int minutes,
    required DateTime performedOn,
    required String? note,
  }) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      await ref
          .read(volunteerInterestRepositoryProvider)
          .proposeCompletion(
            interestId: interestId,
            minutes: minutes,
            performedOn: performedOn,
            note: note,
          );
      await ref.read(volunteerInterestsProvider.notifier).refresh();
    });
    if (!state.hasError) {
      ref
          .read(volunteerCompletionEditingProvider(interestId).notifier)
          .cancel();
    }
    return !state.hasError;
  }

  /// Confirms the current counterparty proposal and refreshes the overview.
  Future<void> confirm() async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      await ref
          .read(volunteerInterestRepositoryProvider)
          .confirmCompletion(interestId: interestId);
    });
    if (state.hasError) return;
    ref
      ..invalidate(volunteerInterestsProvider)
      ..invalidate(volunteerTimeCreditProvider);
  }
}

/// Completion action state keyed by interest request identifier.
final volunteerCompletionActionProvider =
    AsyncNotifierProvider.family<
      VolunteerCompletionActionNotifier,
      void,
      String
    >(VolunteerCompletionActionNotifier.new);

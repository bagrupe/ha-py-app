import 'package:app/common/volunteer_database/graphql_volunteer_interest_repository.dart';
import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/common/volunteer_database/volunteer_interest_submission_exception.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/volunteer_database/models/volunteer_interest_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repository used for volunteer interest submissions.
final volunteerInterestRepositoryProvider =
    Provider<GraphqlVolunteerInterestRepository>(
      (ref) =>
          GraphqlVolunteerInterestRepository(ref.watch(graphqlClientProvider)),
    );

/// Submits interest for one volunteer entry.
class VolunteerInterestNotifier extends AsyncNotifier<VolunteerInterestModel?> {
  /// Creates a notifier for [entryId].
  VolunteerInterestNotifier(this.entryId);

  /// Backend identifier of the volunteer entry.
  final String entryId;

  @override
  Future<VolunteerInterestModel?> build() {
    final userId = ref.watch(volunteerAuthProvider);
    if (userId == null) return Future.value();
    return ref
        .read(volunteerInterestRepositoryProvider)
        .getInterestForEntry(entryId);
  }

  /// Removes a previous submission error before reopening the interest form.
  void clearSubmissionError() {
    if (state.error is VolunteerInterestSubmissionException) {
      state = const AsyncData(null);
    }
  }

  /// Sends interest and an optional [message] to the backend.
  Future<bool> submit(String? message) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(volunteerInterestRepositoryProvider)
          .createInterest(entryId: entryId, message: message),
    );
    return !state.hasError;
  }
}

/// Submission state for one volunteer entry.
final volunteerInterestProvider =
    AsyncNotifierProvider.family<
      VolunteerInterestNotifier,
      VolunteerInterestModel?,
      String
    >(VolunteerInterestNotifier.new);

import 'package:app/common/volunteer_database/volunteer_repository.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_submission.dart';
import 'package:app/routes/volunteer_database/providers/my_volunteer_requests_provider.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_marketplace_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Coordinates request submission and marketplace refreshes.
class VolunteerRequestSubmissionNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// Creates the request and submits the resulting draft for moderation.
  Future<void> submit(VolunteerRequestSubmission submission) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(volunteerRepositoryProvider).submitRequest(submission);
    });
    if (!state.hasError) {
      ref
        ..invalidate(volunteerMarketplaceViewModelProvider)
        ..invalidate(myVolunteerRequestsProvider);
    }
  }
}

/// Submission state for the volunteer request creation flow.
final volunteerRequestSubmissionProvider =
    NotifierProvider<VolunteerRequestSubmissionNotifier, AsyncValue<void>>(
      VolunteerRequestSubmissionNotifier.new,
    );

import 'package:app/routes/volunteer_database/providers/volunteer_request_submission_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Verifies the initial volunteer request submission state.
void main() {
  test('starts ready without emitting a submission loading state', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(volunteerRequestSubmissionProvider);

    expect(state, isA<AsyncData<void>>());
    expect(state.isLoading, isFalse);
    expect(state.hasError, isFalse);
  });
}

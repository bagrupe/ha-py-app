import 'package:app/routes/profil/interests/volunteer_completion_form_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Verifies completion form state and duration validation.
void main() {
  test('initializes a counterproposal from backend values', () {
    final parameters = (
      interestId: 'interest-id',
      initialMinutes: 135,
      initialDate: DateTime(2026, 8, 31),
      initialNote: 'Alles erledigt.',
    );
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(volunteerCompletionFormProvider(parameters));

    expect(state.durationMinutes, 135);
    expect(state.hasValidDuration, isTrue);
    expect(state.normalizedNote, 'Alles erledigt.');
  });

  test('updates the selected actual duration', () {
    final parameters = (
      interestId: 'interest-id',
      initialMinutes: 60,
      initialDate: DateTime(2026, 8, 31),
      initialNote: '',
    );
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final provider = volunteerCompletionFormProvider(parameters);

    container.read(provider.notifier).setDurationMinutes(75);

    expect(container.read(provider).durationMinutes, 75);
  });
}

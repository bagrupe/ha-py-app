import 'package:app/routes/profil/interests/volunteer_completion_form_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Initial values that uniquely identify one completion form state.
typedef VolunteerCompletionFormParameters = ({
  String interestId,
  int initialMinutes,
  DateTime initialDate,
  String initialNote,
});

/// Manages input for one completion proposal form.
class VolunteerCompletionFormNotifier
    extends Notifier<VolunteerCompletionFormState> {
  /// Creates a form notifier for [parameters].
  VolunteerCompletionFormNotifier(this.parameters);

  /// Stable form identity and initial values.
  final VolunteerCompletionFormParameters parameters;

  @override
  VolunteerCompletionFormState build() {
    return VolunteerCompletionFormState(
      durationMinutes: parameters.initialMinutes,
      performedOn: parameters.initialDate,
      note: parameters.initialNote,
    );
  }

  /// Updates the selected actual duration.
  void setDurationMinutes(int value) {
    state = state.copyWith(durationMinutes: value);
  }

  /// Updates the selected performance date.
  void setPerformedOn(DateTime value) {
    state = state.copyWith(performedOn: value);
  }

  /// Updates the optional proposal note.
  void setNote(String value) {
    state = state.copyWith(note: value);
  }
}

/// Form state keyed by request and proposal initial values.
final volunteerCompletionFormProvider =
    NotifierProvider.family<
      VolunteerCompletionFormNotifier,
      VolunteerCompletionFormState,
      VolunteerCompletionFormParameters
    >(VolunteerCompletionFormNotifier.new);

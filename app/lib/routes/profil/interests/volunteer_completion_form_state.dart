/// Immutable input state for a volunteer completion proposal.
class VolunteerCompletionFormState {
  /// Creates completion form state.
  const VolunteerCompletionFormState({
    required this.durationMinutes,
    required this.performedOn,
    required this.note,
  });

  /// Selected actual duration in minutes.
  final int durationMinutes;

  /// Selected date on which the help was performed.
  final DateTime performedOn;

  /// Optional note entered for the other party.
  final String note;

  /// Whether the selected duration is valid for submission.
  bool get hasValidDuration => durationMinutes > 0;

  /// Trimmed note, or `null` when the field is empty.
  String? get normalizedNote {
    final normalized = note.trim();
    return normalized.isEmpty ? null : normalized;
  }

  /// Returns state with selected values replaced.
  VolunteerCompletionFormState copyWith({
    int? durationMinutes,
    DateTime? performedOn,
    String? note,
  }) {
    return VolunteerCompletionFormState(
      durationMinutes: durationMinutes ?? this.durationMinutes,
      performedOn: performedOn ?? this.performedOn,
      note: note ?? this.note,
    );
  }
}

/// Completion proposal awaiting confirmation by the other party.
class VolunteerCompletionProposalModel {
  /// Creates a completion proposal.
  const VolunteerCompletionProposalModel({
    required this.minutes,
    required this.performedOn,
    required this.proposedById,
    this.note,
  });

  /// Proposed duration in minutes.
  final int minutes;

  /// Proposed date on which the help was performed.
  final DateTime performedOn;

  /// Optional note accompanying the proposal.
  final String? note;

  /// Identifier of the person who submitted the current proposal.
  final String proposedById;

  /// Whether the current proposal was submitted by [userId].
  bool wasProposedBy(String? userId) => userId == proposedById;
}

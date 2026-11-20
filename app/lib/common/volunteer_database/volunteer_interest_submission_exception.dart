/// Domain exception containing a localized user-facing error key.
class VolunteerInterestSubmissionException implements Exception {
  /// Creates a submission exception for [messageKey].
  const VolunteerInterestSubmissionException(this.messageKey);

  /// Translation key shown for this failure.
  final String messageKey;
}

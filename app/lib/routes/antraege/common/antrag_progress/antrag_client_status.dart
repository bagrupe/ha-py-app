part of 'antrag_progress.dart';

/// Status of the application in the client, controls progress and UI states.
enum AntragClientStatus {
  editing,

  /// State similar to `editing`, but all actions lead directly to the confirmation page.
  amending,
  confirming,
  paying,
  submitting,
  errorSubmitting,
  errorKeyUnavailable,
  errorKeyMismatch,
  submitted,
}

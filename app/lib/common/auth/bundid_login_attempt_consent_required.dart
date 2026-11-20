part of 'bundid_auth.dart';

/// Nothing is created yet, call [confirmBundIdRegistrationWithRetry] only after consent.
class BundIdLoginAttemptConsentRequired extends BundIdLoginAttempt {
  const BundIdLoginAttemptConsentRequired(this.token, this.suggestion);

  final String token;
  final BundIdProfileSuggestion suggestion;
}

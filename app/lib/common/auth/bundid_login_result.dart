part of 'bundid_auth.dart';

class BundIdLoginResult {
  const BundIdLoginResult(
    this.outcome, [
    this.message,
    this.isNewRegistration = false,
    this.profileSuggestion,
    this.phoneNumberCollision = false,
  ]);

  final BundIdLoginOutcome outcome;
  final String? message;
  final bool isNewRegistration;
  final BundIdProfileSuggestion? profileSuggestion;

  /// BundID's number already belonged to another account and was not taken over.
  final bool phoneNumberCollision;
}

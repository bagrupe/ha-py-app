part of 'phone_auth.dart';

class ValidateSmsCodeSuccess extends ValidateSmsCodeOutcome {
  ValidateSmsCodeSuccess(
    this.token, {
    required this.isNewRegistration,
    this.refreshToken,
  });

  final String token;

  final String? refreshToken;

  /// No account owned the number before, so no profile data exists yet.
  final bool isNewRegistration;
}

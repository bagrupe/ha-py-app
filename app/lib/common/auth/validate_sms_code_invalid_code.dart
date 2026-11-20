part of 'phone_auth.dart';

class ValidateSmsCodeInvalidCode extends ValidateSmsCodeOutcome {
  ValidateSmsCodeInvalidCode({this.remainingAttempts});

  final int? remainingAttempts;
}

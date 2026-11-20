part of 'phone_auth.dart';

class ValidateSmsCodeLocked extends ValidateSmsCodeOutcome {
  ValidateSmsCodeLocked({this.retryAfter});

  final Duration? retryAfter;
}

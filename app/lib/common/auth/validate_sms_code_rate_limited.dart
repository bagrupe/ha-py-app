part of 'phone_auth.dart';

class ValidateSmsCodeRateLimited extends ValidateSmsCodeOutcome {
  ValidateSmsCodeRateLimited({this.retryAfter});

  final Duration? retryAfter;
}

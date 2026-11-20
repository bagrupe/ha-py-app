part of 'phone_auth.dart';

class RequestSmsCodeRateLimited extends RequestSmsCodeOutcome {
  RequestSmsCodeRateLimited({this.retryAfter});

  final Duration? retryAfter;
}

part of 'phone_auth.dart';

/// Every SMS code request goes through [requestSmsCode], never the raw mutation.
sealed class RequestSmsCodeOutcome {}

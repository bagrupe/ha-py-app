import 'dart:math';

import 'package:app/common/auth/phone_auth.dart';
import 'package:easy_localization/easy_localization.dart';

typedef SmsErrorMessage = ({String key, Map<String, String>? args});

String formatWaitTime(Duration duration) {
  final seconds = max(1, duration.inSeconds);
  if (seconds < 60) {
    return 'application.common.wait_time.seconds'.plural(seconds);
  }
  return 'application.common.wait_time.minutes'.plural((seconds / 60).ceil());
}

SmsErrorMessage rateLimitMessage(String errorsPath, Duration? retryAfter) =>
    retryAfter == null
    ? (key: '$errorsPath.rate_limit', args: null)
    : (
        key: '$errorsPath.rate_limit_wait',
        args: {'wait': formatWaitTime(retryAfter)},
      );

SmsErrorMessage? codeErrorMessage(
  String errorsPath,
  ValidateSmsCodeOutcome outcome,
) => switch (outcome) {
  ValidateSmsCodeInvalidCode(:final remainingAttempts) =>
    remainingAttempts == null
        ? (key: '$errorsPath.code_wrong_generic', args: null)
        : (
            key: '$errorsPath.code_wrong',
            args: {'attempts': '$remainingAttempts'},
          ),
  ValidateSmsCodeLocked(:final retryAfter) =>
    retryAfter == null
        ? (key: '$errorsPath.code_locked_generic', args: null)
        : (
            key: '$errorsPath.code_locked',
            args: {'wait': formatWaitTime(retryAfter)},
          ),
  ValidateSmsCodeRateLimited(:final retryAfter) => rateLimitMessage(
    errorsPath,
    retryAfter,
  ),
  ValidateSmsCodeFailure() => (
    key: '$errorsPath.code_check_failed',
    args: null,
  ),
  _ => null,
};

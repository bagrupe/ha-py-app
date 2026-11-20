import 'package:app/common/auth/phone_auth.dart';
import 'package:app/common/auth/sms_error_message.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper/localization_helper.dart';

const _errors = 'page.errors';

void main() {
  setUpAll(TestLocalizationHelper.init);

  group('formatWaitTime', () {
    test('uses seconds below a minute and rounds minutes up', () {
      expect(formatWaitTime(const Duration(seconds: 1)), '1 Sekunde');
      expect(formatWaitTime(const Duration(seconds: 30)), '30 Sekunden');
      expect(formatWaitTime(const Duration(seconds: 60)), '1 Minute');
      expect(formatWaitTime(const Duration(seconds: 61)), '2 Minuten');
      expect(formatWaitTime(const Duration(minutes: 15)), '15 Minuten');
    });

    test('never shows zero seconds', () {
      expect(formatWaitTime(Duration.zero), '1 Sekunde');
    });
  });

  group('rendered texts', () {
    String render(SmsErrorMessage message) =>
        message.key.tr(namedArgs: message.args);

    test('a wrong code and a lock read as plain sentences', () {
      const errors = 'application.volunteer_database.login_page.errors';

      expect(
        render(
          codeErrorMessage(
            errors,
            ValidateSmsCodeInvalidCode(remainingAttempts: 3),
          )!,
        ),
        'Der Code ist nicht korrekt. Verbleibende Versuche: 3.',
      );
      expect(
        render(
          codeErrorMessage(
            errors,
            ValidateSmsCodeLocked(retryAfter: const Duration(minutes: 15)),
          )!,
        ),
        'Zu viele falsche Eingaben. Du kannst es in 15 Minuten erneut versuchen.',
      );
      expect(
        render(rateLimitMessage(errors, const Duration(seconds: 40))),
        'Bitte warte noch 40 Sekunden, bevor du es erneut versuchst.',
      );
    });
  });

  group('codeErrorMessage', () {
    test('wrong code names the remaining attempts', () {
      final message = codeErrorMessage(
        _errors,
        ValidateSmsCodeInvalidCode(remainingAttempts: 2),
      );

      expect(message?.key, '$_errors.code_wrong');
      expect(message?.args, {'attempts': '2'});
    });

    test('wrong code without a count uses the plain text', () {
      final message = codeErrorMessage(_errors, ValidateSmsCodeInvalidCode());

      expect(message?.key, '$_errors.code_wrong_generic');
      expect(message?.args, isNull);
    });

    test('lock with a time shows the wait', () {
      final message = codeErrorMessage(
        _errors,
        ValidateSmsCodeLocked(retryAfter: const Duration(minutes: 15)),
      );

      expect(message?.key, '$_errors.code_locked');
      expect(message?.args?.keys, ['wait']);
    });

    test('lock without a time uses the plain text', () {
      final message = codeErrorMessage(_errors, ValidateSmsCodeLocked());

      expect(message?.key, '$_errors.code_locked_generic');
    });

    test('rate limit shows the wait or falls back to the plain text', () {
      final withTime = codeErrorMessage(
        _errors,
        ValidateSmsCodeRateLimited(retryAfter: const Duration(seconds: 30)),
      );
      final withoutTime = codeErrorMessage(
        _errors,
        ValidateSmsCodeRateLimited(),
      );

      expect(withTime?.key, '$_errors.rate_limit_wait');
      expect(withoutTime?.key, '$_errors.rate_limit');
    });

    test('a failure is no longer reported as a wrong code', () {
      final message = codeErrorMessage(_errors, ValidateSmsCodeFailure());

      expect(message?.key, '$_errors.code_check_failed');
    });

    test('outcomes with their own handling produce no code error', () {
      expect(codeErrorMessage(_errors, ValidateSmsCodeExpired()), isNull);
      expect(
        codeErrorMessage(_errors, ValidateSmsCodeNoCodeRequested()),
        isNull,
      );
    });
  });
}

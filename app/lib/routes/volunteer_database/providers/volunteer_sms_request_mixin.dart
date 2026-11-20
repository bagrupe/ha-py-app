import 'dart:async';

import 'package:app/common/auth/phone_auth.dart';
import 'package:app/common/auth/sms_error_message.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shares SMS requests, number review, errors, and cooldowns across auth flows.
mixin VolunteerSmsRequestMixin<State> on Notifier<State> {
  /// The local phone number currently entered in the form.
  String get enteredPhoneNumber;

  /// The normalized number that last received a code successfully.
  String get requestedPhoneNumber;

  /// Whether an authentication request is already running.
  bool get isSmsRequestLoading;

  /// Seconds remaining before an explicit resend is allowed.
  int get smsResendSecondsRemaining;

  /// Translation namespace used by the owning authentication screen.
  String get smsErrorPrefix;

  /// Updates the owning flow after a request or a return to code entry.
  void updateSmsRequest({
    bool isLoading = false,
    bool showCodeEntry = false,
    String? sentPhoneNumber,
    String? errorMessageKey,
    Map<String, String>? errorMessageArgs,
    String? phoneErrorMessageKey,
  });

  /// Updates the remaining resend cooldown in the owning flow.
  void updateSmsResendSeconds(int seconds);

  /// Timer for the current flow's resend cooldown.
  Timer? _smsResendTimer;

  /// Registers cleanup for this flow's resend timer.
  void initializeSmsRequests() {
    ref.onDispose(() => _smsResendTimer?.cancel());
  }

  /// Returns to the existing code or requests one for a changed number.
  Future<void> sendSmsCode() async {
    if (isSmsRequestLoading) return;
    final digits = enteredPhoneNumber.replaceAll(RegExp('[^0-9]'), '');
    if (digits.length < minGermanMobileNumberDigits) {
      updateSmsRequest(
        errorMessageKey: '$smsErrorPrefix.form',
        phoneErrorMessageKey: '$smsErrorPrefix.invalid_phone',
      );
      return;
    }
    final phoneNumber = '+49$digits';
    if (phoneNumber == requestedPhoneNumber) {
      updateSmsRequest(showCodeEntry: true);
      return;
    }
    await _requestCode(phoneNumber, isResend: false);
  }

  /// Explicitly requests another code once the cooldown has elapsed.
  Future<void> resendCode() async {
    if (smsResendSecondsRemaining > 0 || isSmsRequestLoading) return;
    await _requestCode(requestedPhoneNumber, isResend: true);
  }

  /// Requests a code and maps backend outcomes consistently for both flows.
  Future<void> _requestCode(
    String phoneNumber, {
    required bool isResend,
  }) async {
    updateSmsRequest(isLoading: true);
    final outcome = await requestSmsCode(
      ref.read(graphqlClientProvider),
      phoneNumber,
    );
    if (!ref.mounted) return;
    if (outcome is RequestSmsCodeSuccess) {
      updateSmsRequest(
        showCodeEntry: !isResend,
        sentPhoneNumber: isResend ? null : phoneNumber,
      );
      _startResendTimer();
      return;
    }
    final error = switch (outcome) {
      RequestSmsCodeSameAsCurrentNumber() => 'same_phone_number',
      RequestSmsCodeBundIdLoginRequired() => 'bundid_login_required',
      RequestSmsCodeInvalidPhone() => 'invalid_phone',
      RequestSmsCodeDeliveryFailed() => 'sms_delivery_failed',
      _ => 'form',
    };
    final isPhoneError =
        !isResend &&
        (outcome is RequestSmsCodeSameAsCurrentNumber ||
            outcome is RequestSmsCodeInvalidPhone ||
            outcome is RequestSmsCodeFailure);
    final rateLimit = outcome is RequestSmsCodeRateLimited
        ? rateLimitMessage(smsErrorPrefix, outcome.retryAfter)
        : null;
    updateSmsRequest(
      errorMessageKey:
          rateLimit?.key ??
          (isPhoneError
              ? outcome is RequestSmsCodeSameAsCurrentNumber
                    ? null
                    : '$smsErrorPrefix.form'
              : '$smsErrorPrefix.$error'),
      errorMessageArgs: rateLimit?.args,
      phoneErrorMessageKey: isPhoneError
          ? '$smsErrorPrefix.${outcome is RequestSmsCodeSameAsCurrentNumber ? 'same_phone_number' : 'invalid_phone'}'
          : null,
    );
  }

  /// Restarts the cooldown only after a successful backend request.
  void _startResendTimer() {
    _smsResendTimer?.cancel();
    updateSmsResendSeconds(59);
    _smsResendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remainingSeconds = smsResendSecondsRemaining;
      if (remainingSeconds <= 1) {
        timer.cancel();
        updateSmsResendSeconds(0);
        return;
      }
      updateSmsResendSeconds(remainingSeconds - 1);
    });
  }
}

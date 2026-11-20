import 'dart:async';

import 'package:app/common/auth/bundid_auth.dart';
import 'package:app/common/auth/phone_auth.dart';
import 'package:app/common/auth/sms_error_message.dart';
import 'package:app/common/auth/strong_session.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/volunteer_database/providers/bundid_onboarding/bundid_onboarding_state.dart';
import 'package:app/routes/volunteer_database/providers/bundid_onboarding/bundid_onboarding_step.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _errorsPath =
    'application.volunteer_database.bundid_onboarding_page.errors';

class BundIdOnboardingNotifier extends Notifier<BundIdOnboardingState> {
  Timer? _resendTimer;

  @override
  BundIdOnboardingState build() {
    ref.onDispose(_cancelResendTimer);
    return const BundIdOnboardingState();
  }

  void initializeFromSuggestion(
    BundIdProfileSuggestion? suggestion, {
    bool phoneNumberCollision = false,
  }) {
    if (state.isInitialized ||
        state.currentStep != BundIdOnboardingStep.phone) {
      return;
    }
    if (suggestion == null) {
      state = state.copyWith(
        isInitialized: true,
        phoneNumberCollision: phoneNumberCollision,
      );
      return;
    }

    state = state.copyWith(
      vorname: suggestion.vorname ?? '',
      nachname: suggestion.nachname ?? '',
      email: suggestion.email ?? '',
      street: suggestion.street ?? '',
      postalCode: suggestion.postalCode ?? '',
      city: suggestion.city ?? '',
      country: suggestion.country ?? '',
      phoneNumber: _toLocalNumber(suggestion.telephoneNumber ?? ''),
      isInitialized: true,
      phoneNumberCollision: phoneNumberCollision,
    );
  }

  String _toLocalNumber(String phoneNumber) {
    final trimmed = phoneNumber.trim();
    if (trimmed.startsWith('+49')) return trimmed.substring(3);
    if (trimmed.startsWith('0049')) return trimmed.substring(4);
    if (trimmed.startsWith('0')) return trimmed.substring(1);
    return trimmed;
  }

  void updatePhoneNumber(String value) {
    state = state.copyWith(
      phoneNumber: value,
      errorMessageKey: null,
      phoneErrorMessageKey: null,
    );
  }

  void updateSmsCode(String value) {
    state = state.copyWith(
      smsCode: value,
      errorMessageKey: null,
      smsCodeErrorMessageKey: null,
    );
  }

  void reviewPhoneNumber() {
    state = state.copyWith(
      currentStep: BundIdOnboardingStep.phone,
      errorMessageKey: null,
      smsCodeErrorMessageKey: null,
    );
  }

  Future<void> sendSmsCode() async {
    if (state.isLoading) return;

    final localDigits = state.phoneNumber.trim().replaceAll(
      RegExp('[^0-9]'),
      '',
    );
    if (localDigits.length < minGermanMobileNumberDigits) {
      state = state.copyWith(
        errorMessageKey:
            'application.volunteer_database.bundid_onboarding_page.errors.form',
        phoneErrorMessageKey:
            'application.volunteer_database.bundid_onboarding_page.errors.invalid_phone',
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessageKey: null);

    final fullPhoneNumber = '+49$localDigits';
    final outcome = await requestSmsCode(
      ref.read(graphqlClientProvider),
      fullPhoneNumber,
    );

    switch (outcome) {
      case RequestSmsCodeSameAsCurrentNumber():
        state = state.copyWith(
          isLoading: false,
          errorMessageKey:
              'application.volunteer_database.bundid_onboarding_page.errors.same_phone_number',
        );
        return;
      case RequestSmsCodeBundIdLoginRequired():
        state = state.copyWith(
          isLoading: false,
          errorMessageKey:
              'application.volunteer_database.bundid_onboarding_page.errors.bundid_login_required',
        );
        return;
      case RequestSmsCodeInvalidPhone():
        state = state.copyWith(
          isLoading: false,
          errorMessageKey:
              'application.volunteer_database.bundid_onboarding_page.errors.form',
          phoneErrorMessageKey:
              'application.volunteer_database.bundid_onboarding_page.errors.invalid_phone',
        );
        return;
      case RequestSmsCodeDeliveryFailed():
        state = state.copyWith(
          isLoading: false,
          errorMessageKey:
              'application.volunteer_database.bundid_onboarding_page.errors.sms_delivery_failed',
        );
        return;
      case RequestSmsCodeRateLimited(:final retryAfter):
        final message = rateLimitMessage(_errorsPath, retryAfter);
        state = state.copyWith(
          isLoading: false,
          errorMessageKey: message.key,
          errorMessageArgs: message.args,
        );
        return;
      case RequestSmsCodeFailure():
        state = state.copyWith(
          isLoading: false,
          errorMessageKey:
              'application.volunteer_database.bundid_onboarding_page.errors.form',
        );
        return;
      case RequestSmsCodeSuccess():
        break;
    }

    state = state.copyWith(
      isLoading: false,
      currentStep: BundIdOnboardingStep.sms,
      smsCode: '',
      smsCodePhoneNumber: fullPhoneNumber,
    );
    _startResendTimer();
  }

  Future<void> resendCode() async {
    if (state.resendSecondsRemaining > 0 || state.isLoading) {
      return;
    }

    state = state.copyWith(isLoading: true, errorMessageKey: null);

    final outcome = await requestSmsCode(
      ref.read(graphqlClientProvider),
      state.smsCodePhoneNumber,
    );

    switch (outcome) {
      case RequestSmsCodeSameAsCurrentNumber():
        state = state.copyWith(
          isLoading: false,
          errorMessageKey:
              'application.volunteer_database.bundid_onboarding_page.errors.same_phone_number',
        );
        return;
      case RequestSmsCodeBundIdLoginRequired():
        state = state.copyWith(
          isLoading: false,
          errorMessageKey:
              'application.volunteer_database.bundid_onboarding_page.errors.bundid_login_required',
        );
        return;
      case RequestSmsCodeInvalidPhone():
        state = state.copyWith(
          isLoading: false,
          errorMessageKey:
              'application.volunteer_database.bundid_onboarding_page.errors.invalid_phone',
        );
        return;
      case RequestSmsCodeDeliveryFailed():
        state = state.copyWith(
          isLoading: false,
          errorMessageKey:
              'application.volunteer_database.bundid_onboarding_page.errors.sms_delivery_failed',
        );
        return;
      case RequestSmsCodeRateLimited(:final retryAfter):
        final message = rateLimitMessage(_errorsPath, retryAfter);
        state = state.copyWith(
          isLoading: false,
          errorMessageKey: message.key,
          errorMessageArgs: message.args,
        );
        return;
      case RequestSmsCodeFailure():
        state = state.copyWith(
          isLoading: false,
          errorMessageKey:
              'application.volunteer_database.bundid_onboarding_page.errors.form',
        );
        return;
      case RequestSmsCodeSuccess():
        state = state.copyWith(isLoading: false);
        _startResendTimer();
    }
  }

  /// No request needed, the BundID exchange already stored the profile.
  void saveProfile() {
    state = state.copyWith(isCompleted: true);
  }

  Future<void> confirmAndCompleteProfile() async {
    if (state.isLoading || state.smsCode.length != 6) {
      if (state.smsCode.length != 6) {
        state = state.copyWith(
          errorMessageKey:
              'application.volunteer_database.bundid_onboarding_page.errors.form',
          smsCodeErrorMessageKey:
              'application.volunteer_database.bundid_onboarding_page.errors.invalid_code',
        );
      }
      return;
    }

    state = state.copyWith(
      isLoading: true,
      errorMessageKey: null,
      requiresBundIdReverification: false,
    );

    final container = ref.container;
    final outcome = await validateSmsCode(
      ref.read(graphqlClientProvider),
      telephoneNumber: state.smsCodePhoneNumber,
      code: state.smsCode,
    );

    if (outcome case ValidateSmsCodeSuccess(
      :final token,
      :final refreshToken,
    )) {
      await activateStrongSession(
        container,
        token: token,
        refreshToken: refreshToken,
      );
    }
    if (!ref.mounted) return;

    switch (outcome) {
      case ValidateSmsCodeSuccess():
        state = state.copyWith(isLoading: false, isCompleted: true);
      case ValidateSmsCodeRequiresBundIdReverification():
        state = state.copyWith(
          isLoading: false,
          requiresBundIdReverification: true,
        );
      case ValidateSmsCodeExpired():
        state = state.copyWith(
          isLoading: false,
          errorMessageKey: '$_errorsPath.form',
          smsCodeErrorMessageKey: '$_errorsPath.code_expired',
        );
      case ValidateSmsCodeNoCodeRequested():
        state = state.copyWith(
          isLoading: false,
          errorMessageKey: '$_errorsPath.form',
          smsCodeErrorMessageKey: '$_errorsPath.no_code_requested',
        );
      case ValidateSmsCodeInvalidCode() ||
          ValidateSmsCodeLocked() ||
          ValidateSmsCodeRateLimited() ||
          ValidateSmsCodeFailure():
        final message = codeErrorMessage(_errorsPath, outcome)!;
        state = state.copyWith(
          isLoading: false,
          errorMessageKey: '$_errorsPath.form',
          smsCodeErrorMessageKey: message.key,
          smsCodeErrorArgs: message.args,
        );
    }
  }

  void _startResendTimer() {
    _cancelResendTimer();
    state = state.copyWith(resendSecondsRemaining: 59);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remainingSeconds = state.resendSecondsRemaining;
      if (remainingSeconds <= 1) {
        _cancelResendTimer();
        state = state.copyWith(resendSecondsRemaining: 0);
        return;
      }

      state = state.copyWith(resendSecondsRemaining: remainingSeconds - 1);
    });
  }

  void _cancelResendTimer() {
    _resendTimer?.cancel();
    _resendTimer = null;
  }
}

final bundIdOnboardingProvider =
    NotifierProvider.autoDispose<
      BundIdOnboardingNotifier,
      BundIdOnboardingState
    >(BundIdOnboardingNotifier.new);

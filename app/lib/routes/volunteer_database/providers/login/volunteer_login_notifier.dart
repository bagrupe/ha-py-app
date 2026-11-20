import 'package:app/common/auth/phone_auth.dart';
import 'package:app/common/auth/sms_error_message.dart';
import 'package:app/common/auth/strong_session.dart';
import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/graphql/__generated__/bundid.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/profil/my_account/my_account_provider.dart';
import 'package:app/routes/volunteer_database/providers/login/volunteer_login_result.dart';
import 'package:app/routes/volunteer_database/providers/login/volunteer_login_state.dart';
import 'package:app/routes/volunteer_database/providers/login/volunteer_login_step.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_sms_request_mixin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VolunteerLoginNotifier extends Notifier<VolunteerLoginState>
    with VolunteerSmsRequestMixin<VolunteerLoginState> {
  @override
  VolunteerLoginState build() {
    initializeSmsRequests();
    return const VolunteerLoginState();
  }

  /// Updates the entered phone number.
  void updatePhoneNumber(String value) {
    state = state.copyWith(
      phoneNumber: value,
      errorMessageKey: null,
      phoneErrorMessageKey: null,
      loginResult: null,
    );
  }

  /// Updates the entered SMS verification code.
  void updateSmsCode(String value) {
    state = state.copyWith(
      smsCode: value,
      errorMessageKey: null,
      smsCodeErrorMessageKey: null,
      loginResult: null,
    );
  }

  void updateFirstName(String value) {
    state = state.copyWith(
      firstName: value,
      errorMessageKey: null,
      firstNameErrorMessageKey: null,
      loginResult: null,
    );
  }

  void updateLastName(String value) {
    state = state.copyWith(
      lastName: value,
      errorMessageKey: null,
      lastNameErrorMessageKey: null,
      loginResult: null,
    );
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value, loginResult: null);
  }

  void updateStreet(String value) {
    state = state.copyWith(street: value, loginResult: null);
  }

  void updatePostalCode(String value) {
    state = state.copyWith(postalCode: value, loginResult: null);
  }

  void updateCity(String value) {
    state = state.copyWith(city: value, loginResult: null);
  }

  void updateCountry(String value) {
    state = state.copyWith(country: value, loginResult: null);
  }

  void updateAgeConfirmation({required bool value}) {
    state = state.copyWith(
      isAgeConfirmed: value,
      errorMessageKey: null,
      ageConfirmationErrorMessageKey: value
          ? null
          : state.ageConfirmationErrorMessageKey,
      loginResult: null,
    );
  }

  /// Submits the current login step.
  Future<void> continueLogin() async {
    if (!state.canContinue || state.isLoading) {
      _showIncompleteStepError();
      return;
    }

    switch (state.currentStep) {
      case VolunteerLoginStep.phone:
        await sendSmsCode();
        return;
      case VolunteerLoginStep.sms:
        await _verifySmsCode();
        return;
      case VolunteerLoginStep.identity:
        await _submitProfile();
        return;
      case VolunteerLoginStep.completed:
        return;
    }
  }

  /// Returns the flow to the phone number step.
  void reviewPhoneNumber() {
    state = state.copyWith(
      currentStep: VolunteerLoginStep.phone,
      errorMessageKey: null,
      smsCodeErrorMessageKey: null,
      loginResult: null,
      requiresBundIdReverification: false,
    );
  }

  @override
  String get enteredPhoneNumber => state.phoneNumber;

  @override
  String get requestedPhoneNumber => state.smsCodePhoneNumber;

  @override
  bool get isSmsRequestLoading => state.isLoading;

  @override
  int get smsResendSecondsRemaining => state.resendSecondsRemaining;

  @override
  String get smsErrorPrefix =>
      'application.volunteer_database.login_page.errors';

  @override
  void updateSmsRequest({
    bool isLoading = false,
    bool showCodeEntry = false,
    String? sentPhoneNumber,
    String? errorMessageKey,
    Map<String, String>? errorMessageArgs,
    String? phoneErrorMessageKey,
  }) {
    state = state.copyWith(
      isLoading: isLoading,
      currentStep: showCodeEntry ? VolunteerLoginStep.sms : null,
      smsCode: sentPhoneNumber == null ? null : '',
      smsCodePhoneNumber: sentPhoneNumber,
      errorMessageKey: errorMessageKey,
      errorMessageArgs: errorMessageArgs,
      phoneErrorMessageKey: phoneErrorMessageKey,
    );
  }

  @override
  void updateSmsResendSeconds(int seconds) {
    state = state.copyWith(resendSecondsRemaining: seconds);
  }

  Future<void> _verifySmsCode() async {
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
      :final isNewRegistration,
    )) {
      await activateStrongSession(
        container,
        token: token,
        refreshToken: refreshToken,
      );
      if (!isNewRegistration) {
        container.read(volunteerAuthProvider.notifier).signIn();
      }
    }
    if (!ref.mounted) return;

    switch (outcome) {
      case ValidateSmsCodeRequiresBundIdReverification():
        state = state.copyWith(
          isLoading: false,
          requiresBundIdReverification: true,
        );
        return;
      case ValidateSmsCodeInvalidCode() ||
          ValidateSmsCodeLocked() ||
          ValidateSmsCodeRateLimited() ||
          ValidateSmsCodeFailure():
        final message = codeErrorMessage(smsErrorPrefix, outcome)!;
        state = state.copyWith(
          isLoading: false,
          errorMessageKey: '$smsErrorPrefix.form',
          smsCodeErrorMessageKey: message.key,
          smsCodeErrorArgs: message.args,
        );
        return;
      case ValidateSmsCodeExpired():
        state = state.copyWith(
          isLoading: false,
          errorMessageKey:
              'application.volunteer_database.login_page.errors.form',
          smsCodeErrorMessageKey:
              'application.volunteer_database.login_page.errors.code_expired',
        );
        return;
      case ValidateSmsCodeNoCodeRequested():
        state = state.copyWith(
          isLoading: false,
          errorMessageKey:
              'application.volunteer_database.login_page.errors.form',
          smsCodeErrorMessageKey:
              'application.volunteer_database.login_page.errors.no_code_requested',
        );
        return;
      case ValidateSmsCodeSuccess(:final isNewRegistration):
        if (!isNewRegistration) {
          state = state.copyWith(
            isLoading: false,
            loginResult: VolunteerLoginResult.success,
          );
          return;
        }

        state = state.copyWith(
          currentStep: VolunteerLoginStep.identity,
          isLoading: false,
        );
    }
  }

  Future<void> _submitProfile() async {
    state = state.copyWith(isLoading: true, errorMessageKey: null);

    final client = ref.read(graphqlClientProvider);
    final response = await client.mutate_UpdateMyProfile(
      Options_Mutation_UpdateMyProfile(
        variables: Variables_Mutation_UpdateMyProfile(
          input: Input_UpdateMyProfileInput(
            vorname: state.firstName.trim(),
            nachname: state.lastName.trim(),
            email: _blankToNull(state.email),
            street: _blankToNull(state.street),
            postalCode: _blankToNull(state.postalCode),
            city: _blankToNull(state.city),
            country: _blankToNull(state.country),
          ),
        ),
      ),
    );

    if (response.hasException) {
      state = state.copyWith(
        isLoading: false,
        errorMessageKey:
            'application.volunteer_database.login_page.errors.form',
      );
      return;
    }

    ref.invalidate(myAccountProfileProvider);
    ref.read(volunteerAuthProvider.notifier).signIn();
    state = state.copyWith(
      isLoading: false,
      loginResult: VolunteerLoginResult.success,
    );
  }

  String? _blankToNull(String value) =>
      value.trim().isEmpty ? null : value.trim();

  void _showIncompleteStepError() {
    switch (state.currentStep) {
      case VolunteerLoginStep.phone:
        state = state.copyWith(
          errorMessageKey:
              'application.volunteer_database.login_page.errors.form',
          phoneErrorMessageKey:
              'application.volunteer_database.login_page.errors.invalid_phone',
        );
        return;
      case VolunteerLoginStep.sms:
        state = state.copyWith(
          errorMessageKey:
              'application.volunteer_database.login_page.errors.form',
          smsCodeErrorMessageKey:
              'application.volunteer_database.login_page.errors.invalid_code',
        );
        return;
      case VolunteerLoginStep.identity:
        state = state.copyWith(
          errorMessageKey:
              'application.volunteer_database.login_page.errors.form',
          firstNameErrorMessageKey: state.firstName.trim().isEmpty
              ? 'application.volunteer_database.register_page.errors.invalid_first_name'
              : null,
          lastNameErrorMessageKey: state.lastName.trim().isEmpty
              ? 'application.volunteer_database.register_page.errors.invalid_last_name'
              : null,
          ageConfirmationErrorMessageKey: state.isAgeConfirmed
              ? null
              : 'application.volunteer_database.register_page.errors.missing_age_confirmation',
        );
        return;
      case VolunteerLoginStep.completed:
        state = state.copyWith(errorMessageKey: null);
        return;
    }
  }
}

/// Provider for the volunteer login flow.
final volunteerLoginProvider =
    NotifierProvider.autoDispose<VolunteerLoginNotifier, VolunteerLoginState>(
      VolunteerLoginNotifier.new,
    );

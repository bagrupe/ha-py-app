import 'package:app/common/auth/phone_auth.dart';
import 'package:app/common/auth/sms_error_message.dart';
import 'package:app/common/auth/strong_session.dart';
import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/graphql/__generated__/bundid.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/profil/my_account/my_account_provider.dart';
import 'package:app/routes/volunteer_database/providers/registration/volunteer_registration_result.dart';
import 'package:app/routes/volunteer_database/providers/registration/volunteer_registration_state.dart';
import 'package:app/routes/volunteer_database/providers/registration/volunteer_registration_step.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_sms_request_mixin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VolunteerRegistrationNotifier extends Notifier<VolunteerRegistrationState>
    with VolunteerSmsRequestMixin<VolunteerRegistrationState> {
  @override
  VolunteerRegistrationState build() {
    initializeSmsRequests();
    return const VolunteerRegistrationState();
  }

  /// Updates the entered phone number.
  void updatePhoneNumber(String value) {
    state = state.copyWith(
      phoneNumber: value,
      errorMessageKey: null,
      phoneErrorMessageKey: null,
      registrationResult: null,
    );
  }

  /// Updates the entered SMS verification code.
  void updateSmsCode(String value) {
    state = state.copyWith(
      smsCode: value,
      errorMessageKey: null,
      smsCodeErrorMessageKey: null,
      registrationResult: null,
    );
  }

  /// Updates the entered first name.
  void updateFirstName(String value) {
    state = state.copyWith(
      firstName: value,
      errorMessageKey: null,
      firstNameErrorMessageKey: null,
      registrationResult: null,
    );
  }

  /// Updates the entered last name.
  void updateLastName(String value) {
    state = state.copyWith(
      lastName: value,
      errorMessageKey: null,
      lastNameErrorMessageKey: null,
      registrationResult: null,
    );
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value, registrationResult: null);
  }

  void updateStreet(String value) {
    state = state.copyWith(street: value, registrationResult: null);
  }

  void updatePostalCode(String value) {
    state = state.copyWith(postalCode: value, registrationResult: null);
  }

  void updateCity(String value) {
    state = state.copyWith(city: value, registrationResult: null);
  }

  void updateCountry(String value) {
    state = state.copyWith(country: value, registrationResult: null);
  }

  /// Updates the minimum age confirmation.
  void updateAgeConfirmation({required bool value}) {
    state = state.copyWith(
      isAgeConfirmed: value,
      errorMessageKey: null,
      ageConfirmationErrorMessageKey: value
          ? null
          : state.ageConfirmationErrorMessageKey,
      registrationResult: null,
    );
  }

  /// Submits the current registration step.
  Future<void> continueRegistration() async {
    if (!state.canContinue || state.isLoading) {
      _showIncompleteStepError();
      return;
    }

    switch (state.currentStep) {
      case VolunteerRegistrationStep.phone:
        await sendSmsCode();
        return;
      case VolunteerRegistrationStep.sms:
        await _verifySmsCode();
        return;
      case VolunteerRegistrationStep.identity:
        await _submitProfile();
        return;
      case VolunteerRegistrationStep.completed:
        return;
    }
  }

  /// Returns the flow to the phone number step.
  void reviewPhoneNumber() {
    state = state.copyWith(
      currentStep: VolunteerRegistrationStep.phone,
      errorMessageKey: null,
      smsCodeErrorMessageKey: null,
      registrationResult: null,
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
      'application.volunteer_database.register_page.errors';

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
      currentStep: showCodeEntry ? VolunteerRegistrationStep.sms : null,
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
              'application.volunteer_database.register_page.errors.form',
          smsCodeErrorMessageKey:
              'application.volunteer_database.register_page.errors.code_expired',
        );
        return;
      case ValidateSmsCodeNoCodeRequested():
        state = state.copyWith(
          isLoading: false,
          errorMessageKey:
              'application.volunteer_database.register_page.errors.form',
          smsCodeErrorMessageKey:
              'application.volunteer_database.register_page.errors.no_code_requested',
        );
        return;
      case ValidateSmsCodeSuccess(:final isNewRegistration):
        if (!isNewRegistration) {
          state = state.copyWith(
            isLoading: false,
            registrationResult: VolunteerRegistrationResult.success,
          );
          return;
        }

        state = state.copyWith(
          currentStep: VolunteerRegistrationStep.identity,
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
            'application.volunteer_database.register_page.errors.form',
      );
      return;
    }

    ref.invalidate(myAccountProfileProvider);
    ref.read(volunteerAuthProvider.notifier).signIn();
    state = state.copyWith(
      isLoading: false,
      registrationResult: VolunteerRegistrationResult.success,
    );
  }

  String? _blankToNull(String value) =>
      value.trim().isEmpty ? null : value.trim();

  void _showIncompleteStepError() {
    switch (state.currentStep) {
      case VolunteerRegistrationStep.phone:
        state = state.copyWith(
          errorMessageKey:
              'application.volunteer_database.register_page.errors.form',
          phoneErrorMessageKey:
              'application.volunteer_database.register_page.errors.invalid_phone',
        );
        return;
      case VolunteerRegistrationStep.sms:
        state = state.copyWith(
          errorMessageKey:
              'application.volunteer_database.register_page.errors.form',
          smsCodeErrorMessageKey:
              'application.volunteer_database.register_page.errors.invalid_code',
        );
        return;
      case VolunteerRegistrationStep.identity:
        state = state.copyWith(
          errorMessageKey:
              'application.volunteer_database.register_page.errors.form',
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
      case VolunteerRegistrationStep.completed:
        state = state.copyWith(errorMessageKey: null);
        return;
    }
  }
}

/// Provider for the volunteer registration flow.
final volunteerRegistrationProvider =
    NotifierProvider.autoDispose<
      VolunteerRegistrationNotifier,
      VolunteerRegistrationState
    >(VolunteerRegistrationNotifier.new);

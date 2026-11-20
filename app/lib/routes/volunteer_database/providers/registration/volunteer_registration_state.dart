import 'package:app/routes/volunteer_database/providers/registration/volunteer_registration_result.dart';
import 'package:app/routes/volunteer_database/providers/registration/volunteer_registration_step.dart';

/// Immutable state for the volunteer registration flow.
class VolunteerRegistrationState {
  /// Creates immutable state for the volunteer registration flow.
  const VolunteerRegistrationState({
    this.currentStep = VolunteerRegistrationStep.phone,
    this.phoneNumber = '',
    this.smsCode = '',
    this.smsCodePhoneNumber = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.street = '',
    this.postalCode = '',
    this.city = '',
    this.country = '',
    this.isAgeConfirmed = false,
    this.isLoading = false,
    this.errorMessageKey,
    this.errorMessageArgs,
    this.phoneErrorMessageKey,
    this.smsCodeErrorMessageKey,
    this.smsCodeErrorArgs,
    this.firstNameErrorMessageKey,
    this.lastNameErrorMessageKey,
    this.ageConfirmationErrorMessageKey,
    this.resendSecondsRemaining = 59,
    this.registrationResult,
    this.requiresBundIdReverification = false,
  });

  /// The currently visible registration step.
  final VolunteerRegistrationStep currentStep;

  /// The entered phone number.
  final String phoneNumber;

  /// The entered SMS code.
  final String smsCode;

  /// The normalized phone number for the currently sent SMS code.
  final String smsCodePhoneNumber;

  /// The entered first name.
  final String firstName;

  /// The entered last name.
  final String lastName;

  /// The entered email address (optional).
  final String email;

  /// The entered street and house number (optional).
  final String street;

  /// The entered postal code (optional).
  final String postalCode;

  /// The entered city (optional).
  final String city;

  /// The entered country (optional).
  final String country;

  /// Whether the user confirmed the minimum age.
  final bool isAgeConfirmed;

  /// Whether the registration flow is currently processing a request.
  final bool isLoading;

  /// Optional translation key for a user-facing error.
  final String? errorMessageKey;

  final Map<String, String>? errorMessageArgs;

  /// Optional translation key for a phone input error.
  final String? phoneErrorMessageKey;

  /// Optional translation key for an SMS code input error.
  final String? smsCodeErrorMessageKey;

  final Map<String, String>? smsCodeErrorArgs;

  /// Optional translation key for a first name input error.
  final String? firstNameErrorMessageKey;

  /// Optional translation key for a last name input error.
  final String? lastNameErrorMessageKey;

  /// Optional translation key for the minimum age confirmation error.
  final String? ageConfirmationErrorMessageKey;

  /// Remaining seconds until the SMS resend button is enabled.
  final int resendSecondsRemaining;

  /// Optional registration result after successful identity submission.
  final VolunteerRegistrationResult? registrationResult;

  /// Whether the last SMS-verification attempt hit an existing, BundID-verknüpftes account with
  /// the same phone number — access requires a fresh BundID login instead (hard security gate,
  /// see `EhrenamtsbankAuthService.ValidateSmsCode`), not just re-entering the SMS code.
  final bool requiresBundIdReverification;

  /// Whether the phone step has been completed.
  bool get isPhoneCompleted =>
      currentStep.index > VolunteerRegistrationStep.phone.index;

  /// Whether the SMS step has been completed.
  bool get isSmsCompleted =>
      currentStep.index > VolunteerRegistrationStep.sms.index;

  /// Whether the current step can be submitted.
  bool get canContinue {
    return switch (currentStep) {
      VolunteerRegistrationStep.phone => phoneNumber.trim().isNotEmpty,
      VolunteerRegistrationStep.sms => smsCode.length == 6,
      VolunteerRegistrationStep.identity =>
        firstName.trim().isNotEmpty &&
            lastName.trim().isNotEmpty &&
            isAgeConfirmed,
      VolunteerRegistrationStep.completed => false,
    };
  }

  /// Returns a new state with selected values changed.
  VolunteerRegistrationState copyWith({
    VolunteerRegistrationStep? currentStep,
    String? phoneNumber,
    String? smsCode,
    String? smsCodePhoneNumber,
    String? firstName,
    String? lastName,
    String? email,
    String? street,
    String? postalCode,
    String? city,
    String? country,
    bool? isAgeConfirmed,
    bool? isLoading,
    Object? errorMessageKey = _unchanged,
    Object? errorMessageArgs = _unchanged,
    Object? phoneErrorMessageKey = _unchanged,
    Object? smsCodeErrorMessageKey = _unchanged,
    Object? smsCodeErrorArgs = _unchanged,
    Object? firstNameErrorMessageKey = _unchanged,
    Object? lastNameErrorMessageKey = _unchanged,
    Object? ageConfirmationErrorMessageKey = _unchanged,
    int? resendSecondsRemaining,
    Object? registrationResult = _unchanged,
    bool? requiresBundIdReverification,
  }) {
    return VolunteerRegistrationState(
      currentStep: currentStep ?? this.currentStep,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      smsCode: smsCode ?? this.smsCode,
      smsCodePhoneNumber: smsCodePhoneNumber ?? this.smsCodePhoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      street: street ?? this.street,
      postalCode: postalCode ?? this.postalCode,
      city: city ?? this.city,
      country: country ?? this.country,
      isAgeConfirmed: isAgeConfirmed ?? this.isAgeConfirmed,
      isLoading: isLoading ?? this.isLoading,
      errorMessageKey: errorMessageKey == _unchanged
          ? this.errorMessageKey
          : errorMessageKey as String?,
      errorMessageArgs: errorMessageArgs == _unchanged
          ? (errorMessageKey == _unchanged ? this.errorMessageArgs : null)
          : errorMessageArgs as Map<String, String>?,
      phoneErrorMessageKey: phoneErrorMessageKey == _unchanged
          ? this.phoneErrorMessageKey
          : phoneErrorMessageKey as String?,
      smsCodeErrorMessageKey: smsCodeErrorMessageKey == _unchanged
          ? this.smsCodeErrorMessageKey
          : smsCodeErrorMessageKey as String?,
      smsCodeErrorArgs: smsCodeErrorArgs == _unchanged
          ? (smsCodeErrorMessageKey == _unchanged
                ? this.smsCodeErrorArgs
                : null)
          : smsCodeErrorArgs as Map<String, String>?,
      firstNameErrorMessageKey: firstNameErrorMessageKey == _unchanged
          ? this.firstNameErrorMessageKey
          : firstNameErrorMessageKey as String?,
      lastNameErrorMessageKey: lastNameErrorMessageKey == _unchanged
          ? this.lastNameErrorMessageKey
          : lastNameErrorMessageKey as String?,
      ageConfirmationErrorMessageKey:
          ageConfirmationErrorMessageKey == _unchanged
          ? this.ageConfirmationErrorMessageKey
          : ageConfirmationErrorMessageKey as String?,
      resendSecondsRemaining:
          resendSecondsRemaining ?? this.resendSecondsRemaining,
      registrationResult: registrationResult == _unchanged
          ? this.registrationResult
          : registrationResult as VolunteerRegistrationResult?,
      requiresBundIdReverification:
          requiresBundIdReverification ?? this.requiresBundIdReverification,
    );
  }
}

/// Sentinel for unchanged nullable values.
const Object _unchanged = Object();

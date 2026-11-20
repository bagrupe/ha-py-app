import 'package:app/routes/volunteer_database/providers/bundid_onboarding/bundid_onboarding_step.dart';

/// Immutable state for the BundID onboarding flow.
class BundIdOnboardingState {
  /// Creates immutable state for the BundID onboarding flow.
  const BundIdOnboardingState({
    this.currentStep = BundIdOnboardingStep.phone,
    this.vorname = '',
    this.nachname = '',
    this.email = '',
    this.street = '',
    this.postalCode = '',
    this.city = '',
    this.country = '',
    this.phoneNumber = '',
    this.smsCode = '',
    this.smsCodePhoneNumber = '',
    this.isLoading = false,
    this.errorMessageKey,
    this.errorMessageArgs,
    this.phoneErrorMessageKey,
    this.smsCodeErrorMessageKey,
    this.smsCodeErrorArgs,
    this.resendSecondsRemaining = 59,
    this.isCompleted = false,
    this.isInitialized = false,
    this.requiresBundIdReverification = false,
    this.phoneNumberCollision = false,
  });

  /// The currently visible onboarding step.
  final BundIdOnboardingStep currentStep;

  /// The entered/edited first name, initially seeded from BundID.
  final String vorname;

  /// The entered/edited last name, initially seeded from BundID.
  final String nachname;

  /// The entered/edited email address, initially seeded from BundID.
  final String email;

  /// The entered/edited street, initially seeded from BundID.
  final String street;

  /// The entered/edited postal code, initially seeded from BundID.
  final String postalCode;

  /// The entered/edited city, initially seeded from BundID.
  final String city;

  /// The entered/edited country, initially seeded from BundID.
  final String country;

  /// The entered phone number, initially seeded from BundID if available.
  final String phoneNumber;

  /// The entered SMS verification code.
  final String smsCode;

  /// The normalized phone number for the currently sent SMS code.
  final String smsCodePhoneNumber;

  /// Whether a network request is currently in flight.
  final bool isLoading;

  /// Optional translation key for a general form error.
  final String? errorMessageKey;

  final Map<String, String>? errorMessageArgs;

  /// Optional translation key for a phone input error.
  final String? phoneErrorMessageKey;

  /// Optional translation key for an SMS code input error.
  final String? smsCodeErrorMessageKey;

  final Map<String, String>? smsCodeErrorArgs;

  /// Remaining seconds until the SMS resend button is enabled.
  final int resendSecondsRemaining;

  /// Whether the profile was saved and phone verification completed successfully.
  final bool isCompleted;

  /// Whether the BundID profile suggestion has been applied (or attempted) once. Flips exactly
  /// once per page visit, used as a widget key salt so the (uncontrolled) text fields pick up the
  /// asynchronously-loaded initial values instead of staying stuck on their first empty build.
  final bool isInitialized;

  /// Whether the last SMS-verification attempt hit an existing, BundID-verknüpftes account with
  /// the same phone number — access requires a fresh BundID login instead (hard security gate,
  /// see `EhrenamtsbankAuthService.ValidateSmsCode`), not just re-entering the SMS code.
  final bool requiresBundIdReverification;

  /// Whether the phone number BundID suggested at exchange time already belonged to a different,
  /// non-BundID account — the backend deliberately did NOT take it over (see
  /// `BundIdAuthService.SyncProfileFromBundId`), so [phoneNumber] is empty here even though BundID
  /// did supply a number. Verifying it via the normal SMS step below still works and merges onto
  /// that existing account (`EhrenamtsbankAuthService.ValidateSmsCode`) — this flag exists purely
  /// to explain that to the user instead of leaving an unexplained empty field.
  final bool phoneNumberCollision;

  /// Returns a new state with selected values changed.
  BundIdOnboardingState copyWith({
    BundIdOnboardingStep? currentStep,
    String? vorname,
    String? nachname,
    String? email,
    String? street,
    String? postalCode,
    String? city,
    String? country,
    String? phoneNumber,
    String? smsCode,
    String? smsCodePhoneNumber,
    bool? isLoading,
    Object? errorMessageKey = _unchanged,
    Object? errorMessageArgs = _unchanged,
    Object? phoneErrorMessageKey = _unchanged,
    Object? smsCodeErrorMessageKey = _unchanged,
    Object? smsCodeErrorArgs = _unchanged,
    int? resendSecondsRemaining,
    bool? isCompleted,
    bool? isInitialized,
    bool? requiresBundIdReverification,
    bool? phoneNumberCollision,
  }) {
    return BundIdOnboardingState(
      currentStep: currentStep ?? this.currentStep,
      vorname: vorname ?? this.vorname,
      nachname: nachname ?? this.nachname,
      email: email ?? this.email,
      street: street ?? this.street,
      postalCode: postalCode ?? this.postalCode,
      city: city ?? this.city,
      country: country ?? this.country,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      smsCode: smsCode ?? this.smsCode,
      smsCodePhoneNumber: smsCodePhoneNumber ?? this.smsCodePhoneNumber,
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
      resendSecondsRemaining:
          resendSecondsRemaining ?? this.resendSecondsRemaining,
      isCompleted: isCompleted ?? this.isCompleted,
      isInitialized: isInitialized ?? this.isInitialized,
      requiresBundIdReverification:
          requiresBundIdReverification ?? this.requiresBundIdReverification,
      phoneNumberCollision: phoneNumberCollision ?? this.phoneNumberCollision,
    );
  }
}

/// Sentinel for unchanged nullable values.
const Object _unchanged = Object();

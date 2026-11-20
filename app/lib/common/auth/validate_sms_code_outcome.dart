part of 'phone_auth.dart';

/// Every SMS code confirmation goes through [validateSmsCode], never the raw mutation.
sealed class ValidateSmsCodeOutcome {}

/// Steps in the volunteer login flow.
enum VolunteerLoginStep {
  /// Phone number entry step.
  phone,

  /// SMS verification step.
  sms,

  /// Identity data step — only reached when the verified phone number turned out to belong to a
  /// genuinely new account (see `VolunteerLoginNotifier._verifySmsCode`).
  identity,

  /// Completed login flow.
  completed,
}

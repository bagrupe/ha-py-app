/// Current step of the volunteer registration flow.
enum VolunteerRegistrationStep {
  /// Phone number input step.
  phone,

  /// SMS verification step.
  sms,

  /// Identity data step.
  identity,

  /// Completed registration step.
  completed,
}

/// Feature flags configuration for the application.
class VolunteerDataBase {
  /// Feature flag for the volunteer database (Ehrenamtsbank).
  static const bool isEnabled = bool.fromEnvironment('EHRENAMTSBANK_ENABLED');
}

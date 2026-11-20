import 'package:app/common/volunteer_database/time_credit_model.dart';

/// Immutable domain model for a volunteer profile.
///
/// Distinct from authentication state: identity and time credits live here;
/// session/login concerns stay in the auth layer.
class VolunteerProfileModel {
  /// Creates a volunteer profile.
  const VolunteerProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.timeCredit,
  });

  /// Stable volunteer identifier.
  final String id;

  /// Given name.
  final String firstName;

  /// Family name.
  final String lastName;

  /// Contact phone number used for volunteer flows.
  final String phoneNumber;

  /// Current time-credit snapshot for this volunteer.
  final TimeCreditModel timeCredit;
}

import 'package:app/graphql/__generated__/schema.graphql.dart';

/// Backend response for a submitted volunteer interest request.
class VolunteerInterestModel {
  /// Creates a submitted volunteer interest response.
  const VolunteerInterestModel({
    required this.id,
    required this.status,
    required this.createdAt,
    this.message,
  });

  /// Stable identifier of the created interest request.
  final String id;

  /// Status assigned by the backend.
  final Enum_EhrenamtsbankAnfrageStatus status;

  /// Optional message sent to the person seeking help.
  final String? message;

  /// Backend creation timestamp.
  final DateTime createdAt;

  /// Whether the backend considers this interest newly requested.
  bool get isRequested => status == Enum_EhrenamtsbankAnfrageStatus.OFFEN;
}

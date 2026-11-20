import 'package:app/graphql/__generated__/schema.graphql.dart';

/// Immutable data required to create and submit a volunteer help request.
class VolunteerRequestSubmission {
  /// Creates a volunteer help request submission.
  const VolunteerRequestSubmission({
    required this.title,
    required this.description,
    required this.categoryId,
    required this.municipalityId,
    required this.urgency,
    required this.estimatedDurationMinutes,
    this.radiusKm,
    this.tags = const [],
    this.photoPath,
  });

  /// Request title shown in the marketplace.
  final String title;

  /// Detailed description of the requested help.
  final String description;

  /// Backend identifier of the selected category.
  final String categoryId;

  /// Backend identifier of the selected municipality.
  final String municipalityId;

  /// Urgency selected for the request.
  final Enum_EhrenamtsbankDringlichkeit urgency;

  /// Estimated effort in minutes.
  final int estimatedDurationMinutes;

  /// Optional willingness radius in kilometres.
  final int? radiusKm;

  /// Optional searchable tags.
  final List<String> tags;

  /// Local path of the photo to upload before creating the request.
  final String? photoPath;
}

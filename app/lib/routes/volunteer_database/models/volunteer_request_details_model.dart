import 'package:app/routes/volunteer_database/models/volunteer_request_model.dart';

/// Complete display data for a volunteer marketplace entry.
class VolunteerRequestDetailsModel {
  /// Creates complete display data for an entry.
  const VolunteerRequestDetailsModel({
    required this.volunteerRequestModel,
    required this.metaData,
    required this.createdAt,
  });

  /// Free-form tags attached to the entry.
  final List<String> metaData;

  /// Localized creation date.
  final String createdAt;

  /// Shared entry data used by list and detail views.
  final VolunteerRequestModel volunteerRequestModel;
}

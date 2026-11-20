import 'package:app/routes/volunteer_database/providers/help_type_provider.dart';

/// Display data for a volunteer marketplace entry.
class VolunteerRequestModel {
  /// Creates display data for a volunteer marketplace entry.
  const VolunteerRequestModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.time,
    required this.commune,
    required this.userAvatar,
    required this.userName,
    required this.isVerified,
    required this.description,
    required this.categoryKey,
    required this.helpType,
    required this.image,
    required this.status,
  });

  /// Stable entry identifier.
  final String id;

  /// Stable identifier of the user who owns the entry.
  final String ownerId;

  /// Entry title.
  final String title;

  /// Formatted estimated duration or availability.
  final String time;

  /// Municipality in which help is offered or requested.
  final String commune;

  /// Optional entry image.
  final ViewImage? image;

  /// Initials displayed when no profile image is available.
  final String userAvatar;

  /// Display name of the entry owner.
  final String userName;

  /// Whether the owner's profile is verified.
  final bool isVerified;

  /// Full entry description.
  final String description;

  /// Backend category identifier.
  final String categoryKey;

  /// Marketplace perspective under which the entry is displayed.
  final HelpType helpType;

  /// Current lifecycle status of the entry.
  final VolunteerRequestStatus status;
}

/// Lifecycle status of a volunteer marketplace entry.
enum VolunteerRequestStatus {
  /// Entry is still a draft.
  draft,

  /// Entry is waiting for moderation.
  pendingReview,

  /// Entry is publicly visible.
  active,

  /// Entry has a binding agreement and is no longer publicly available.
  assigned,

  /// Entry is temporarily paused.
  paused,

  /// Entry has been completed.
  completed,

  /// Entry has been closed.
  closed,

  /// Entry status is not recognized by this app version.
  unknown,
}

/// Remote image displayed for a volunteer entry.
class ViewImage {
  /// Creates a remote volunteer entry image.
  const ViewImage({required this.url, required this.altText});

  /// Public image URL.
  final String url;

  /// Accessible image description.
  final String altText;
}

import 'package:app/routes/volunteer_database/models/volunteer_request_model.dart';
import 'package:app/routes/volunteer_database/widgets/parts/volunteer_badge.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays the localized lifecycle status of a volunteer request.
class MyRequestStatusBadge extends StatelessWidget {
  /// Creates a status badge for [status].
  const MyRequestStatusBadge({
    required this.status,
    this.hasCompletionProposal = false,
    super.key,
  });

  /// Lifecycle status displayed by the badge.
  final VolunteerRequestStatus status;

  /// Whether the assigned request is awaiting completion confirmation.
  final bool hasCompletionProposal;

  @override
  Widget build(BuildContext context) {
    final isPositiveStatus = {
      VolunteerRequestStatus.active,
      VolunteerRequestStatus.assigned,
      VolunteerRequestStatus.completed,
    }.contains(status);
    final label = switch (status) {
      VolunteerRequestStatus.draft => 'draft',
      VolunteerRequestStatus.pendingReview => 'pending_review',
      VolunteerRequestStatus.active => 'active',
      VolunteerRequestStatus.assigned =>
        hasCompletionProposal ? 'in_progress' : 'assigned',
      VolunteerRequestStatus.paused => 'paused',
      VolunteerRequestStatus.completed => 'completed',
      VolunteerRequestStatus.closed => 'closed',
      VolunteerRequestStatus.unknown => 'unknown',
    };
    final theme = Theme.of(context);

    return VolunteerBadge(
      icon: isPositiveStatus ? Icons.check : Icons.info_outline,
      backgroundColor: theme.colorScheme.primaryContainer,
      foregroundColor: theme.colorScheme.onPrimaryContainer,
      fontWeight: FontWeight.w700,
      text: 'application.volunteer_database.my_requests.status.$label'.tr(),
    );
  }
}

import 'package:app/routes/volunteer_database/models/volunteer_request_model.dart';
import 'package:app/routes/volunteer_database/widgets/my_volunteer_request_inbox.dart';
import 'package:app/routes/volunteer_database/widgets/my_volunteer_request_lifecycle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Owner-specific status and description heading on an entry detail page.
class VolunteerRequestOwnerDetails extends StatelessWidget {
  /// Creates the owner section for an entry and its creation date.
  const VolunteerRequestOwnerDetails({
    required this.request,
    required this.createdAt,
    super.key,
  });

  /// Owned entry whose lifecycle determines the displayed status.
  final VolunteerRequestModel request;

  /// Localized creation date widget.
  final Widget createdAt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        createdAt,
        if (request.status == VolunteerRequestStatus.active)
          MyVolunteerRequestInbox(requestId: request.id)
        else
          MyVolunteerRequestLifecycle(request: request),
        Semantics(
          header: true,
          child: Text(
            'application.volunteer_database.details.own_description'.tr(),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

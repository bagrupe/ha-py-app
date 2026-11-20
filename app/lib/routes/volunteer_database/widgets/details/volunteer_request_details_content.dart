import 'package:app/common/connectivity/offline_data_unavailable_exception.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_details_model.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_model.dart';
import 'package:app/routes/volunteer_database/providers/my_volunteer_requests_provider.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_ownership_page_provider.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_request_ownership_provider.dart';
import 'package:app/routes/volunteer_database/widgets/details/volunteer_request_details_image.dart';
import 'package:app/routes/volunteer_database/widgets/details/volunteer_request_details_metadata.dart';
import 'package:app/routes/volunteer_database/widgets/details/volunteer_request_owner_details.dart';
import 'package:app/routes/volunteer_database/widgets/my_request_status_badge.dart';
import 'package:app/routes/volunteer_database/widgets/parts/volunteer_badge.dart';
import 'package:app/routes/volunteer_database/widgets/parts/volunteer_request_creator.dart';
import 'package:app/routes/volunteer_database/widgets/volunteer_interest_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays entry details with actions appropriate to the current owner.
class VolunteerRequestDetailsContent extends ConsumerWidget {
  /// Creates the content for an entry.
  const VolunteerRequestDetailsContent({required this.details, super.key});

  /// Entry and its supplementary display data.
  final VolunteerRequestDetailsModel details;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final request = details.volunteerRequestModel;
    final ownership = ref.watch(volunteerRequestOwnershipProvider(request.id));
    if (ownership.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (ownership.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Semantics(
            liveRegion: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  (ownership.error is OfflineDataUnavailableException
                          ? 'application.error.offline_no_cache'
                          : 'application.volunteer_database.details.error')
                      .tr(),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () {
                    ref
                      ..invalidate(myVolunteerRequestsProvider)
                      ..invalidate(volunteerOwnershipPageProvider)
                      ..invalidate(
                        volunteerRequestOwnershipProvider(request.id),
                      );
                  },
                  child: Text('application.error.retry'.tr()),
                ),
              ],
            ),
          ),
        ),
      );
    }
    final isOwner = ownership.requireValue;
    final createdAt = Text(
      'application.volunteer_database.details.created_at'.tr(
        namedArgs: {'date': details.createdAt},
      ),
      style: theme.textTheme.titleLarge?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
    return ListView(
      key: PageStorageKey('volunteer-details-${request.id}'),
      children: [
        VolunteerRequestDetailsImage(request: request),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              Semantics(
                header: true,
                child: Text(
                  request.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (request.time.isNotEmpty)
                    VolunteerBadge(
                      icon: Icons.arrow_outward,
                      text: request.time,
                    ),
                  if (request.commune.isNotEmpty)
                    VolunteerBadge(text: request.commune),
                  if (isOwner &&
                      request.status != VolunteerRequestStatus.active)
                    MyRequestStatusBadge(status: request.status),
                ],
              ),
              if (isOwner)
                VolunteerRequestOwnerDetails(
                  request: request,
                  createdAt: createdAt,
                )
              else
                VolunteerRequestCreator(
                  userAvatar: request.userAvatar,
                  userName: request.userName,
                  isVerified: request.isVerified,
                  subtitle: createdAt,
                ),
              Text(request.description, style: theme.textTheme.bodySmall),
              VolunteerRequestDetailsMetadata(metaData: details.metaData),
              if (!isOwner)
                VolunteerInterestButton(
                  entryId: request.id,
                  ownerId: request.ownerId,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

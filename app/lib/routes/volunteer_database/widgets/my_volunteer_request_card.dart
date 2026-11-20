import 'package:app/common/design_tokens.dart';
import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/components/images/loading_image.dart';
import 'package:app/routes/profil/interests/volunteer_interest_filter.dart';
import 'package:app/routes/profil/interests/volunteer_interest_filter_provider.dart';
import 'package:app/routes/profil/interests/volunteer_interests_page.dart';
import 'package:app/routes/profil/interests/volunteer_interests_provider.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_model.dart';
import 'package:app/routes/volunteer_database/views/volunteer_request_details_page.dart';
import 'package:app/routes/volunteer_database/widgets/my_request_status_badge.dart';
import 'package:app/routes/volunteer_database/widgets/parts/volunteer_badge.dart';
import 'package:app/routes/volunteer_database/widgets/parts/volunteer_request_creator.dart';
import 'package:app/routes/volunteer_database/widgets/volunteer_request_interest_badge.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

part 'parts/my_volunteer_request_image.dart';
part 'parts/my_volunteer_request_inbox.dart';
part 'parts/my_volunteer_request_lifecycle.dart';

/// Dedicated overview card combining an owned entry and its inbox shortcut.
class MyVolunteerRequestCard extends StatelessWidget {
  /// Creates an overview card for [request].
  const MyVolunteerRequestCard({required this.request, super.key});

  /// Entry displayed by the card.
  final VolunteerRequestModel request;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            label: 'application.volunteer_database.my_requests.card_semantics'
                .tr(namedArgs: {'title': request.title}),
            child: InkWell(
              onTap: () => context.push(
                VolunteerRequestDetailsPage.path.replaceFirst(
                  ':id',
                  request.id,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _MyVolunteerRequestImage(request: request),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(
                          request.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        VolunteerRequestCreator(
                          userAvatar: request.userAvatar,
                          userName: request.userName,
                          isVerified: request.isVerified,
                          subtitle: Text(
                            request.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: DesignTokens.gray900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (request.status == VolunteerRequestStatus.active)
            _MyVolunteerRequestInbox(requestId: request.id)
          else
            _MyVolunteerRequestLifecycle(request: request),
        ],
      ),
    );
  }
}

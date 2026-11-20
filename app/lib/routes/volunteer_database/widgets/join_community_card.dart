import 'package:app/components/buttons/primary_button.dart';
import 'package:app/routes/volunteer_database/views/register.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Card that invites logged-out users to register for the volunteer database.
class JoinCommunityCard extends StatelessWidget {
  /// Creates a card that links to the volunteer database registration page.
  const JoinCommunityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'application.volunteer_database.join_community_title'.tr(),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'application.volunteer_database.join_community_description'.tr(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: 'application.volunteer_database.register_now'.tr(),
              onPressed: () => context.push(VolunteerDatabaseRegisterPage.path),
              trailingIconData: Icons.arrow_forward,
            ),
          ),
        ],
      ),
    );
  }
}

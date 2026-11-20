import 'package:app/common/design_tokens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Message card for the volunteer database access denied placeholder.
class VolunteerAccessDeniedMessageCard extends StatelessWidget {
  /// Creates the access denied message card.
  const VolunteerAccessDeniedMessageCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: DesignTokens.gray100,
        border: Border.all(color: DesignTokens.orange500),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'application.volunteer_database.access_denied.title'.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              color: DesignTokens.gray900,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'application.volunteer_database.access_denied.description'.tr(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: DesignTokens.gray700,
            ),
          ),
        ],
      ),
    );
  }
}

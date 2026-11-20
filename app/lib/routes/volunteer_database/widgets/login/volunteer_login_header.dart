import 'package:app/common/design_tokens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Header for the volunteer login flow.
class VolunteerLoginHeader extends StatelessWidget {
  /// Creates the volunteer login header.
  const VolunteerLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'application.volunteer_database.login_page.welcome'.tr(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: DesignTokens.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'application.volunteer_database.login_page.introduction'.tr(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: DesignTokens.gray500,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).maybePop(),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text('application.volunteer_database.login_page.close'.tr()),
        ),
      ],
    );
  }
}

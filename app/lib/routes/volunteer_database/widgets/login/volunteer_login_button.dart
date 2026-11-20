import 'package:app/routes/volunteer_database/views/login.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VolunteerDatabaseLoginButton extends StatelessWidget {
  const VolunteerDatabaseLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
      onPressed: () => context.push(VolunteerDatabaseLoginPage.path),
      child: Text(
        'application.volunteer_database.login'.tr(),
        style: theme.textTheme.bodySmall!.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

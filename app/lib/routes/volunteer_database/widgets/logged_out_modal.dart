import 'package:app/routes/volunteer_database/views/login.dart';
import 'package:app/routes/volunteer_database/views/register.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shows the logged-out authentication bottom sheet.
Future<void> showLoggedOutModal(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return const FractionallySizedBox(
        heightFactor: 0.4,
        child: LoggedOutModal(),
      );
    },
  );
}

/// Modal that asks logged-out users to log in or register.
class LoggedOutModal extends StatelessWidget {
  /// Creates a modal for volunteer database authentication actions.
  const LoggedOutModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const basePath = 'application.volunteer_database.auth_modal';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SingleChildScrollView(
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '$basePath.title'.tr(),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                Semantics(
                  label: '$basePath.close_semantics'.tr(),
                  button: true,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),

            Text(
              '$basePath.description'.tr(),
              style: theme.textTheme.bodySmall,
            ),

            Semantics(
              button: true,
              label: '$basePath.login_now'.tr(),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  context.push(VolunteerDatabaseLoginPage.path);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '$basePath.login_now'.tr(),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            FilledButton(
              style: FilledButton.styleFrom(
                textStyle: theme.textTheme.bodyLarge,
              ),
              onPressed: () {
                Navigator.pop(context);
                context.push(VolunteerDatabaseRegisterPage.path);
              },
              child: Text('$basePath.register_free_now'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

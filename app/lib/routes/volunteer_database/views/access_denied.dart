import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/routes/volunteer_database/widgets/access_denied/volunteer_access_denied_message_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Access denied placeholder page for the volunteer database.
class VolunteerDatabaseAccessDeniedPage extends StatelessWidget {
  /// Creates the access denied placeholder page.
  const VolunteerDatabaseAccessDeniedPage({super.key});

  /// Absolute route path for the volunteer database access denied page.
  static const path = '/ehrenamtsdatenbank/access-denied';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: Text('application.volunteer_database.title'.tr()),
        logo: true,
      ),
      body: Semantics(
        label: 'application.volunteer_database.access_denied.semantics.page'
            .tr(),
        explicitChildNodes: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(7, 8, 7, 16),
            child: Column(
              children: [
                const Expanded(child: VolunteerAccessDeniedMessageCard()),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                      return;
                    }

                    context.go('/ehrenamtsdatenbank');
                  },
                  child: Text(
                    'application.volunteer_database.access_denied.close'.tr(),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'application.volunteer_database.access_denied.support_placeholder'
                                .tr(),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'application.volunteer_database.access_denied.contact_support'
                          .tr(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

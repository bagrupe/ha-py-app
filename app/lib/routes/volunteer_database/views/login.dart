import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/routes/volunteer_database/widgets/login/volunteer_login_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Login page for the volunteer database.
class VolunteerDatabaseLoginPage extends StatelessWidget {
  /// Creates the volunteer database login page.
  const VolunteerDatabaseLoginPage({super.key});

  /// Absolute route path for the volunteer database login page.
  static const path = '/ehrenamtsdatenbank/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: Text('application.volunteer_database.title'.tr()),
        logo: true,
      ),
      body: const VolunteerLoginContent(),
    );
  }
}

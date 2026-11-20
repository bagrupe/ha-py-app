import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/routes/volunteer_database/widgets/register/volunteer_registration_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Registration page for the volunteer database.
class VolunteerDatabaseRegisterPage extends StatelessWidget {
  /// Creates the volunteer database registration page.
  const VolunteerDatabaseRegisterPage({super.key});

  /// Absolute route path for the volunteer database registration page.
  static const path = '/ehrenamtsdatenbank/register';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: Text('application.volunteer_database.title'.tr()),
        logo: true,
      ),
      body: const VolunteerRegistrationContent(),
    );
  }
}

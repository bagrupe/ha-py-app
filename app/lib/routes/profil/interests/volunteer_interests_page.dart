import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/routes/profil/interests/volunteer_interests_content.dart';
import 'package:app/routes/profil/interests/volunteer_interests_error.dart';
import 'package:app/routes/profil/interests/volunteer_interests_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Profile overview for sent and received volunteer interest requests.
class VolunteerInterestsPage extends ConsumerWidget {
  /// Creates the volunteer interest overview page.
  const VolunteerInterestsPage({super.key});

  /// Absolute route path for this page.
  static const path = '/profil/volunteer-interests';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interests = ref.watch(volunteerInterestsProvider);
    return Scaffold(
      appBar: CommonAppBar(title: Text('application.profile.title'.tr())),
      body: interests.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => VolunteerInterestsError(error: error),
        data: (items) => VolunteerInterestsContent(items: items),
      ),
    );
  }
}

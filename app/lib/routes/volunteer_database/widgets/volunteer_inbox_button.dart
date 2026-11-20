import 'package:app/routes/profil/interests/volunteer_interest_filter.dart';
import 'package:app/routes/profil/interests/volunteer_interest_filter_provider.dart';
import 'package:app/routes/profil/interests/volunteer_interests_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Standalone outlined action opening the received-interest inbox.
class VolunteerInboxButton extends ConsumerWidget {
  /// Creates the shared inbox action.
  const VolunteerInboxButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      onPressed: () {
        ref
            .read(volunteerInterestFilterProvider.notifier)
            .select(VolunteerInterestFilter.received);
        context.push(VolunteerInterestsPage.path);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          Flexible(
            child: Text(
              'application.volunteer_database.my_requests.inbox.open'.tr(),
            ),
          ),
          const ExcludeSemantics(child: Icon(Icons.forum_outlined, size: 18)),
        ],
      ),
    );
  }
}

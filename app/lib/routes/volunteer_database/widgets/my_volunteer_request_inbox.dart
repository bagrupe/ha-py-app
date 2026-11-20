import 'package:app/routes/profil/interests/volunteer_interests_provider.dart';
import 'package:app/routes/volunteer_database/widgets/volunteer_inbox_button.dart';
import 'package:app/routes/volunteer_database/widgets/volunteer_notice.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays incoming interest information and a separate received-inbox action.
class MyVolunteerRequestInbox extends ConsumerWidget {
  /// Creates the inbox summary for one entry.
  const MyVolunteerRequestInbox({required this.requestId, super.key});

  /// Entry whose incoming requests are summarized.
  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interests = ref.watch(volunteerInterestsProvider);
    final interestCount = interests.value
        ?.where(
          (interest) =>
              interest.entryId == requestId &&
              (interest.isOpen || interest.isAccepted),
        )
        .length;
    final hasInterests = interestCount == null ? null : interestCount > 0;
    final hasData = hasInterests != null;
    final titleSuffix = (hasInterests ?? false) ? 'title' : 'empty_title';
    final descriptionSuffix = (hasInterests ?? false)
        ? 'description'
        : 'empty_description';
    const path = 'application.volunteer_database.my_requests.inbox';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        switch (interests) {
          AsyncLoading() when !hasData => const Center(
            child: CircularProgressIndicator(),
          ),
          AsyncError() when !hasData => TextButton(
            onPressed: () => ref.invalidate(volunteerInterestsProvider),
            child: Text('$path.error'.tr()),
          ),
          _ => VolunteerNotice(
            icon: Icons.mark_email_unread_outlined,
            title: '$path.$titleSuffix'.tr(),
            description: (hasInterests ?? false)
                ? '$path.description'.plural(interestCount!, name: 'count')
                : '$path.$descriptionSuffix'.tr(),
          ),
        },
        if (hasInterests ?? false) const VolunteerInboxButton(),
      ],
    );
  }
}

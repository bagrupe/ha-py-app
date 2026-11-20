import 'package:app/routes/profil/interests/volunteer_interests_provider.dart';
import 'package:app/routes/volunteer_database/widgets/parts/volunteer_badge.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays the number of open incoming requests for one owned entry.
class VolunteerRequestInterestBadge extends ConsumerWidget {
  /// Creates an interest count badge for one entry.
  const VolunteerRequestInterestBadge({required this.requestId, super.key});

  /// Entry whose open incoming requests are counted.
  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref
        .watch(volunteerInterestsProvider)
        .value
        ?.where(
          (interest) =>
              interest.entryId == requestId &&
              (interest.isOpen || interest.isAccepted),
        )
        .length;
    if (count == null || count == 0) return const SizedBox.shrink();
    return VolunteerBadge(
      icon: Icons.forum_outlined,
      text: 'application.volunteer_database.my_requests.inbox.count'.plural(
        count,
      ),
    );
  }
}

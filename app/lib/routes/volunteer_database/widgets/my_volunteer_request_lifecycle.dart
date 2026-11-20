import 'package:app/routes/profil/interests/volunteer_interests_provider.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_model.dart';
import 'package:app/routes/volunteer_database/widgets/volunteer_inbox_button.dart';
import 'package:app/routes/volunteer_database/widgets/volunteer_notice.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Status-specific summary and available actions for an owned entry.
class MyVolunteerRequestLifecycle extends ConsumerWidget {
  /// Creates a lifecycle section for [request].
  const MyVolunteerRequestLifecycle({required this.request, super.key});

  /// Entry whose lifecycle determines the displayed content.
  final VolunteerRequestModel request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const path = 'application.volunteer_database.my_requests.lifecycle';
    final isAssigned = request.status == VolunteerRequestStatus.assigned;
    final isCompleted = request.status == VolunteerRequestStatus.completed;
    if (!isAssigned && !isCompleted) {
      return const SizedBox.shrink();
    }
    final interests = ref.watch(volunteerInterestsProvider);
    final interest = interests.value
        ?.where(
          (item) =>
              item.entryId == request.id &&
              (isCompleted ? item.isCompleted : item.isAgreed),
        )
        .firstOrNull;
    final booking = interest?.completionBooking;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        VolunteerNotice(
          icon: isAssigned ? Icons.event_available_outlined : Icons.task_alt,
          title: booking == null
              ? '$path.${isAssigned ? 'assigned_title' : 'completed_title'}'
                    .tr()
              : '$path.performed_on'.tr(
                  namedArgs: {
                    'date': DateFormat.yMd(
                      context.locale.toString(),
                    ).format(booking.performedOn),
                  },
                ),
          description:
              '$path.${isAssigned
                      ? (interest?.personName.trim().isNotEmpty ?? false)
                            ? 'assigned_description'
                            : 'assigned_fallback_description'
                      : 'completed_description'}'
                  .tr(namedArgs: {'name': interest?.personName ?? ''}),
          supportingText: booking == null
              ? null
              : '$path.duration'.tr(
                  namedArgs: {'minutes': booking.minutes.toString()},
                ),
        ),
        if (interests.hasError)
          TextButton(
            onPressed: () => ref.invalidate(volunteerInterestsProvider),
            child: Text(
              'application.volunteer_database.my_requests.inbox.error'.tr(),
            ),
          ),
        if (isAssigned) const VolunteerInboxButton(),
      ],
    );
  }
}

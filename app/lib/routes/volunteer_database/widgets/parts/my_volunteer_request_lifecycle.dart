part of '../my_volunteer_request_card.dart';

/// Status-specific summary and available actions for an owned entry.
class _MyVolunteerRequestLifecycle extends ConsumerWidget {
  /// Creates a lifecycle section for [request].
  const _MyVolunteerRequestLifecycle({required this.request});

  /// Entry whose lifecycle determines the displayed content.
  final VolunteerRequestModel request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const path = 'application.volunteer_database.my_requests.lifecycle';
    final theme = Theme.of(context);
    final isAssigned = request.status == VolunteerRequestStatus.assigned;
    final isCompleted = request.status == VolunteerRequestStatus.completed;
    final isPendingReview =
        request.status == VolunteerRequestStatus.pendingReview;
    if (!isAssigned && !isCompleted && !isPendingReview) {
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
    final proposal = interest?.completionProposal;
    final isOwnProposal =
        proposal?.wasProposedBy(ref.watch(volunteerAuthProvider)) ?? false;
    final state = _resolveLifecycleState(
      hasProposal: proposal != null,
      isOwnProposal: isOwnProposal,
    );
    final arguments = <String, String>{
      if (interest != null) 'name': interest.personName,
      if (proposal != null) 'minutes': proposal.minutes.toString(),
    };
    return ColoredBox(
      color: theme.colorScheme.primary.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            Semantics(
              header: true,
              child: Row(
                spacing: 4,
                children: [
                  Icon(
                    Icons.event_available_outlined,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  Expanded(
                    child: Text(
                      booking == null
                          ? '$path.${state}_title'.tr()
                          : '$path.performed_on'.tr(
                              namedArgs: {
                                'date': DateFormat.yMd(
                                  context.locale.toString(),
                                ).format(booking.performedOn),
                              },
                            ),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '$path.${state == 'assigned' && interest == null ? 'assigned_fallback' : state}_description'
                  .tr(namedArgs: arguments),
              style: theme.textTheme.titleLarge,
            ),
            if (booking != null)
              Text(
                '$path.duration'.tr(
                  namedArgs: {'minutes': booking.minutes.toString()},
                ),
                style: theme.textTheme.titleLarge,
              ),
            if (interests.hasError)
              TextButton(
                onPressed: () => ref.invalidate(volunteerInterestsProvider),
                child: Text(
                  'application.volunteer_database.my_requests.inbox.error'.tr(),
                ),
              ),
            if (isAssigned && (proposal == null || !isOwnProposal))
              TextButton(
                onPressed: () => context.push(VolunteerInterestsPage.path),
                child: Text(
                  proposal != null
                      ? '$path.review_action'.tr()
                      : 'application.volunteer_database.my_requests.inbox.open'
                            .tr(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Resolves the translation state for the entry and its completion proposal.
  String _resolveLifecycleState({
    required bool hasProposal,
    required bool isOwnProposal,
  }) {
    if (request.status == VolunteerRequestStatus.pendingReview) {
      return 'pending_review';
    }
    if (request.status == VolunteerRequestStatus.completed) {
      return 'completed';
    }
    if (!hasProposal) return 'assigned';
    return isOwnProposal ? 'waiting' : 'review';
  }
}

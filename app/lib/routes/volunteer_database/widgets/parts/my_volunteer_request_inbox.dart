part of '../my_volunteer_request_card.dart';

/// Displays the interest summary and opens the existing received-interest inbox.
class _MyVolunteerRequestInbox extends ConsumerWidget {
  /// Creates an inbox section for one entry.
  const _MyVolunteerRequestInbox({required this.requestId});

  /// Entry whose incoming requests are summarized.
  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final interests = ref.watch(volunteerInterestsProvider);
    final interestCount = interests.value
        ?.where(
          (interest) =>
              interest.entryId == requestId &&
              (interest.isOpen || interest.isAccepted),
        )
        .length;
    final hasInterests = interestCount == null ? null : interestCount > 0;
    const translationPath = 'application.volunteer_database.my_requests.inbox';
    return ColoredBox(
      color: theme.colorScheme.primary.withValues(alpha: 0.08),
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, 8, 8, (hasInterests ?? false) ? 0 : 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 4,
          children: [
            if (interests.isLoading && hasInterests == null)
              const Center(child: CircularProgressIndicator())
            else if (interests.hasError && hasInterests == null)
              TextButton(
                onPressed: () => ref.invalidate(volunteerInterestsProvider),
                child: Text('$translationPath.error'.tr()),
              )
            else ...[
              Row(
                spacing: 4,
                children: [
                  Icon(
                    Icons.mark_email_unread_outlined,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        '$translationPath.${(hasInterests ?? false) ? 'title' : 'empty_title'}'
                            .tr(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: (hasInterests ?? false) ? 0 : 8,
                ),
                child: Text(
                  (hasInterests ?? false)
                      ? '$translationPath.description'.plural(
                          interestCount!,
                          name: 'count',
                        )
                      : '$translationPath.empty_description'.tr(),
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ],
            if (hasInterests ?? false)
              TextButton(
                onPressed: () {
                  ref
                      .read(volunteerInterestFilterProvider.notifier)
                      .select(VolunteerInterestFilter.received);
                  context.push(VolunteerInterestsPage.path);
                },
                child: Text('$translationPath.open'.tr()),
              ),
          ],
        ),
      ),
    );
  }
}

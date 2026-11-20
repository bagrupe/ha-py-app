import 'package:app/common/connectivity/offline_data_unavailable_exception.dart';
import 'package:app/common/pagination/offset_pagination_loader.dart';
import 'package:app/routes/profil/interests/volunteer_interests_provider.dart';
import 'package:app/routes/volunteer_database/providers/my_volunteer_requests_provider.dart';
import 'package:app/routes/volunteer_database/widgets/my_volunteer_request_card.dart';
import 'package:app/routes/volunteer_database/widgets/my_volunteer_request_card_skeleton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'parts/my_requests_error.dart';
part 'parts/my_requests_placeholder.dart';

/// Displays all entries belonging to the authenticated user.
class MyVolunteerRequestsList extends ConsumerWidget {
  /// Creates the list of the user's entries.
  const MyVolunteerRequestsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(myVolunteerRequestsProvider);
    final interestsLoading = ref.watch(volunteerInterestsProvider).isLoading;
    return RefreshIndicator(
      onRefresh: () async {
        ref
          ..invalidate(myVolunteerRequestsProvider)
          ..invalidate(volunteerInterestsProvider);
        await Future.wait([
          ref
              .read(myVolunteerRequestsProvider.future)
              .then<void>((_) {}, onError: (Object _, StackTrace _) {}),
          ref
              .read(volunteerInterestsProvider.future)
              .then<void>((_) {}, onError: (Object _, StackTrace _) {}),
        ]);
      },
      child: requestsAsync.when(
        loading: () => ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 88),
          itemCount: 3,
          separatorBuilder: (_, _) =>
              const Padding(padding: EdgeInsets.only(top: 12)),
          itemBuilder: (_, _) => const MyVolunteerRequestCardSkeleton(),
        ),
        error: (error, _) =>
            _MyRequestsPlaceholder(child: _MyRequestsError(error: error)),
        data: (state) {
          if (state.items.isEmpty && !requestsAsync.isLoading) {
            return _MyRequestsPlaceholder(
              child: Text(
                'application.volunteer_database.my_requests.empty'.tr(),
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            key: const PageStorageKey<String>('my-volunteer-requests'),
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 88),
            itemCount: state.items.isEmpty ? 3 : state.items.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (requestsAsync.isLoading || interestsLoading) {
                if (state.items.isNotEmpty && index == state.items.length) {
                  return const SizedBox.shrink();
                }
                return const MyVolunteerRequestCardSkeleton();
              }
              if (index < state.items.length) {
                return MyVolunteerRequestCard(request: state.items[index]);
              }
              return OffsetPaginationLoader(
                isLoading: state.isLoadingNextPage,
                hasNextPage: state.hasNextPage,
                loading: const MyVolunteerRequestCardSkeleton(),
                error: state.nextPageError == null
                    ? null
                    : TextButton(
                        onPressed: () => ref
                            .read(myVolunteerRequestsProvider.notifier)
                            .loadNextPage(),
                        child: Text('application.error.retry'.tr()),
                      ),
                onLoadMore: () => ref
                    .read(myVolunteerRequestsProvider.notifier)
                    .loadNextPage(),
              );
            },
          );
        },
      ),
    );
  }
}

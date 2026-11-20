import 'package:app/common/auth/auth.dart';
import 'package:app/common/auth/confirm_logout.dart';
import 'package:app/common/connectivity/offline_data_unavailable_exception.dart';
import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/common/volunteer_database/volunteer_logout_provider.dart';
import 'package:app/common/volunteer_database/volunteer_profile_provider.dart';
import 'package:app/common/volunteer_database/volunteer_time_credit_provider.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/routes/volunteer_database/providers/my_volunteer_requests_provider.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_marketplace_view_model.dart';
import 'package:app/routes/volunteer_database/views/my_volunteer_requests_page.dart';
import 'package:app/routes/volunteer_database/views/volunteer_request_create_page.dart';
import 'package:app/routes/volunteer_database/widgets/categories_filter.dart';
import 'package:app/routes/volunteer_database/widgets/parts/my_requests_title.dart';
import 'package:app/routes/volunteer_database/widgets/parts/time_credit_widget.dart';
import 'package:app/routes/volunteer_database/widgets/suggested_requests_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Marketplace placeholder page for authenticated volunteer database users.
class VolunteerDatabasePage extends ConsumerWidget {
  /// Creates the volunteer database marketplace placeholder page.
  const VolunteerDatabasePage({super.key});

  /// Absolute route path for the volunteer database marketplace page.
  static const path = '/ehrenamtsdatenbank/marketplace';

  /// Absolute route path for the volunteer database preview page.
  static const previewPath = '/ehrenamtsdatenbank';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(volunteerProfileProvider);
    final timeCreditAsync = ref.watch(volunteerTimeCreditProvider);
    final canCreateEntry = profileAsync.maybeWhen(
      data: (profile) => profile != null,
      orElse: () => false,
    );
    final hasStrongSession = switch (ref.watch(hasStrongSessionProvider)) {
      AsyncData(:final value) => value,
      _ => false,
    };
    final myRequestsAsync = ref.watch(myVolunteerRequestsProvider);
    final requestCount = myRequestsAsync.value?.totalCount ?? 0;

    ref.listen<String?>(volunteerAuthProvider, (previous, next) {
      if (!context.mounted) return;
      final currentLocation = GoRouter.of(
        context,
      ).routeInformationProvider.value.uri.toString();
      if (next == null && currentLocation.startsWith(previewPath)) {
        context.go(previewPath);
      }
    });

    return Scaffold(
      appBar: CommonAppBar(
        title: Text('application.volunteer_database.title'.tr()),
        logo: true,
        extraActions: [
          if (hasStrongSession)
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'application.profil.my_account.logout'.tr(),
              onPressed: () async {
                if (await confirmLogout(context, ref)) {
                  await ref.read(volunteerLogoutProvider)();
                }
              },
            ),
        ],
      ),
      body: Semantics(
        label: 'application.volunteer_database.marketplace.semantics.page'.tr(),
        explicitChildNodes: true,
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref
                ..invalidate(volunteerMarketplaceViewModelProvider)
                ..invalidate(myVolunteerRequestsProvider)
                ..invalidate(volunteerTimeCreditProvider);
              await Future.wait([
                ref.read(volunteerMarketplaceViewModelProvider(null).future),
                ref.read(myVolunteerRequestsProvider.future),
                ref.read(volunteerTimeCreditProvider.future),
              ]);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 16,
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      MyRequestsTitle(requestCount: requestCount),
                      TextButton(
                        onPressed: () =>
                            context.push(MyVolunteerRequestsPage.path),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 4,
                          children: [
                            Flexible(
                              child: Text('application.common.show_all'.tr()),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                  timeCreditAsync.when(
                    data: (timeCredit) {
                      if (timeCredit == null) {
                        return TimeCreditErrorWidget(
                          onRetry: () =>
                              ref.invalidate(volunteerTimeCreditProvider),
                        );
                      }
                      return TimeCreditWidget(model: timeCredit);
                    },
                    loading: () => const TimeCreditSkeleton(),
                    error: (error, stackTrace) => TimeCreditErrorWidget(
                      onRetry: () =>
                          ref.invalidate(volunteerTimeCreditProvider),
                      message: error is OfflineDataUnavailableException
                          ? 'application.volunteer_database.time_credit.offline'
                                .tr()
                          : null,
                    ),
                  ),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      Text(
                        'application.volunteer_database.marketplace.title'.tr(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      TextButton(
                        onPressed: canCreateEntry
                            ? () =>
                                  context.push(VolunteerRequestCreatePage.path)
                            : null,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            Flexible(
                              child: Text(
                                'application.volunteer_database.marketplace.create_entry'
                                    .tr(),
                                style: theme.textTheme.bodySmall!.copyWith(
                                  color: canCreateEntry
                                      ? theme.colorScheme.primary
                                      : theme.disabledColor,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.add,
                              color: canCreateEntry
                                  ? theme.colorScheme.primary
                                  : theme.disabledColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const CategoriesFilter(),
                  const SuggestedRequestsList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/common/volunteer_database/volunteer_database_enabled_notifier.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/transition_page/transition_page_builders.dart';
import 'package:app/routes/volunteer_database/views/access_denied.dart';
import 'package:app/routes/volunteer_database/views/bundid_onboarding.dart';
import 'package:app/routes/volunteer_database/views/login.dart';
import 'package:app/routes/volunteer_database/views/my_volunteer_requests_page.dart';
import 'package:app/routes/volunteer_database/views/register.dart';
import 'package:app/routes/volunteer_database/views/volunteer_database.dart';
import 'package:app/routes/volunteer_database/views/volunteer_request_create_page.dart';
import 'package:app/routes/volunteer_database/views/volunteer_request_details_page.dart';
import 'package:app/routes/volunteer_database/widgets/join_community_card.dart';
import 'package:app/routes/volunteer_database/widgets/login/volunteer_login_button.dart';
import 'package:app/routes/volunteer_database/widgets/suggested_requests_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Preview Page for the volunteer database for not logged in user(Ehrenamtsdatenbank).
class EBPreviewPage extends StatelessWidget {
  /// Creates a new Preview Page for the volunteer database for not logged in user
  const EBPreviewPage({super.key});

  /// Absolute route path for the volunteer database preview page.
  static const path = '/ehrenamtsdatenbank';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: Text('application.volunteer_database.title'.tr()),
        logo: true,
      ),
      body: Semantics(
        label: 'application.volunteer_database.title'.tr(),
        hint: 'application.volunteer_database.description'.tr(),
        header: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                  Text(
                    'application.volunteer_database.marketplace.title'.tr(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const VolunteerDatabaseLoginButton(),
                ],
              ),
              const SuggestedRequestsList(maxItems: 3),
              const JoinCommunityCard(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Returns the route for the Ehrenamtsdatenbank page.
GoRoute ehrenamtsdatenbankRoute(Ref ref) => GoRoute(
  path: '/ehrenamtsdatenbank',
  redirect: (_, state) {
    final disabledRedirect = volunteerDatabaseRedirectIfDisabled(ref);
    if (disabledRedirect != null) {
      return disabledRedirect;
    }
    // Only redirect the preview root — child routes (details, login, …)
    // must remain reachable when the user is authenticated.
    final isPreviewRoot =
        state.uri.path == EBPreviewPage.path ||
        state.uri.path == '${EBPreviewPage.path}/';
    if (ref.read(volunteerAuthProvider) != null && isPreviewRoot) {
      return VolunteerDatabasePage.path;
    }
    return null;
  },
  pageBuilder: TransitionPageBuilders.noTransition(
    builder: (_, __) => const EBPreviewPage(),
  ),
  routes: [
    GoRoute(
      path: 'login',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, __) => const VolunteerDatabaseLoginPage(),
      ),
    ),
    GoRoute(
      path: 'register',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, __) => const VolunteerDatabaseRegisterPage(),
      ),
    ),
    GoRoute(
      path: 'access-denied',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, __) => const VolunteerDatabaseAccessDeniedPage(),
      ),
    ),
    bundIdOnboardingRoute(),
    GoRoute(
      path: 'marketplace',
      redirect: (_, __) => volunteerDatabaseMarketplaceRedirect(ref),
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, __) => const VolunteerDatabasePage(),
      ),
      routes: [
        GoRoute(
          path: 'my-requests',
          pageBuilder: TransitionPageBuilders.sliding(
            builder: (_, __) => const MyVolunteerRequestsPage(),
          ),
        ),
        GoRoute(
          path: 'create',
          pageBuilder: TransitionPageBuilders.sliding(
            builder: (_, __) => const VolunteerRequestCreatePage(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: 'details/:id',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, state) {
          final id = state.pathParameters['id']!;
          return VolunteerRequestDetailsPage(requestId: id);
        },
      ),
    ),
  ],
);

/// Redirects unauthenticated users away from protected volunteer database routes.
String? volunteerDatabaseMarketplaceRedirect(Ref ref) {
  final disabledRedirect = volunteerDatabaseRedirectIfDisabled(ref);
  if (disabledRedirect != null) {
    return disabledRedirect;
  }
  if (ref.read(volunteerAuthProvider) == null) {
    return EBPreviewPage.path;
  }
  return null;
}

import 'package:app/common/auth/bundid_auth.dart';
import 'package:app/common/design_tokens.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/transition_page/transition_page_builders.dart';
import 'package:app/routes/volunteer_database/providers/bundid_onboarding/bundid_onboarding_notifier.dart';
import 'package:app/routes/volunteer_database/widgets/bundid_onboarding/bundid_onboarding_footer.dart';
import 'package:app/routes/volunteer_database/widgets/bundid_onboarding/bundid_onboarding_phone_card.dart';
import 'package:app/routes/volunteer_database/widgets/bundid_onboarding/bundid_onboarding_profile_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Onboarding page shown after the first successful BundID login, replacing Keycloak's own
/// "Update Account Information" screen. The account already exists at this point (created
/// immediately by `BundIdAuthService.ExchangeAsync`) — this screen shows the (read-only, BundID-
/// managed) profile data and lets the user optionally verify a phone number, without either being
/// required to finish (see `BundIdOnboardingNotifier`).
class BundIdOnboardingPage extends ConsumerStatefulWidget {
  /// Creates the BundID onboarding page.
  const BundIdOnboardingPage({
    required this.profileSuggestion,
    this.phoneNumberCollision = false,
    super.key,
  });

  /// Absolute route path for the BundID onboarding page.
  static const path = '/ehrenamtsdatenbank/bundid-onboarding';

  /// The profile data suggested by BundID for the new account, if any.
  final BundIdProfileSuggestion? profileSuggestion;

  /// Whether BundID supplied a phone number that already belonged to a different, non-BundID
  /// account — see `BundIdOnboardingNotifier.initializeFromSuggestion`.
  final bool phoneNumberCollision;

  @override
  ConsumerState<BundIdOnboardingPage> createState() =>
      _BundIdOnboardingPageState();
}

class _BundIdOnboardingPageState extends ConsumerState<BundIdOnboardingPage> {
  @override
  void initState() {
    super.initState();
    // Riverpod disallows modifying a provider synchronously during a widget lifecycle method
    // (including initState) — defer to right after the current build finishes.
    Future.microtask(
      () => ref
          .read(bundIdOnboardingProvider.notifier)
          .initializeFromSuggestion(
            widget.profileSuggestion,
            phoneNumberCollision: widget.phoneNumberCollision,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: Text(
          'application.volunteer_database.bundid_onboarding_page.title'.tr(),
        ),
        logo: true,
      ),
      body: Semantics(
        label:
            'application.volunteer_database.bundid_onboarding_page.semantics.page'
                .tr(),
        explicitChildNodes: true,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  restorationId: 'bundIdOnboardingScrollView',
                  padding: const EdgeInsets.fromLTRB(17, 28, 17, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Text(
                        'application.volunteer_database.bundid_onboarding_page.introduction'
                            .tr(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: DesignTokens.gray500,
                        ),
                      ),
                      const BundIdOnboardingProfileCard(),
                      const BundIdOnboardingPhoneCard(),
                    ],
                  ),
                ),
              ),
              const BundIdOnboardingFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Payload passed as `extra` when navigating to [BundIdOnboardingPage].
typedef BundIdOnboardingExtra = ({
  BundIdProfileSuggestion? profileSuggestion,
  bool phoneNumberCollision,
});

/// Returns the route for the BundID onboarding page.
GoRoute bundIdOnboardingRoute() => GoRoute(
  path: 'bundid-onboarding',
  pageBuilder: TransitionPageBuilders.sliding(
    builder: (_, state) {
      final extra = state.extra as BundIdOnboardingExtra?;
      return BundIdOnboardingPage(
        profileSuggestion: extra?.profileSuggestion,
        phoneNumberCollision: extra?.phoneNumberCollision ?? false,
      );
    },
  ),
);

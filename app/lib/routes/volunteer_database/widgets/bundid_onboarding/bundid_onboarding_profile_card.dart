import 'package:app/common/design_tokens.dart';
import 'package:app/components/forms/app_text_field.dart';
import 'package:app/routes/volunteer_database/providers/bundid_onboarding/bundid_onboarding_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Read-only card showing the profile data BundID provided for the account — these fields are
/// managed exclusively by BundID (see `BundIdAuthService.SyncProfileFromBundId` in the backend)
/// and are re-synced automatically on every future BundID login. To change them, the user has to
/// update their BundID account directly.
class BundIdOnboardingProfileCard extends ConsumerWidget {
  /// Creates the profile display card.
  const BundIdOnboardingProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final onboardingState = ref.watch(bundIdOnboardingProvider);
    const space = SizedBox(height: 10);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: DesignTokens.white,
        border: Border.all(color: DesignTokens.gray100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        // See BundIdOnboardingPhoneCard: initialValue only applies on first build, so the key
        // must change once the async BundID suggestion lands — otherwise these fields stay stuck
        // on their initial (empty) value if this card happens to render before the suggestion
        // arrives, even though the data was already saved correctly server-side.
        key: ValueKey('bundid-profile-${onboardingState.isInitialized}'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'application.volunteer_database.bundid_onboarding_page.profile.description'
                .tr(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: DesignTokens.gray500,
            ),
          ),
          space,
          AppTextField(
            enabled: false,
            initialValue: onboardingState.vorname,
            onChanged: (_) {},
            label:
                'application.volunteer_database.bundid_onboarding_page.profile.first_name'
                    .tr(),
          ),
          space,
          AppTextField(
            enabled: false,
            initialValue: onboardingState.nachname,
            onChanged: (_) {},
            label:
                'application.volunteer_database.bundid_onboarding_page.profile.last_name'
                    .tr(),
          ),
          space,
          AppTextField(
            enabled: false,
            initialValue: onboardingState.email,
            onChanged: (_) {},
            label:
                'application.volunteer_database.bundid_onboarding_page.profile.email'
                    .tr(),
          ),
          space,
          AppTextField(
            enabled: false,
            initialValue: onboardingState.street,
            onChanged: (_) {},
            label:
                'application.volunteer_database.bundid_onboarding_page.profile.street'
                    .tr(),
          ),
          space,
          AppTextField(
            enabled: false,
            initialValue: onboardingState.postalCode,
            onChanged: (_) {},
            label:
                'application.volunteer_database.bundid_onboarding_page.profile.postal_code'
                    .tr(),
          ),
          space,
          AppTextField(
            enabled: false,
            initialValue: onboardingState.city,
            onChanged: (_) {},
            label:
                'application.volunteer_database.bundid_onboarding_page.profile.city'
                    .tr(),
          ),
          space,
          AppTextField(
            enabled: false,
            initialValue: onboardingState.country,
            onChanged: (_) {},
            label:
                'application.volunteer_database.bundid_onboarding_page.profile.country'
                    .tr(),
          ),
        ],
      ),
    );
  }
}

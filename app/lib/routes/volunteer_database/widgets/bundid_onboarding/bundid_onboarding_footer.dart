import 'package:app/common/auth/bundid_auth.dart';
import 'package:app/common/design_tokens.dart';
import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/routes/volunteer_database/providers/bundid_onboarding/bundid_onboarding_notifier.dart';
import 'package:app/routes/volunteer_database/providers/bundid_onboarding/bundid_onboarding_step.dart';
import 'package:app/routes/volunteer_database/views/volunteer_database.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Footer action for the BundID onboarding flow.
class BundIdOnboardingFooter extends ConsumerStatefulWidget {
  /// Creates the footer action.
  const BundIdOnboardingFooter({super.key});

  @override
  ConsumerState<BundIdOnboardingFooter> createState() =>
      _BundIdOnboardingFooterState();
}

class _BundIdOnboardingFooterState
    extends ConsumerState<BundIdOnboardingFooter> {
  bool _isReverifyLoading = false;

  Future<void> _reverifyWithBundId() async {
    if (_isReverifyLoading) return;
    setState(() => _isReverifyLoading = true);

    final result = await loginWithBundIdDirect(ref);

    if (!mounted) return;
    setState(() => _isReverifyLoading = false);

    if (result.outcome == BundIdLoginOutcome.success) {
      ref.read(volunteerAuthProvider.notifier).signIn();
      context.go(VolunteerDatabasePage.path);
    }
    // On error/registrationRequired: stay on this screen, the existing
    // requiresBundIdReverification message remains visible so the user can retry or go back.
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(bundIdOnboardingProvider, (previous, next) {
      if (!next.isCompleted || (previous?.isCompleted ?? false)) {
        return;
      }
      ref.read(volunteerAuthProvider.notifier).signIn();
      context.go(VolunteerDatabasePage.path);
    });

    final onboardingState = ref.watch(bundIdOnboardingProvider);
    final notifier = ref.read(bundIdOnboardingProvider.notifier);
    final isSmsStep = onboardingState.currentStep == BundIdOnboardingStep.sms;
    final isPhoneStep =
        onboardingState.currentStep == BundIdOnboardingStep.phone;
    final buttonTextKey = isSmsStep
        ? 'application.volunteer_database.bundid_onboarding_page.confirm'
        : 'application.volunteer_database.bundid_onboarding_page.send_code';

    if (onboardingState.requiresBundIdReverification) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(17, 12, 17, 17),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'application.volunteer_database.bundid_onboarding_page.errors.requires_bundid_reverification'
                  .tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _isReverifyLoading ? null : _reverifyWithBundId,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: DesignTokens.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isReverifyLoading
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: DesignTokens.white,
                        ),
                      )
                    : Text(
                        'application.volunteer_database.bundid_onboarding_page.bundid_reverify'
                            .tr(),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: DesignTokens.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: notifier.reviewPhoneNumber,
              child: Text(
                'application.volunteer_database.bundid_onboarding_page.sms.check_phone'
                    .tr(),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 12, 17, 17),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            button: true,
            label: buttonTextKey.tr(),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: isSmsStep
                    ? notifier.confirmAndCompleteProfile
                    : notifier.sendSmsCode,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: DesignTokens.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: onboardingState.isLoading
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: DesignTokens.white,
                        ),
                      )
                    : Text(
                        buttonTextKey.tr(),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: DesignTokens.white,
                        ),
                      ),
              ),
            ),
          ),
          if (isPhoneStep) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: onboardingState.isLoading
                  ? null
                  : notifier.saveProfile,
              child: Text(
                'application.volunteer_database.bundid_onboarding_page.skip_phone_verification'
                    .tr(),
              ),
            ),
          ],
          if (onboardingState.errorMessageKey != null) ...[
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: Semantics(
                liveRegion: true,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    onboardingState.errorMessageKey!.tr(
                      namedArgs: onboardingState.errorMessageArgs,
                    ),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

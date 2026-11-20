import 'package:app/common/auth/bundid_auth.dart';
import 'package:app/common/design_tokens.dart';
import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/components/workflow_steps/app_workflow_footer.dart';
import 'package:app/routes/volunteer_database/providers/registration/volunteer_registration_notifier.dart';
import 'package:app/routes/volunteer_database/providers/registration/volunteer_registration_result.dart';
import 'package:app/routes/volunteer_database/providers/registration/volunteer_registration_step.dart';
import 'package:app/routes/volunteer_database/views/volunteer_database.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Footer action for the volunteer registration flow.
class VolunteerRegistrationFooter extends ConsumerStatefulWidget {
  /// Creates the footer action.
  const VolunteerRegistrationFooter({
    required this.onConsentRequired,
    super.key,
  });

  /// Called when a not-yet-linked BundID was authorized and needs the user's explicit consent
  /// before an account is created — see `VolunteerRegistrationContent`, which owns that step.
  final void Function(String token, BundIdProfileSuggestion suggestion)
  onConsentRequired;

  @override
  ConsumerState<VolunteerRegistrationFooter> createState() =>
      _VolunteerRegistrationFooterState();
}

class _VolunteerRegistrationFooterState
    extends ConsumerState<VolunteerRegistrationFooter> {
  bool _isBundIdLoading = false;
  bool _bundIdHasError = false;
  bool _isReverifyLoading = false;

  Future<void> _registerWithBundId() async {
    if (_isBundIdLoading) return;

    setState(() {
      _isBundIdLoading = true;
      _bundIdHasError = false;
    });

    final attempt = await startBundIdLogin(ref);

    if (!mounted) return;

    switch (attempt) {
      case BundIdLoginAttemptSuccess():
        // Already linked to an existing account — a normal login, nothing new is being created.
        ref.read(volunteerAuthProvider.notifier).signIn();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('application.common.bundid.welcome_back'.tr()),
          ),
        );
        context.go(VolunteerDatabasePage.path);
      case BundIdLoginAttemptConsentRequired(:final token, :final suggestion):
        setState(() => _isBundIdLoading = false);
        widget.onConsentRequired(token, suggestion);
      case BundIdLoginAttemptError():
        setState(() {
          _isBundIdLoading = false;
          _bundIdHasError = true;
        });
    }
  }

  /// Resolves the `EXISTING_ACCOUNT_REQUIRES_BUND_ID_REVERIFICATION` case (see
  /// `EhrenamtsbankAuthService.ValidateSmsCode`): the phone number belongs to an existing,
  /// BundID-verified account, so only a fresh BundID login (not the SMS code) can prove it's the
  /// same person.
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
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(volunteerRegistrationProvider, (previous, next) {
      if (previous?.registrationResult == next.registrationResult ||
          next.registrationResult == null) {
        return;
      }

      switch (next.registrationResult!) {
        case VolunteerRegistrationResult.success:
          context.go(VolunteerDatabasePage.path);
      }
    });

    final registrationState = ref.watch(volunteerRegistrationProvider);
    final notifier = ref.read(volunteerRegistrationProvider.notifier);

    if (registrationState.requiresBundIdReverification) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(17, 12, 17, 17),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'application.volunteer_database.register_page.errors.requires_bundid_reverification'
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
                        'application.volunteer_database.register_page.bundid_reverify'
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
                'application.volunteer_database.register_page.sms.check_phone'
                    .tr(),
              ),
            ),
          ],
        ),
      );
    }

    final buttonTextKey =
        registrationState.currentStep == VolunteerRegistrationStep.identity
        ? 'application.volunteer_database.register_page.start'
        : 'application.volunteer_database.register_page.continue';
    final isPhoneStep =
        registrationState.currentStep == VolunteerRegistrationStep.phone;
    return AppWorkflowFooter(
      label: buttonTextKey.tr(),
      semanticLabel:
          'application.volunteer_database.register_page.semantics.continue'
              .tr(),
      isLoading: registrationState.isLoading,
      trailingIcon:
          registrationState.currentStep == VolunteerRegistrationStep.identity
          ? Icons.arrow_forward
          : null,
      errorMessage: registrationState.errorMessageKey?.tr(
        namedArgs: registrationState.errorMessageArgs,
      ),
      onPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();
        notifier.continueRegistration();
      },
      contentAfterError: Column(
        children: [
          if (isPhoneStep) ...[
            const SizedBox(height: 16),
            Text(
              'application.volunteer_database.register_page.account_hint'.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: DesignTokens.gray500),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'application.volunteer_database.register_page.bundid_divider'
                        .tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: DesignTokens.gray500,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16),
            Semantics(
              button: true,
              label:
                  'application.volunteer_database.register_page.semantics.bundid_register'
                      .tr(),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _isBundIdLoading ? null : _registerWithBundId,
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: DesignTokens.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isBundIdLoading
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: DesignTokens.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.translate(
                              offset: const Offset(0, -4),
                              child: Image.asset(
                                'assets/images/logos/bundid_logo_white.png',
                                height: 22,
                                excludeFromSemantics: true,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                'application.volunteer_database.register_page.bundid_register'
                                    .tr(),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: DesignTokens.white),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            if (_bundIdHasError) ...[
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: Semantics(
                  liveRegion: true,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'application.volunteer_database.register_page.errors.bundid'
                          .tr(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

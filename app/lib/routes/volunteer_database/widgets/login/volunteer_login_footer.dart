import 'package:app/common/auth/bundid_auth.dart';
import 'package:app/common/design_tokens.dart';
import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/components/workflow_steps/app_workflow_footer.dart';
import 'package:app/routes/volunteer_database/providers/login/volunteer_login_notifier.dart';
import 'package:app/routes/volunteer_database/providers/login/volunteer_login_step.dart';
import 'package:app/routes/volunteer_database/views/register.dart';
import 'package:app/routes/volunteer_database/views/volunteer_database.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Footer action for the volunteer login flow.
class VolunteerLoginFooter extends ConsumerStatefulWidget {
  /// Creates the footer action.
  const VolunteerLoginFooter({required this.onConsentRequired, super.key});

  /// Called when a not-yet-linked BundID was authorized and needs the user's explicit consent
  /// before an account is created — see `VolunteerLoginContent`, which owns that step.
  final void Function(String token, BundIdProfileSuggestion suggestion)
  onConsentRequired;

  @override
  ConsumerState<VolunteerLoginFooter> createState() =>
      _VolunteerLoginFooterState();
}

class _VolunteerLoginFooterState extends ConsumerState<VolunteerLoginFooter> {
  bool _isBundIdLoading = false;
  bool _bundIdHasError = false;
  bool _isReverifyLoading = false;

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

  Future<void> _loginWithBundId() async {
    if (_isBundIdLoading) return;

    setState(() {
      _isBundIdLoading = true;
      _bundIdHasError = false;
    });

    final attempt = await startBundIdLogin(ref);

    if (!mounted) return;

    switch (attempt) {
      case BundIdLoginAttemptSuccess():
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

  @override
  Widget build(BuildContext context) {
    ref.listen(volunteerLoginProvider, (previous, next) {
      if (previous?.loginResult == next.loginResult ||
          next.loginResult == null) {
        return;
      }

      context.go(VolunteerDatabasePage.path);
    });

    final loginState = ref.watch(volunteerLoginProvider);
    final notifier = ref.read(volunteerLoginProvider.notifier);
    final isSmsStep = loginState.currentStep == VolunteerLoginStep.sms;
    final isIdentityStep =
        loginState.currentStep == VolunteerLoginStep.identity;

    if (loginState.requiresBundIdReverification) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(17, 12, 17, 17),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'application.volunteer_database.login_page.errors.requires_bundid_reverification'
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
                        'application.volunteer_database.login_page.bundid_reverify'
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
                'application.volunteer_database.login_page.sms.check_phone'
                    .tr(),
              ),
            ),
          ],
        ),
      );
    }

    return AppWorkflowFooter(
      label:
          (isIdentityStep
                  ? 'application.volunteer_database.register_page.start'
                  : isSmsStep
                  ? 'application.volunteer_database.login_page.login'
                  : 'application.volunteer_database.login_page.continue')
              .tr(),
      semanticLabel:
          'application.volunteer_database.login_page.semantics.continue'.tr(),
      isLoading: loginState.isLoading,
      trailingIcon: isSmsStep || isIdentityStep ? Icons.arrow_forward : null,
      errorMessage: loginState.errorMessageKey?.tr(
        namedArgs: loginState.errorMessageArgs,
      ),
      onPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();
        notifier.continueLogin();
      },
      contentBeforeAction: isIdentityStep
          ? null
          : Column(
              children: [
                Text(
                  'application.volunteer_database.login_page.no_account'.tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: DesignTokens.gray500),
                ),
                TextButton(
                  onPressed: () =>
                      context.push(VolunteerDatabaseRegisterPage.path),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 28),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: Text(
                    'application.volunteer_database.login_page.register_now'
                        .tr(),
                  ),
                ),
              ],
            ),
      contentAfterError: isIdentityStep
          ? null
          : Column(
              children: [
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'application.volunteer_database.login_page.bundid_divider'
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
                      'application.volunteer_database.login_page.semantics.bundid_login'
                          .tr(),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: _isBundIdLoading ? null : _loginWithBundId,
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
                                // The source logo's canvas includes the three dots above the
                                // wordmark, so the "bund·ID" glyphs sit below the image's own
                                // vertical center; nudge it up to align with the button text.
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
                                    'application.volunteer_database.login_page.bundid_login'
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
                          'application.volunteer_database.login_page.errors.bundid'
                              .tr(),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
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

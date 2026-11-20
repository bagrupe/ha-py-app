import 'package:app/common/auth/bundid_auth.dart';
import 'package:app/common/auth/bundid_consent_view.dart';
import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/routes/volunteer_database/views/bundid_onboarding.dart';
import 'package:app/routes/volunteer_database/widgets/login/volunteer_login_footer.dart';
import 'package:app/routes/volunteer_database/widgets/login/volunteer_login_header.dart';
import 'package:app/routes/volunteer_database/widgets/login/volunteer_login_steps.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Complete login content for the volunteer database.
///
/// Owns the BundID account-creation consent state (see `BundIdConsentView`): a not-yet-linked
/// BundID never creates an account by itself, no matter how the login was started (Ehrenamtsbank,
/// "Mein Konto", ...) — the same explicit consent/cancel step is shown everywhere, held here
/// rather than in the footer so it can replace the whole page content, not just the buttons.
class VolunteerLoginContent extends ConsumerStatefulWidget {
  /// Creates the complete login content.
  const VolunteerLoginContent({super.key});

  @override
  ConsumerState<VolunteerLoginContent> createState() =>
      _VolunteerLoginContentState();
}

class _VolunteerLoginContentState extends ConsumerState<VolunteerLoginContent> {
  String? _pendingToken;
  BundIdProfileSuggestion? _pendingSuggestion;
  bool _isConfirmingRegistration = false;

  void _showConsent(String token, BundIdProfileSuggestion suggestion) {
    setState(() {
      _pendingToken = token;
      _pendingSuggestion = suggestion;
    });
  }

  void _cancelPendingRegistration() {
    setState(() {
      _pendingToken = null;
      _pendingSuggestion = null;
    });
  }

  /// Erstellt das Konto tatsächlich mit den zuvor angezeigten Daten — wird ausschließlich durch
  /// den expliziten Tap auf "Zustimmen" in [BundIdConsentView] ausgelöst.
  Future<void> _confirmRegistration() async {
    final token = _pendingToken;
    if (token == null || _isConfirmingRegistration) return;
    setState(() => _isConfirmingRegistration = true);

    final result = await confirmBundIdRegistrationWithRetry(ref, token);
    if (!mounted) return;

    if (result.outcome != BundIdLoginOutcome.success) {
      setState(() => _isConfirmingRegistration = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(bundIdErrorMessage(result))));
      return;
    }

    ref.read(volunteerAuthProvider.notifier).signIn();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('application.common.bundid.account_created'.tr())),
    );
    if (!mounted) return;
    context.go(
      BundIdOnboardingPage.path,
      extra: (
        profileSuggestion: result.profileSuggestion,
        phoneNumberCollision: result.phoneNumberCollision,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_pendingSuggestion != null) {
      return BundIdConsentView(
        suggestion: _pendingSuggestion!,
        isConfirming: _isConfirmingRegistration,
        onConfirm: _confirmRegistration,
        onCancel: _cancelPendingRegistration,
      );
    }

    return Semantics(
      label: 'application.volunteer_database.login_page.semantics.page'.tr(),
      explicitChildNodes: true,
      child: SafeArea(
        child: SingleChildScrollView(
          key: const PageStorageKey('volunteerLoginScrollView'),
          restorationId: 'volunteerLoginScrollView',
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(17, 28, 17, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VolunteerLoginHeader(),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: VolunteerLoginSteps(),
                    ),
                  ],
                ),
              ),
              VolunteerLoginFooter(onConsentRequired: _showConsent),
            ],
          ),
        ),
      ),
    );
  }
}

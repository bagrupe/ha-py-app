import 'package:app/common/auth/bundid_auth.dart';
import 'package:app/common/design_tokens.dart';
import 'package:app/components/forms/app_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Shows the profile data a not-yet-linked BundID would create an account with, and waits for the
/// user's explicit consent before anything is persisted — used by every BundID entry point in the
/// app (Ehrenamtsbank Login/Registrieren, "Mein Konto") so account creation always requires an
/// affirmative choice, with an equally explicit way to back out, instead of happening silently as
/// a side effect of just logging in.
class BundIdConsentView extends StatelessWidget {
  /// Creates the consent view.
  const BundIdConsentView({
    required this.suggestion,
    required this.isConfirming,
    required this.onConfirm,
    required this.onCancel,
    super.key,
  });

  /// The (unverified) profile data preview extracted from the not-yet-exchanged BundID token.
  final BundIdProfileSuggestion suggestion;

  /// Whether [onConfirm] is currently in flight.
  final bool isConfirming;

  /// Called when the user explicitly agrees to create the account with this data.
  final VoidCallback onConfirm;

  /// Called when the user declines — nothing was created, safe to just discard the token.
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(17, 24, 17, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text(
            'application.common.bundid.consent.title'.tr(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            'application.common.bundid.consent.intro'.tr(),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: DesignTokens.gray500),
          ),
          AppTextField(
            enabled: false,
            initialValue: suggestion.vorname ?? '',
            onChanged: (_) {},
            label: 'application.common.bundid.consent.first_name'.tr(),
          ),
          AppTextField(
            enabled: false,
            initialValue: suggestion.nachname ?? '',
            onChanged: (_) {},
            label: 'application.common.bundid.consent.last_name'.tr(),
          ),
          AppTextField(
            enabled: false,
            initialValue: suggestion.email ?? '',
            onChanged: (_) {},
            label: 'application.common.bundid.consent.email'.tr(),
          ),
          AppTextField(
            enabled: false,
            initialValue: suggestion.street ?? '',
            onChanged: (_) {},
            label: 'application.common.bundid.consent.street'.tr(),
          ),
          AppTextField(
            enabled: false,
            initialValue: suggestion.postalCode ?? '',
            onChanged: (_) {},
            label: 'application.common.bundid.consent.postal_code'.tr(),
          ),
          AppTextField(
            enabled: false,
            initialValue: suggestion.city ?? '',
            onChanged: (_) {},
            label: 'application.common.bundid.consent.city'.tr(),
          ),
          AppTextField(
            enabled: false,
            initialValue: suggestion.country ?? '',
            onChanged: (_) {},
            label: 'application.common.bundid.consent.country'.tr(),
          ),
          const Divider(),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: isConfirming ? null : onConfirm,
              child: isConfirming
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: DesignTokens.white,
                      ),
                    )
                  : Text('application.common.bundid.consent.confirm'.tr()),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: isConfirming ? null : onCancel,
              child: Text('application.common.bundid.consent.cancel'.tr()),
            ),
          ),
        ],
      ),
    );
  }
}

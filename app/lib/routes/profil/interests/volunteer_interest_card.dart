import 'package:app/common/design_tokens.dart';
import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/common/volunteer_database/volunteer_interest_submission_exception.dart';
import 'package:app/components/buttons/app_filled_button.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/routes/profil/interests/volunteer_agreement_button.dart';
import 'package:app/routes/profil/interests/volunteer_completion_section.dart';
import 'package:app/routes/profil/interests/volunteer_contact_consent_provider.dart';
import 'package:app/routes/profil/interests/volunteer_contact_consent_sheet.dart';
import 'package:app/routes/profil/interests/volunteer_contact_history_provider.dart';
import 'package:app/routes/profil/interests/volunteer_contact_privacy_hint.dart';
import 'package:app/routes/profil/interests/volunteer_interest_action_provider.dart';
import 'package:app/routes/profil/interests/volunteer_interest_status_details.dart';
import 'package:app/routes/profil/interests/volunteer_interest_timestamp.dart';
import 'package:app/routes/profil/interests/volunteer_interests_provider.dart';
import 'package:app/routes/profil/interests/volunteer_whatsapp_launcher.dart';
import 'package:app/routes/volunteer_database/models/volunteer_interest_overview_model.dart';
import 'package:app/routes/volunteer_database/widgets/parts/volunteer_request_creator_avatar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays one sent or received volunteer interest request.
class VolunteerInterestCard extends ConsumerWidget {
  /// Creates a card for [interest].
  const VolunteerInterestCard({required this.interest, super.key});

  /// Interest request displayed by this card.
  final VolunteerInterestOverviewModel interest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const basePath = 'application.profile.volunteer_interests';
    final isReceived =
        interest.type == Enum_EhrenamtsbankAnfrageTyp.EMPFANGENE_ANFRAGE;
    final message = interest.message?.trim();
    final description = message?.isNotEmpty ?? false
        ? message!
        : interest.entryDescription;
    final initial = interest.personName.isEmpty
        ? ''
        : interest.personName.characters.first.toUpperCase();
    final actionProvider = volunteerInterestActionProvider(interest.id);
    final actionState = ref.watch(actionProvider);
    final hasContactConsent = ref.watch(
      volunteerContactConsentProvider(interest.id),
    );
    ref.listen(actionProvider, (_, next) {
      if (!next.hasError) return;
      final error = next.error;
      final messageKey = error is VolunteerInterestSubmissionException
          ? error.messageKey
          : '$basePath.actions.errors.generic';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(messageKey.tr())));
    });
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      container: true,
      label: '$basePath.card_semantics'.tr(
        namedArgs: {
          'person': interest.personName,
          'title': interest.entryTitle,
          'status': interest.statusTranslationKey.tr(),
        },
      ),
      child: Card.outlined(
        elevation: 0,
        color: colorScheme.surfaceContainerLowest,
        margin: const EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 8,
                children: [
                  VolunteerRequestCreatorAvatar(initials: initial),
                  Expanded(
                    child: Text(
                      interest.personName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    VolunteerInterestTimestamp.format(interest.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: DesignTokens.gray500,
                    ),
                  ),
                ],
              ),
              Text(
                interest.entryTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (description.isNotEmpty)
                Text(description, style: Theme.of(context).textTheme.bodySmall),
              VolunteerInterestStatusDetails(
                status: interest.status,
                statusTranslationKey: interest.statusTranslationKey,
                agreementConfirmedAt: interest.agreementConfirmedAt,
              ),
              if (hasContactConsent)
                const VolunteerContactPrivacyHint(isModalHint: false),
              VolunteerAgreementButton(
                isVisible: interest.canConfirmAgreement,
                isLoading: actionState.isLoading,
                onPressed: () => ref
                    .read(actionProvider.notifier)
                    .updateStatus(Enum_EhrenamtsbankAnfrageStatus.VEREINBART),
              ),
              if (interest.isOpen || interest.canContact)
                Row(
                  spacing: 8,
                  children: [
                    if (interest.isOpen)
                      Expanded(
                        child: Semantics(
                          button: true,
                          label: isReceived
                              ? '$basePath.actions.reject'.tr()
                              : '$basePath.actions.withdraw'.tr(),
                          excludeSemantics: true,
                          child: SizedBox(
                            height: MediaQuery.textScalerOf(
                              context,
                            ).scale(48).clamp(48.0, 500.0),
                            child: OutlinedButton(
                              onPressed: actionState.isLoading
                                  ? null
                                  : () => ref
                                        .read(actionProvider.notifier)
                                        .updateStatus(
                                          isReceived
                                              ? Enum_EhrenamtsbankAnfrageStatus
                                                    .ABGELEHNT
                                              : Enum_EhrenamtsbankAnfrageStatus
                                                    .ZURUECKGEZOGEN,
                                        ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                side: BorderSide(color: colorScheme.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: actionState.isLoading
                                  ? const SizedBox.square(
                                      dimension: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      isReceived
                                          ? '$basePath.actions.reject'.tr()
                                          : '$basePath.actions.withdraw'.tr(),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: AppFilledButton(
                        label: '$basePath.actions.contact'.tr(),
                        onPressed: interest.canContact && !actionState.isLoading
                            ? () =>
                                  _contact(context, ref, isReceived: isReceived)
                            : null,
                      ),
                    ),
                  ],
                ),
              if (interest.isAgreed || interest.isCompleted)
                VolunteerCompletionSection(interest: interest),
            ],
          ),
        ),
      ),
    );
  }

  /// Requests consent when needed and opens the matched WhatsApp chat.
  Future<void> _contact(
    BuildContext context,
    WidgetRef ref, {
    required bool isReceived,
  }) async {
    final userId = ref.read(volunteerAuthProvider);
    if (userId == null) return;
    final historyProvider = volunteerContactHistoryProvider((
      userId: userId,
      entryId: interest.entryId,
    ));
    final historyNotifier = ref.read(historyProvider.notifier);
    final actionProvider = volunteerInterestActionProvider(interest.id);
    final consentProvider = volunteerContactConsentProvider(interest.id);
    final hasConsent = ref.read(consentProvider);
    if (!hasConsent) {
      final accepted = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => const VolunteerContactConsentSheet(),
      );
      if (accepted != true || !context.mounted) return;
      await ref.read(consentProvider.notifier).grant();
      if (!context.mounted) return;
    }
    if (isReceived && interest.isOpen) {
      await ref
          .read(actionProvider.notifier)
          .updateStatus(Enum_EhrenamtsbankAnfrageStatus.AKZEPTIERT);
      if (ref.read(actionProvider).hasError || !context.mounted) return;
    }
    final refreshedInterest = ref
        .read(volunteerInterestsProvider)
        .value
        ?.where((item) => item.id == interest.id)
        .firstOrNull;
    final phone = refreshedInterest?.contactPhone ?? interest.contactPhone;
    if (phone?.trim().isEmpty ?? true) {
      _showError(context, 'phone_unavailable');
      return;
    }
    final opened = await VolunteerWhatsAppLauncher.open(
      phoneNumber: phone!,
      message: ref.read(historyProvider)
          ? null
          : 'application.profile.volunteer_interests.actions.whatsapp_message'
                .tr(namedArgs: {'title': interest.entryTitle}),
    );
    if (opened) {
      await historyNotifier.markOpened();
    }
    if (!opened && context.mounted) {
      _showError(context, 'whatsapp_unavailable');
    }
  }

  /// Displays a localized contact-flow error.
  void _showError(BuildContext context, String errorKey) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'application.profile.volunteer_interests.actions.errors.$errorKey'
              .tr(),
        ),
      ),
    );
  }
}

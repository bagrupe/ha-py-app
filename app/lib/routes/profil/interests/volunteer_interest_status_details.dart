import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays the current request status and agreement time.
class VolunteerInterestStatusDetails extends StatelessWidget {
  /// Creates status details for [status].
  const VolunteerInterestStatusDetails({
    required this.status,
    required this.agreementConfirmedAt,
    this.statusTranslationKey,
    super.key,
  });

  /// Current backend request status.
  final Enum_EhrenamtsbankAnfrageStatus status;

  /// Optional translation key derived from the request lifecycle and role.
  final String? statusTranslationKey;

  /// Time at which either party confirmed the agreement.
  final DateTime? agreementConfirmedAt;

  @override
  Widget build(BuildContext context) {
    const basePath = 'application.profile.volunteer_interests';
    final localizedStatus =
        (statusTranslationKey ?? '$basePath.status.${status.name}').tr();
    final statusLabel = '$basePath.status_label'.tr(
      namedArgs: {'status': localizedStatus},
    );
    final localAgreementTime =
        status == Enum_EhrenamtsbankAnfrageStatus.VEREINBART
        ? agreementConfirmedAt?.toLocal()
        : null;
    final agreementLabel = localAgreementTime == null
        ? null
        : '$basePath.agreement_confirmed_at'.tr(
            namedArgs: {
              'date': DateFormat.yMd(
                Intl.getCurrentLocale(),
              ).add_Hm().format(localAgreementTime),
            },
          );
    final semanticLabel = [
      statusLabel,
      if (agreementLabel != null) agreementLabel,
    ].join('. ');
    return Semantics(
      container: true,
      liveRegion: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            statusLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (agreementLabel != null)
            Text(agreementLabel, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

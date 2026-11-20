import 'package:app/common/design_tokens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays confirmation for an interest request accepted by the backend.
class VolunteerInterestRequestedInfo extends StatelessWidget {
  /// Creates the requested-state confirmation.
  const VolunteerInterestRequestedInfo({super.key});

  @override
  Widget build(BuildContext context) {
    const basePath =
        'application.volunteer_database.details.interest.requested';
    return Semantics(
      container: true,
      liveRegion: true,
      label: '$basePath.semantics'.tr(),
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: DesignTokens.green200,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 6,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 20,
                  color: DesignTokens.green900,
                ),
                Expanded(
                  child: Text(
                    '$basePath.title'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              '$basePath.description'.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

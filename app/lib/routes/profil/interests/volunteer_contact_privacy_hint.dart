import 'package:app/common/design_tokens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays the WhatsApp mobile-number privacy notice.
class VolunteerContactPrivacyHint extends StatelessWidget {
  /// Creates the privacy notice.
  const VolunteerContactPrivacyHint({super.key, this.isModalHint = true});

  final bool isModalHint;

  @override
  Widget build(BuildContext context) {
    const key = 'application.profile.volunteer_interests.actions.privacy_hint';
    return Semantics(
      label: key.tr(),
      excludeSemantics: true,
      child: Row(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isModalHint)
            const Icon(
              Icons.info_outline,
              size: 14,
              color: DesignTokens.green900,
            ),
          Expanded(
            child: Text(
              key.tr(),
              style: isModalHint
                  ? Theme.of(context).textTheme.bodySmall
                  : Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }
}

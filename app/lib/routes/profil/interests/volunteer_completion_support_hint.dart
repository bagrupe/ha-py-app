import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays support guidance when both parties cannot agree.
class VolunteerCompletionSupportHint extends StatelessWidget {
  /// Creates the completion support hint.
  const VolunteerCompletionSupportHint({super.key});

  @override
  Widget build(BuildContext context) {
    const key =
        'application.profile.volunteer_interests.completion.support_hint';
    return Semantics(
      container: true,
      child: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.help_outline, size: 18),
          Expanded(
            child: Text(key.tr(), style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

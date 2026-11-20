import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Error state for volunteer marketplace categories.
class CategoriesErrorState extends StatelessWidget {
  /// Creates an error state with a retry action.
  const CategoriesErrorState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = 'application.volunteer_database.categories_error'.tr();

    return Semantics(
      liveRegion: true,
      label: message,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              textAlign: TextAlign.start,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

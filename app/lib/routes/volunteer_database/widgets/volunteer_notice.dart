import 'package:flutter/material.dart';

/// Consistent informational block for volunteer entry status messages.
class VolunteerNotice extends StatelessWidget {
  /// Creates a notice using already localized display text.
  const VolunteerNotice({
    required this.icon,
    required this.title,
    required this.description,
    this.supportingText,
    super.key,
  });

  /// Decorative status icon displayed beside the title.
  final IconData icon;

  /// Localized heading describing the current status.
  final String title;

  /// Localized explanation of the status.
  final String description;

  /// Optional supplementary details such as the completed duration.
  final String? supportingText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      liveRegion: true,
      child: ColoredBox(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 4,
            children: [
              Semantics(
                header: true,
                child: Row(
                  spacing: 4,
                  children: [
                    ExcludeSemantics(
                      child: Icon(
                        icon,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(description, style: theme.textTheme.bodySmall),
              if (supportingText != null)
                Text(supportingText!, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

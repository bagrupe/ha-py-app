import 'package:app/components/buttons/app_filled_button.dart';
import 'package:flutter/material.dart';

/// Displays a shared workflow action area with optional supporting content.
class AppWorkflowFooter extends StatelessWidget {
  /// Creates a workflow footer.
  const AppWorkflowFooter({
    required this.label,
    required this.onPressed,
    this.semanticLabel,
    this.isLoading = false,
    this.trailingIcon,
    this.errorMessage,
    this.contentBeforeAction,
    this.contentAfterError,
    super.key,
  });

  /// Text displayed inside the primary action.
  final String label;

  /// Action invoked when the primary button is pressed.
  final VoidCallback? onPressed;

  /// Accessible label announced for the primary action.
  final String? semanticLabel;

  /// Whether the primary action displays progress and blocks interaction.
  final bool isLoading;

  /// Optional icon displayed after the action label.
  final IconData? trailingIcon;

  /// Optional error displayed as an accessible live region.
  final String? errorMessage;

  /// Optional content displayed before the primary action.
  final Widget? contentBeforeAction;

  /// Optional content displayed after the shared error area.
  final Widget? contentAfterError;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 12, 17, 17),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (contentBeforeAction != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: contentBeforeAction,
            ),
          ],
          AppFilledButton(
            label: label,
            semanticLabel: semanticLabel,
            isLoading: isLoading,
            trailingIcon: trailingIcon,
            onPressed: onPressed,
          ),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Semantics(
                  liveRegion: true,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      errorMessage!,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (contentAfterError != null)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: contentAfterError,
            ),
        ],
      ),
    );
  }
}

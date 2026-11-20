import 'package:app/common/design_tokens.dart';
import 'package:flutter/material.dart';

/// Displays the numbered badge of a multi-step workflow.
class WorkflowStepNumber extends StatelessWidget {
  /// Creates a workflow step number badge.
  const WorkflowStepNumber({
    required this.number,
    required this.isActive,
    this.isCompleted = false,
    super.key,
  });

  /// Visible one-based step number.
  final int number;

  /// Whether the badge belongs to the active step.
  final bool isActive;

  /// Whether the badge belongs to a completed step.
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.textScalerOf(context).scale(24);

    return ExcludeSemantics(
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isActive
                      ? theme.colorScheme.onPrimary
                      : DesignTokens.gray700,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

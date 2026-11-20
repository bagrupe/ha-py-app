import 'package:app/common/design_tokens.dart';
import 'package:app/components/rounded_meta_icon.dart';
import 'package:app/components/workflow_steps/workflow_step_number.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays one step and its optional content in a multi-step workflow.
class WorkflowStepRow extends StatelessWidget {
  /// Creates a workflow step row.
  const WorkflowStepRow({
    required this.number,
    required this.title,
    required this.semanticsLabelKey,
    this.content,
    this.isActive = false,
    this.isCompleted = false,
    super.key,
  });

  /// Visible one-based step number.
  final int number;

  /// Localized step title.
  final String title;

  /// Whether this step is currently active.
  final bool isActive;

  /// Whether this step has been completed.
  final bool isCompleted;

  /// Optional content displayed below the step title.
  final Widget? content;

  /// Translation key used to announce the step number and title.
  final String semanticsLabelKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foregroundColor = isActive || isCompleted
        ? DesignTokens.gray900
        : DesignTokens.gray700;
    final titleStyle = theme.textTheme.bodyLarge?.copyWith(
      color: foregroundColor,
      fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
    );

    return Semantics(
      label: semanticsLabelKey.tr(
        namedArgs: {'number': number.toString(), 'title': title},
      ),
      selected: isActive,
      explicitChildNodes: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              WorkflowStepNumber(
                number: number,
                isActive: isActive,
                isCompleted: isCompleted,
              ),
              const SizedBox(width: 7),
              Flexible(child: Text(title, style: titleStyle)),
              if (isCompleted)
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: RoundedMetaIcon(),
                ),
            ],
          ),
          if (content != null) ...[const SizedBox(height: 16), content!],
        ],
      ),
    );
  }
}

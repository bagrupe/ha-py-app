import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:app/routes/melder/common/report_workflow_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Button that starts a configured reporting workflow.
class ReportCreateButton extends ConsumerWidget {
  const ReportCreateButton({required this.config, super.key, this.buttonKey});

  /// Configuration used to start the matching reporting workflow.
  final ReportWorkflowConfig config;

  /// Optional key used by integration tests.
  final Key? buttonKey;

  /// Starts the configured reporting form.
  Future<void> _openForm(BuildContext context, WidgetRef ref) async {
    final progress = ref.read(antragProgressProvider.notifier);

    await progress.launchSpecialProzess(
      tag: config.tag,
      route: config.stepRoute,
      meta: config.toMeta(),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outlineButtonStyle = Theme.of(context).outlinedButtonTheme;
    final label = config.addButtonLabelKey.tr();

    return Semantics(
      button: true,
      label: label,
      child: OutlinedButton(
        key: buttonKey ?? config.addButtonKey,
        style: outlineButtonStyle.style?.copyWith(
          backgroundColor: const WidgetStatePropertyAll(Colors.white),
        ),
        onPressed: () => _openForm(context, ref),
        child: Text(label),
      ),
    );
  }
}

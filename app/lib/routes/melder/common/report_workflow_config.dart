import 'package:app/routes/antraege/common/antrag_meta.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Configuration for a reusable reporting workflow.
@immutable
class ReportWorkflowConfig {
  /// Creates a configuration for list and creation routes of a reporting workflow.
  const ReportWorkflowConfig({
    required this.tag,
    required this.overviewRoute,
    required this.stepRoute,
    required this.detailRoutePrefix,
    required this.titleKey,
    required this.completedTextKey,
    required this.completionButtonTextKey,
    required this.addButtonLabelKey,
    required this.reportedTitleKey,
    required this.emptyMessageKey,
    required this.errorMessageKey,
    this.addButtonKey,
  });

  /// Process tag used by the backend to resolve the special process.
  final String tag;

  /// Route to the overview page.
  final String overviewRoute;

  /// Route to the step-by-step form.
  final String stepRoute;

  /// Route prefix for opening an existing reported item detail page.
  final String detailRoutePrefix;

  /// Translation key for the workflow title.
  final String titleKey;

  /// Translation key for the text shown after successful submission.
  final String completedTextKey;

  /// Translation key for the submit button text.
  final String completionButtonTextKey;

  /// Translation key for the create button label.
  final String addButtonLabelKey;

  /// Translation key for the reported items section title.
  final String reportedTitleKey;

  /// Optional key for the create button.
  final Key? addButtonKey;

  /// Translation key for the empty overview message.
  final String emptyMessageKey;

  /// Translation key for the overview loading error.
  final String errorMessageKey;

  /// Builds the detail route for an existing reported item.
  String detailRoute(String id) => '$detailRoutePrefix$id';

  /// Creates AntragMeta from the localized configuration values.
  AntragMeta toMeta() {
    return AntragMeta(
      titleKey.tr(),
      completedTextKey.tr(),
      completionButtonTextKey.tr(),
      overviewRoute,
    );
  }
}

import 'package:app/common/design_tokens.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/graphql/__generated__/ausfuehrung.graphql.dart';
import 'package:app/routes/melder/common/report_execution_status_extension.dart';
import 'package:app/routes/melder/common/report_workflow_config.dart';
import 'package:app/routes/melder/components/report_history_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Detail page for an existing user-created reporting execution.
class ReportExecutionDetailPage extends StatelessWidget {
  const ReportExecutionDetailPage({
    required this.id,
    required this.config,
    super.key,
  });

  /// Execution id loaded by this detail page.
  final String id;

  /// Workflow configuration used for labels and navigation context.
  final ReportWorkflowConfig config;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CommonAppBar(title: Text(config.titleKey.tr()), menu: false),
      body: Query_AusfuehrungHistorie_Widget(
        options: Options_Query_AusfuehrungHistorie(
          variables: Variables_Query_AusfuehrungHistorie(id: id),
        ),
        builder: (result, {fetchMore, refetch}) {
          final execution = result.parsedData?.ausfuehrung;

          if (execution == null && result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (execution == null || result.hasException) {
            return Center(child: Text(config.errorMessageKey.tr()));
          }

          final status = execution.status.localizedLabel;
          final title = execution.prozessVersion.prozess.name;

          return Semantics(
            label: 'application.melder.detail_semantics'.tr(
              namedArgs: {'title': title, 'status': status},
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(title, style: textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    status,
                    style: textTheme.bodyLarge?.copyWith(
                      color: DesignTokens.gray500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'application.melder.history_title'.tr(),
                    style: textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  ...execution.historie.map(
                    (history) => ReportHistoryItem(history: history),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

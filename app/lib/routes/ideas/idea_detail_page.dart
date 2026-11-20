import 'package:app/common/app_config/app_config.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/graphql/__generated__/ausfuehrung.graphql.dart';
import 'package:app/routes/ideas/common/idea.dart';
import 'package:app/routes/ideas/components/idea_detail_content.dart';
import 'package:app/routes/melder/common/report_execution_status_extension.dart';
import 'package:app/routes/melder/common/report_workflow_configs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Detail page for a submitted idea.
class IdeaDetailPage extends ConsumerWidget {
  /// Creates an idea detail page for the given execution id.
  const IdeaDetailPage({required this.id, super.key});

  /// Execution id of the submitted idea.
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backendUrl = ref.watch(appConfigProvider).backendUrl;

    return Scaffold(
      appBar: CommonAppBar(
        title: Text(ideaReporterConfig.titleKey.tr()),
        menu: false,
      ),
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
            return Center(child: Text(ideaReporterConfig.errorMessageKey.tr()));
          }

          return IdeaDetailContent(
            idea: Idea.fromExecution(execution),
            status: execution.status.localizedLabel,
            history: execution.historie,
            backendUrl: backendUrl,
          );
        },
      ),
    );
  }
}

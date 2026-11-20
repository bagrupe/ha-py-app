import 'package:app/components/heading/heading.dart';
import 'package:app/components/lists/empty_state.dart';
import 'package:app/components/lists/error_state.dart';
import 'package:app/components/lists/loading_state.dart';
import 'package:app/graphql/__generated__/idee.graphql.dart';
import 'package:app/routes/ideas/common/idea.dart';
import 'package:app/routes/karte/ideen/components/idee_liste_item.dart';
import 'package:app/routes/melder/common/report_workflow_configs.dart';
import 'package:app/routes/melder/components/report_create_button.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Page showing the current user's reported and followed ideas.
class MyIdeasPage extends ConsumerWidget {
  const MyIdeasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Query_MeineIdeen_Widget(
      builder: (result, {refetch, fetchMore}) {
        if (result.hasException) {
          return ListErrorState(
            message: ideaReporterConfig.errorMessageKey.tr(),
            onRetry: refetch,
          );
        }

        if (result.isLoading && result.parsedData == null) {
          return const ListLoadingState();
        }

        final data = result.parsedData?.my;
        if (data == null || data is! Query_MeineIdeen_my__Buerger) {
          return ListEmptyState(
            message: 'application.melder.user_data_error'.tr(),
          );
        }

        final ideen = data.ideen
            .map(Idea.fromIdeeSummary)
            .sortedBy((idea) => idea.title);
        final gefolgte = data.gefolgteIdeen
            .map(Idea.fromIdeeSummary)
            .sortedBy((idea) => idea.title);

        if (ideen.isEmpty && gefolgte.isEmpty) {
          return Stack(
            children: [
              ListEmptyState(message: ideaReporterConfig.emptyMessageKey.tr()),
              const Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: ReportCreateButton(config: ideaReporterConfig),
              ),
            ],
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async => refetch?.call(),
                child: CustomScrollView(
                  slivers: [
                    if (ideen.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Heading(
                          ideaReporterConfig.reportedTitleKey.tr(),
                          horizontalPadding: false,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => IdeeListeItem(idea: ideen[index]),
                          childCount: ideen.length,
                        ),
                      ),
                    ],
                    if (gefolgte.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Heading(
                          'application.melder.ideas.followed_title'.tr(),
                          horizontalPadding: false,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              IdeeListeItem(idea: gefolgte[index]),
                          childCount: gefolgte.length,
                        ),
                      ),
                    ],
                    const SliverToBoxAdapter(child: SizedBox(height: 80)),
                  ],
                ),
              ),
              const Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: ReportCreateButton(config: ideaReporterConfig),
              ),
            ],
          ),
        );
      },
    );
  }
}

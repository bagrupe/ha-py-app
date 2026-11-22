import 'package:app/common/app_config/app_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Displays active incidents with a direct entry to the reporting flow.
class LageBubbles extends ConsumerWidget {
  /// Creates the incident cards for the front page.
  const LageBubbles({super.key});

  /// Requests the public summaries for the configured municipality.
  static final _document = gql(r'''
    query FrontpageLagen($kommuneId: UUID!) {
      activeLagen(kommuneId: $kommuneId) { id title warningText }
    }
  ''');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kommuneId = ref.watch(appConfigProvider).kommuneId;
    return Query(
      options: QueryOptions(
        document: _document,
        variables: {'kommuneId': kommuneId},
        pollInterval: const Duration(minutes: 1),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
      builder: (result, {fetchMore, refetch}) {
        final lagen = (result.data?['activeLagen'] as List<Object?>? ?? [])
            .whereType<Map<String, dynamic>>();
        return Column(
          children: [
            for (final lage in lagen)
              Card(
                child: ListTile(
                  title: Text(lage['title'] as String),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (lage['warningText'] case final String warning)
                        Text(warning),
                      TextButton(
                        onPressed: () => context.push(
                          Uri(
                            path: '/lagehelfer',
                            queryParameters: {'lageId': lage['id'] as String},
                          ).toString(),
                        ),
                        child: Text(
                          'application.news.actions.report_incident'.tr(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

import 'package:app/common/extensions/go_router_state.dart';
import 'package:app/common/extensions/graphql_client.dart';
import 'package:app/common/keys.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/transition_page/transition_page_builders.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/antraege/antrag_senden.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:app/routes/antraege/common/antrag_schritte.dart';
import 'package:app/routes/ideas/idea_detail_page.dart';
import 'package:app/routes/karte/ideen/my_ideas_page.dart';
import 'package:app/routes/melder/common/report_workflow_configs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Defines the routes for the ideas reporting workflow.
final ideasRoute = GoRoute(
  path: 'ideahub',
  redirect: (_, state) =>
      state.defaultRedirect('/karte/ideahub/uebersicht/meine'),
  routes: [
    GoRoute(
      path: 'uebersicht/meine',
      pageBuilder: TransitionPageBuilders.noTransition(
        builder: (context, __) => Scaffold(
          appBar: CommonAppBar(
            title: Text(ideaReporterConfig.titleKey.tr()),
            logo: true,
          ),
          body: const MyIdeasPage(),
          resizeToAvoidBottomInset: false,
        ),
      ),
    ),
    GoRoute(
      path: 'schritt',
      pageBuilder: TransitionPageBuilders.noTransition(
        builder: (_, __) => AntragSchritte(
          statusOverrides: {
            AntragClientStatus.submitted: AntragSendenPage(
              backToListButton: Consumer(
                builder: (context, ref, child) {
                  return OutlinedButton(
                    key: K.backToList,
                    onPressed: () async {
                      ref.read(antragProgressProvider.notifier).endProzess();

                      context.go(ideaReporterConfig.overviewRoute);

                      final client = ref.read(graphqlClientProvider);
                      await client.refetchByName('MeineIdeen');
                      await client.refetchByName('Ausfuehrungen');
                    },
                    child: Text('application.melder.back_to_overview'.tr()),
                  );
                },
              ),
            ),
          },
        ),
      ),
    ),
  ],
);

/// Defines the public detail routes for reported ideas.
final ideaRoute = GoRoute(
  path: 'idea',
  redirect: (_, state) =>
      state.defaultRedirect('/karte/ideahub/uebersicht/meine'),
  routes: [
    GoRoute(
      path: 'detail/:id',
      pageBuilder: TransitionPageBuilders.noTransition(
        builder: (_, state) => IdeaDetailPage(id: state.pathParameters['id']!),
      ),
    ),
  ],
);

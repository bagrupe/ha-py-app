// ignore_for_file: cascade_invocations

import 'package:app/common/extensions/go_router_state.dart';
import 'package:app/common/extensions/graphql_client.dart';
import 'package:app/common/keys.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/transition_page/transition_page_builders.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/antraege/antrag_senden.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:app/routes/antraege/common/antrag_schritte.dart';
import 'package:app/routes/maengel/maengel_detail.dart';
import 'package:app/routes/maengel/maengel_meine.dart';
import 'package:app/routes/melder/common/report_workflow_configs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Definiert die Routen für den Bereich "Mängel" der App.
final maengelRoute = GoRoute(
  path: 'maengel',
  redirect: (_, state) =>
      state.defaultRedirect('/karte/maengel/uebersicht/meine'),
  routes: [
    /// Route zur Übersicht der eigenen Mängel.
    GoRoute(
      path: 'uebersicht/meine',
      pageBuilder: TransitionPageBuilders.noTransition(
        builder: (context, __) => Scaffold(
          appBar: CommonAppBar(
            title: Text(maengelMelderConfig.titleKey.tr()),
            logo: true,
          ),
          body: const MaengelMeinePage(),
          resizeToAvoidBottomInset: false,
        ),
      ),
    ),

    /// Route für den Schritt-für-Schritt-Prozess zur Meldung eines Mangels.
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
                      final notifier = ref.read(
                        antragProgressProvider.notifier,
                      );
                      notifier.endProzess();

                      context.go('/karte/maengel/uebersicht/meine');

                      final client = ref.read(graphqlClientProvider);
                      await client.refetchByName('Maengel');
                      await client.refetchByName('MeineMaengel');
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

    /// Route zur Detailansicht eines Mangels, identifiziert durch eine ID.
    GoRoute(
      path: 'detail/:id',
      pageBuilder: TransitionPageBuilders.noTransition(
        builder: (_, state) =>
            MaengelDetailPage(id: state.pathParameters['id']!),
      ),
    ),
  ],
);

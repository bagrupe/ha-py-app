// ignore_for_file: cascade_invocations, unawaited_futures

import 'package:app/common/volunteer_database/volunteer_database_enabled_notifier.dart';
import 'package:app/graphql/__generated__/termine.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:app/routes/termine/common/get_veranstaltungs_termine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Erzeugt die Deeplinks-Route mit Unterrouten für Antragsfortsetzung, Antragsdetail,
/// Terminweiterleitung, Ehrenamtsdatenbank und News.
/// Nutzt [ref] zum Zugriff auf Provider.
GoRoute deeplinksRoute(Ref ref) => GoRoute(
  path: '/deeplinks',
  redirect: (_, __) => null,
  routes: [
    _aktuellesDeeplinksRoute(),
    _antraegeDeeplinksRoute(),
    _ehrenamtsdatenbankDeeplinksRoute(ref),
    GoRoute(
      path: 'ausfuehrungContinue/:id',

      /// Leitet zur Fortsetzung eines Antrags mit der angegebenen ID weiter.
      redirect: (_, state) async {
        final id = state.pathParameters['id']!;
        final antragProgressNotifier = ref.read(
          antragProgressProvider.notifier,
        );

        final result = await antragProgressNotifier.continueAusfuehrung(id: id);

        if (result == null || result.ausfuehrungId != id) {
          return '/not_found/error';
        }

        return '/antraege/schritt';
      },
    ),
    GoRoute(
      path: 'termine/:id/:date',

      /// Baut das Widget zum Abrufen eines Veranstaltungstermins und zur Weiterleitung auf.
      builder: (_, state) => FetchVeranstaltungsTerminAndRedirect(
        id: state.pathParameters['id'] ?? '',
        date: state.pathParameters['date'] ?? '',
      ),
    ),
  ],
);

GoRoute _antraegeDeeplinksRoute() => GoRoute(
  path: 'antraege/detail',
  redirect: (_, __) => null,
  routes: [
    GoRoute(
      path: ':id',
      redirect: (_, state) => '/antraege/detail/${state.pathParameters['id']}',
    ),
  ],
);

GoRoute _aktuellesDeeplinksRoute() => GoRoute(
  path: 'aktuelles/news',
  redirect: (_, state) {
    if (RegExp(r'/deeplinks/aktuelles/news$').hasMatch(state.uri.path)) {
      return '/aktuelles/news';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: ':id',
      redirect: (_, state) => '/aktuelles/news/${state.pathParameters['id']}',
    ),
  ],
);

GoRoute _ehrenamtsdatenbankDeeplinksRoute(Ref ref) => GoRoute(
  path: 'ehrenamtsdatenbank',
  redirect: (_, __) {
    return volunteerDatabaseRedirectIfDisabled(ref) ?? '/ehrenamtsdatenbank';
  },
);

/// Widget, das einen Veranstaltungstermin anhand von ID und Datum abruft und anschließend weiterleitet.
class FetchVeranstaltungsTerminAndRedirect extends ConsumerWidget {
  /// Erzeugt eine Instanz mit der Veranstaltungs-ID und dem Datum.
  const FetchVeranstaltungsTerminAndRedirect({
    required this.id,
    required this.date,
    super.key,
  });

  final String id;
  final String date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final graphqlClient = ref.watch(graphqlClientProvider);
        final result = await graphqlClient.query_Veranstaltung(
          Options_Query_Veranstaltung(
            variables: Variables_Query_Veranstaltung(id: id),
          ),
        );

        final veranstaltungskalender =
            result.parsedData?.veranstaltungskalender;
        if (veranstaltungskalender != null) {
          final veranstaltungsTermine = getVeranstaltungstermine(
            veranstaltungskalender,
            showPastEvents: true,
          );
          final veranstaltungsTermin = veranstaltungsTermine.firstWhere(
            (veranstaltungsTermin) =>
                veranstaltungsTermin.start == DateTime.parse(date),
          );
          if (context.mounted) {
            context.go('/termine/$id', extra: veranstaltungsTermin);
          }
        } else {
          if (context.mounted) {
            context.go('/not_found/error');
          }
        }
      } catch (_) {
        if (context.mounted) {
          context.go('/not_found/error');
        }
      }
    });

    return const Center(child: CircularProgressIndicator());
  }
}

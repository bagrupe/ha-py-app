import 'package:app/common/auth/auth.dart';
import 'package:app/common/auth/personal_data.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/transition_page/transition_page_builders.dart';
import 'package:app/routes/antraege/common/antrag_schritte.dart';
import 'package:app/routes/profil/inhalte_und_benachrichtigungen/inhalte_und_benachrichtigungen.dart';
import 'package:app/routes/profil/interests/volunteer_interests_page.dart';
import 'package:app/routes/profil/mitteilungen/mitteilungen_detail.dart';
import 'package:app/routes/profil/mitteilungen/mitteilungen_overview.dart';
import 'package:app/routes/profil/mitteilungen/mitteilungen_settings.dart';
import 'package:app/routes/profil/my_account/my_account.dart';
import 'package:app/routes/profil/open_source/open_source_page.dart';
import 'package:app/routes/profil/profil_detail.dart';
import 'package:app/routes/profil/profil_personal_data.dart';
import 'package:app/routes/profil/sensoren_favoriten/profil_sensoren_favoriten_liste.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Hauptseite des Profils, die basierend auf dem Status der persönlichen Daten unterschiedliche Inhalte anzeigt.
class ProfilPage extends ConsumerWidget {
  const ProfilPage({super.key});

  /// Baut das Profil-Widget und entscheidet, ob die persönlichen Daten geladen, leer oder vorhanden sind.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalData = ref.watch(personalDataProvider);

    final hasStrongSession = switch (ref.watch(hasStrongSessionProvider)) {
      AsyncData(:final value) => value,
      _ => false,
    };

    final keyUnavailable = ref.watch(authProvider).isKeyUnavailable;

    if (hasStrongSession || keyUnavailable) {
      return const ProfilDetailPage();
    }

    final firstSetupAlreadyCompletedOnDevice =
        ref
            .watch(sharedPreferencesProvider)
            .getBool(profilFirstSetupCompletedKey) ??
        false;

    final buergerId = switch (ref.watch(asyncAuthProvider)) {
      AsyncData(:final value) => value.buergerId,
      _ => null,
    };

    return switch (personalData) {
      null => Scaffold(
        appBar: CommonAppBar(
          title: Text('application.profil.title'.tr()),
          logo: true,
        ),
        body: Center(child: Text('application.profil.loading'.tr())),
      ),
      Map(:final isEmpty) when isEmpty && !firstSetupAlreadyCompletedOnDevice =>
        ProfilPersonalDataPage(key: ValueKey(buergerId), firstSetup: true),
      _ => const ProfilDetailPage(),
    };
  }
}

/// Definition der Routen für den Profilbereich mit zugehörigen Seiten und Übergängen.
final profilRoute = GoRoute(
  path: '/profil',
  pageBuilder: TransitionPageBuilders.noTransition(
    builder: (_, __) => const ProfilPage(),
  ),
  routes: [
    GoRoute(
      path: 'open-source',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, __) => const OpenSourcePage(),
      ),
    ),
    GoRoute(
      path: 'personal-data',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, __) => const ProfilPersonalDataPage(),
      ),
    ),
    GoRoute(
      path: 'details',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, __) => const ProfilDetailPage(),
      ),
    ),
    GoRoute(
      path: 'feedback',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, __) => const AntragSchritte(),
      ),
    ),
    GoRoute(
      path: 'sensoren',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, __) => const ProfilSensorenFavoritenListe(),
      ),
    ),
    GoRoute(
      path: 'volunteer-interests',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, __) => const VolunteerInterestsPage(),
      ),
    ),
    GoRoute(
      path: 'notifications',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, __) => const MitteilungenOverviewPage(),
      ),
      routes: [
        GoRoute(
          path: 'settings',
          pageBuilder: TransitionPageBuilders.sliding(
            builder: (_, __) => const Mitteilungseinstellungen(),
          ),
        ),
        GoRoute(
          path: ':ausfuehrungId/:verbindungId',
          pageBuilder: TransitionPageBuilders.sliding(
            builder: (_, state) => MitteilungDetailPage(
              ausfuehrungId: state.pathParameters['ausfuehrungId']!,
              verbindungId: state.pathParameters['verbindungId']!,
            ),
          ),
        ),
      ],
    ),
    GoRoute(
      path: 'inhalte_und_benachrichtigungen',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, stage) => const InhalteUndBenachrichtigungenPage(),
      ),
    ),
    GoRoute(
      path: 'mein-konto',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, __) => const MyAccountPage(),
      ),
    ),
  ],
);

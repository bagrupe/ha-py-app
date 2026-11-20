import 'package:app/common/auth/auth.dart';
import 'package:app/common/auth/mitteilungen_provider.dart';
import 'package:app/common/auth/personal_data.dart';
import 'package:app/common/theme.dart';
import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/heading/heading.dart';
import 'package:app/routes/antraege/common/antrag_meta.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:app/routes/profil/components/app_version_footer.dart';
import 'package:app/routes/profil/interests/volunteer_interests_page.dart';
import 'package:app/routes/profil/interests/volunteer_interests_provider.dart';
import 'package:app/routes/profil/mitteilungen/mitteilungen_auto_refresh.dart';
import 'package:app/routes/profil/my_account/my_account_provider.dart';
import 'package:app/routes/profil/profil_detail_item.dart';
import 'package:app/routes/volunteer_database/widgets/logged_out_modal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

final items = [
  ProfilDetailItem(
    onTap: (context, ref) => context.push('/profil/personal-data'),
    icon: const Icon(Icons.account_circle_outlined),
    label: 'application.profil.menu.personal_data',
  ),
  ProfilDetailItem(
    onTap: (context, ref) => context.push('/profil/mein-konto'),
    icon: const Icon(Icons.badge_outlined),
    label: 'application.profil.my_account.title'.tr(),
  ),
  ProfilDetailItem(
    onTap: (context, ref) {
      if (ref.read(volunteerAuthProvider) == null) {
        showLoggedOutModal(context);
        return;
      }
      context.push(VolunteerInterestsPage.path);
    },
    icon: const Icon(Icons.mark_email_unread_outlined),
    label: 'application.profile.volunteer_interests.menu',
    count: (ref) => ref
        .watch(volunteerInterestsProvider)
        .value
        ?.where((interest) => interest.isOpen)
        .length,
  ),
  ProfilDetailItem(
    onTap: (context, ref) {
      ref.read(mitteilungenCountNotifierProvider.notifier).setLastRead();
      context.push('/profil/notifications');
    },
    icon: const Icon(Icons.email_outlined),
    label: 'application.profil.mitteilungen.title',
    count: (ref) {
      final mitteilungenCount = ref.watch(mitteilungenCountNotifierProvider);

      return mitteilungenCount;
    },
  ),
  ProfilDetailItem(
    onTap: (context, ref) {
      ref
          .read(antragProgressProvider.notifier)
          .launchSpecialProzess(
            tag: 'Feedback',
            route: '/profil/feedback',
            meta: AntragMeta(
              'application.profil.menu.feedback'.tr(),
              'application.profil.menu.feedback_sent'.tr(),
              'application.profil.menu.feedback_submit'.tr(),
              '/profil',
            ),
            context: context,
          );
    },
    icon: const Icon(Icons.forum_outlined),
    label: 'application.profil.menu.feedback',
  ),
  ProfilDetailItem(
    icon: const Icon(Symbols.bookmark_star),
    label: 'application.profil.menu.sensors',
    onTap: (context, ref) {
      context.go('/profil/sensoren');
    },
  ),
  ProfilDetailItem(
    onTap: (context, ref) =>
        context.push('/profil/inhalte_und_benachrichtigungen'),
    icon: Image.asset('assets/images/mobile_hand.png', width: 24, height: 24),
    label: 'application.profil.menu.content_notifications',
  ),
  ProfilDetailItem(
    icon: const Icon(Icons.verified_user_outlined),
    label: 'application.profil.menu.privacy',
    onTap: (context, ref) => context.push('/datenschutz'),
  ),
  ProfilDetailItem(
    icon: const Icon(Icons.verified_user_outlined),
    label: 'application.profil.menu.imprint',
    onTap: (context, ref) => context.push('/impressum'),
  ),
  ProfilDetailItem(
    icon: const Icon(Icons.code_outlined),
    label: 'application.open_source.title',
    onTap: (context, ref) => context.push('/profil/open-source'),
  ),
];

/// Widget zur Darstellung der Profil-Detail-Seite mit einer Liste von Profil-Optionen und persönlicher Begrüßung.
class ProfilDetailPage extends ConsumerWidget {
  /// Erstellt eine Instanz der ProfilDetailPage.
  const ProfilDetailPage({super.key});

  String _welcomeText(
    Map<String, dynamic> personalData,
    MyAccountProfile? account,
  ) {
    String? firstNonEmpty(Object? accountValue, Object? personalValue) => [
      accountValue,
      personalValue,
    ].whereType<String>().where((v) => v.trim().isNotEmpty).firstOrNull;

    final name = [
      firstNonEmpty(account?.vorname, personalData[PersonalDataKeys.vorname]),
      firstNonEmpty(account?.nachname, personalData[PersonalDataKeys.nachname]),
    ].nonNulls.join(' ');
    return name.isEmpty
        ? 'application.profil.welcome_anonymous'.tr()
        : 'application.profil.welcome'.tr(namedArgs: {'name': name});
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalData = ref.watch(personalDataProvider) ?? {};
    final account = ref.watch(myAccountProfileProvider).value;
    final isKeyUnavailable = ref.watch(authProvider).isKeyUnavailable;
    final isSessionExpired = ref.watch(strongSessionExpiredProvider);
    final theme = ref.watch(themeProvider);

    return MitteilungenAutoRefresh(
      child: Scaffold(
        appBar: CommonAppBar(
          title: Text('application.profil.title'.tr()),
          logo: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isSessionExpired)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Text(
                    'application.profil.my_account.session_expired'.tr(),
                  ),
                ),
              if (isKeyUnavailable)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('application.profil.key_unavailable'.tr()),
                )
              else
                Heading(_welcomeText(personalData, account)),
              ...items
                  .map((i) {
                    final badgeCount = i.count?.call(ref) ?? 0;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 36,
                      ),
                      onTap: i.onTap != null
                          ? () => i.onTap!.call(context, ref)
                          : null,
                      title: IconTheme(
                        data: IconThemeData(color: theme.primaryColor),
                        child: Row(
                          children: [
                            i.icon,
                            const SizedBox(width: 12),
                            Text(i.label.tr()),
                            if (badgeCount > 0) ...[
                              const SizedBox(width: 12),
                              Badge.count(count: badgeCount),
                            ],
                          ],
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                    );
                  })
                  .expand((tile) => [const Divider(), tile]),
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Align(child: AppVersionFooter()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

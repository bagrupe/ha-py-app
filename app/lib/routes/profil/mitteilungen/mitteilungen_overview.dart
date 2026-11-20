import 'package:app/common/auth/mitteilungen_provider.dart';
import 'package:app/common/extensions/graphql_client.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/heading/heading.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/profil/mitteilungen/mitteilungen_auto_refresh.dart';
import 'package:app/routes/profil/mitteilungen/notification_detail.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Seite zur Übersicht aller Mitteilungen im Profilbereich.
/// Zeigt eine Liste der Mitteilungen sortiert nach Erstellungsdatum an und ermöglicht den Zugriff auf die Einstellungen.
class MitteilungenOverviewPage extends ConsumerWidget {
  const MitteilungenOverviewPage({super.key});

  /// Baut das Widget und zeigt die Mitteilungen an.
  /// Nutzt [WidgetRef], um den aktuellen Zustand der Mitteilungen zu beobachten.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(mitteilungenDataProvider, (_, next) {
      if (next != null && TickerMode.valuesOf(context).enabled) {
        ref.read(mitteilungenCountNotifierProvider.notifier).setLastRead();
      }
    });

    final mitteilungenData = ref.watch(mitteilungenDataProvider);

    if (mitteilungenData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final sortedMitteilungen = mitteilungenData
      ..sort((a, b) => b.historie.createdAt.compareTo(a.historie.createdAt));

    return MitteilungenAutoRefresh(
      child: Scaffold(
        appBar: CommonAppBar(title: Text('application.profil.title'.tr())),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Heading('application.profil.mitteilungen.title'.tr()),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RefreshIndicator(
                  onRefresh: () async {
                    final client = ref.read(graphqlClientProvider);
                    await client.refetchByName('MyMitteilungen');
                  },
                  child: mitteilungenData.isNotEmpty
                      ? ListView.separated(
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: mitteilungenData.length,
                          itemBuilder: (context, index) => NotificationDetail(
                            notification: sortedMitteilungen[index],
                            overview: true,
                          ),
                        )
                      : Text('application.profil.mitteilungen.empty'.tr()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

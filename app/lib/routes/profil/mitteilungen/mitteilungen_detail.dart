// ignore_for_file: pattern_never_matches_value_type

import 'package:app/common/auth/mitteilungen_provider.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/lists/empty_state.dart';
import 'package:app/routes/profil/mitteilungen/notification_detail.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Seite zur Anzeige der Detailansicht einer einzelnen Mitteilung.
/// Zeigt die Details einer spezifischen Mitteilung basierend auf den übergebenen IDs an.
class MitteilungDetailPage extends ConsumerWidget {
  /// Erstellt eine neue Instanz der Detailseite für eine Mitteilung.
  /// Erfordert die Ausführungs-ID und die Verbindungs-ID zur Identifikation der Mitteilung.
  const MitteilungDetailPage({
    required this.ausfuehrungId,
    required this.verbindungId,
    super.key,
  });

  /// ID der Ausführung der Mitteilung.
  final String ausfuehrungId;

  /// ID der Verbindung (Historie) der Mitteilung.
  final String verbindungId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mitteilungenData = ref.watch(mitteilungenDataProvider);

    if (mitteilungenData != null) {
      final notification = mitteilungenData.firstWhereOrNull(
        (notification) =>
            notification.historie.id == verbindungId &&
            notification.id == ausfuehrungId,
      );

      return Scaffold(
        appBar: CommonAppBar(
          title: Text('application.profil.mitteilungen.title'.tr()),
        ),
        body: notification == null
            ? ListEmptyState(
                message: 'application.profil.mitteilungen.not_found'.tr(),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: NotificationDetail(notification: notification),
              ),
      );
    }

    return switch (mitteilungenData) {
      AsyncError() => const Center(
        child: Text(
          'Es ist ein Fehler aufgetreten. Versuchen Sie es später erneut.',
        ),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

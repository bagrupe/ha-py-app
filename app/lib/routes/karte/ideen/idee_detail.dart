import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/auth/auth.dart';
import 'package:app/common/extensions/graphql_client.dart';
import 'package:app/common/notifications/firebase_push.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/lists/empty_state.dart';
import 'package:app/components/lists/error_state.dart';
import 'package:app/graphql/__generated__/idee.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/ideas/common/idea.dart';
import 'package:app/routes/ideas/components/idea_detail_content.dart';
import 'package:app/routes/melder/common/report_execution_status_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Seite zur Anzeige der Detailinformationen einer Idee.
///
/// Nutzt die Kommune-scoped `Query_Idee` (statt der generischen,
/// besitzerbeschränkten `ausfuehrung`-Query aus `idea_detail_page.dart`),
/// da Ideen öffentlich auf der Karte sichtbar und von jedem Bürger der
/// Kommune follow-bar sein müssen, nicht nur vom Ersteller.
class IdeeDetailPage extends ConsumerWidget {
  /// Erstellt eine neue Instanz der Detailseite mit der angegebenen Idee-ID.
  const IdeeDetailPage({required this.id, super.key});

  /// Die ID der anzuzeigenden Idee.
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CommonAppBar(
        title: Text('application.melder.ideas.title'.tr()),
        menu: false,
      ),
      body: _IdeeDetail(id: id),
    );
  }
}

/// Widget zur Darstellung der Detailansicht einer Idee mit Follow-Funktion.
class _IdeeDetail extends ConsumerStatefulWidget {
  /// Erstellt eine neue Instanz mit der angegebenen Idee-ID.
  const _IdeeDetail({required this.id});

  /// Die ID der anzuzeigenden Idee.
  final String id;

  @override
  ConsumerState<_IdeeDetail> createState() => _IdeeDetailState();
}

class _IdeeDetailState extends ConsumerState<_IdeeDetail> {
  var _isToggling = false;

  String get _id => widget.id;

  void _showMessage(String key) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(key.tr())));
  }

  Future<void> _updateTopic({required bool subscribe}) async {
    if (!isFirebasePushAvailable) return;

    try {
      if (subscribe) {
        await FirebaseMessaging.instance.subscribeToTopic('idee-$_id');
      } else {
        await FirebaseMessaging.instance.unsubscribeFromTopic('idee-$_id');
      }
    } catch (e) {
      if (!kDebugMode) {
        await Sentry.captureException(e);
        _showMessage('application.melder.follow_error');
      }
    }
  }

  /// Schaltet das Folgen der Idee um und aktualisiert die Firebase Messaging Topics.
  Future<void> _toggleFolgen({required bool newFolgen}) async {
    final client = ref.read(graphqlClientProvider);

    final result = await client.mutate_IdeeFolgen(
      Options_Mutation_IdeeFolgen(
        variables: Variables_Mutation_IdeeFolgen(
          input: Input_AusfuehrungFolgenInput(
            ausfuehrungId: _id,
            newFolgen: newFolgen,
          ),
        ),
      ),
    );

    if (result.hasException) {
      final isGone = result.exception?.graphqlErrors.isNotEmpty ?? false;
      if (isGone && !newFolgen) await _updateTopic(subscribe: false);
      _showMessage(
        isGone
            ? 'application.melder.ideas.follow_gone'
            : 'application.melder.ideas.follow_failed',
      );
      return;
    }

    await _updateTopic(subscribe: newFolgen);
    await client.refetchByName('MyMitteilungen');
    await client.refetchByName('MeineIdeen');
  }

  Future<void> _onFolgenPressed({
    required bool newFolgen,
    required Future<void> Function()? refetch,
  }) async {
    setState(() => _isToggling = true);
    try {
      await _toggleFolgen(newFolgen: newFolgen);
    } finally {
      if (mounted) setState(() => _isToggling = false);
    }
    await refetch?.call();
  }

  @override
  Widget build(BuildContext context) {
    final kommuneId = ref.watch(appConfigProvider).kommuneId;
    final conf = ref.watch(appConfigProvider);
    final options = Options_Query_Idee(
      pollInterval: const Duration(seconds: 15),
      variables: Variables_Query_Idee(kommuneId: kommuneId, ideeId: _id),
    );

    final buergerId = ref.watch(authProvider).buergerId;

    return Query_Idee_Widget(
      options: options,
      builder: (result, {fetchMore, refetch}) {
        final ideeAusfuehrung = result.parsedData?.kommune.ideeAusfuehrung;

        if (ideeAusfuehrung == null && result.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (result.hasException) {
          return ListErrorState(
            message: 'application.melder.ideas.error'.tr(),
            onRetry: refetch,
          );
        }

        if (ideeAusfuehrung == null) {
          return ListEmptyState(
            message: 'application.melder.ideas.not_found'.tr(),
          );
        }

        final istGefolgt = ideeAusfuehrung.aktuellerNutzerFolgt;
        final isEigeneIdee =
            buergerId != null && ideeAusfuehrung.userId == buergerId;

        return IdeaDetailContent(
          idea: Idea.fromIdeeSummary(ideeAusfuehrung),
          status: ideeAusfuehrung.status.localizedLabel,
          history: ideeAusfuehrung.historie,
          backendUrl: conf.backendUrl,
          isFollowing: istGefolgt,
          followEnabled: !_isToggling,
          onToggleFollow: isEigeneIdee
              ? null
              : () =>
                    _onFolgenPressed(newFolgen: !istGefolgt, refetch: refetch),
        );
      },
    );
  }
}

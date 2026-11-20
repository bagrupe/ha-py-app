import 'package:app/common/design_tokens.dart';
import 'package:app/common/gemeinde_prefs.dart';
import 'package:app/common/kommune.dart';
import 'package:app/common/notifications/firebase_push.dart';
import 'package:app/graphql/__generated__/gemeindeinformationen.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/profil/mitteilungen/components/__generated__/news.graphql.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql/client.dart';

/// Seite zur Auswahl der Gemeinden, und der Konfiguration von Push-
/// Benachrichtigungen für News und Abfalltermine.
class NewsUndVeranstaltungenPage extends ConsumerWidget {
  const NewsUndVeranstaltungenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kommune = ref.watch(kommuneProvider).value;
    if (kommune == null) return const SizedBox.shrink();

    return Query_Gemeindeinformationen_Widget(
      options: Options_Query_Gemeindeinformationen(
        variables: Variables_Query_Gemeindeinformationen(
          kommuneId: kommune.bereichAId,
        ),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) return const CircularProgressIndicator();

        final gemeindeList = result.parsedData?.kommune.untereinheiten;

        if (gemeindeList == null) {
          return const SizedBox.shrink();
        } else {
          return Column(
            children: gemeindeList
                .expand(
                  (g) => [
                    _Gemeinde(
                      id: g.id,
                      name: g.name,
                      newsBenachrichtigungenAktiviert:
                          g.newsNotificationsEnabled,
                    ),
                    const SizedBox(height: 6),
                  ],
                )
                .toList(),
          );
        }
      },
    );
  }
}

class _Gemeinde extends ConsumerStatefulWidget {
  const _Gemeinde({
    required this.id,
    required this.name,
    required this.newsBenachrichtigungenAktiviert,
  });

  final String id;
  final String name;
  final bool newsBenachrichtigungenAktiviert;

  @override
  ConsumerState<_Gemeinde> createState() => _GemeindeState();
}

class _GemeindeState extends ConsumerState<_Gemeinde> {
  bool newsBenachrichtigungenAktiviert = false;

  @override
  void initState() {
    super.initState();
    newsBenachrichtigungenAktiviert = widget.newsBenachrichtigungenAktiviert;
  }

  @override
  Widget build(BuildContext context) {
    final gemeindeAktiviert = ref
        .watch(gemeindeFilterProvider)
        .currentGemeindePrefs
        .contains(widget.id);
    final theme = Theme.of(context);

    return ColoredBox(
      color: DesignTokens.gray100,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(widget.name, style: const TextStyle(fontSize: 16)),
              ),
              Switch(
                activeThumbColor: theme.primaryColor,
                value: gemeindeAktiviert,
                onChanged: (value) => _updateEinstellungen(value, false),
              ),
            ],
          ),
          if (gemeindeAktiviert && isFirebasePushAvailable)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    'News-Benachrichtigungen \naktivieren',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Switch(
                  activeThumbColor: theme.primaryColor,
                  value: newsBenachrichtigungenAktiviert,
                  onChanged: (value) => _updateEinstellungen(true, value),
                ),
              ],
            ),
        ],
      ),
    );
  }

  bool get gemeindeAktiviert {
    return ref
        .watch(gemeindeFilterProvider)
        .currentGemeindePrefs
        .contains(widget.id);
  }

  Future<void> _updateEinstellungen(
    bool gemeindeAktiviert,
    bool newsBenachrichtigungenAktiviert,
  ) async {
    final gemeindeFilter = ref
        .read(gemeindeFilterProvider)
        .currentGemeindePrefs;

    final nextGemeindeFilter = [...gemeindeFilter];

    if (gemeindeAktiviert && !nextGemeindeFilter.contains(widget.id)) {
      nextGemeindeFilter.add(widget.id);
    } else if (!gemeindeAktiviert) {
      nextGemeindeFilter.remove(widget.id);
    }

    final prevNewsBenachrichtigungenAktiviert =
        this.newsBenachrichtigungenAktiviert;

    if (isFirebasePushAvailable &&
        prevNewsBenachrichtigungenAktiviert !=
            newsBenachrichtigungenAktiviert) {
      final graphQlClient = ref.read(graphqlClientProvider);

      await graphQlClient
          .mutate_UpdateNewsNotificationsPreferences(
            Options_Mutation_UpdateNewsNotificationsPreferences(
              variables: Variables_Mutation_UpdateNewsNotificationsPreferences(
                input: Input_UpdateNewsNotificationsPreferencesInput(
                  organisationseinheitId: widget.id,
                  notificationsEnabled: newsBenachrichtigungenAktiviert,
                ),
              ),
            ),
          )
          .then((result) {
            if (result.hasException) {
              setState(() {
                this.newsBenachrichtigungenAktiviert =
                    prevNewsBenachrichtigungenAktiviert;
              });
            }
          });
    }

    setState(() {
      this.newsBenachrichtigungenAktiviert = newsBenachrichtigungenAktiviert;
    });

    ref
        .read(gemeindeFilterProvider.notifier)
        .updateGemeindeFilter(nextGemeindeFilter);
  }
}

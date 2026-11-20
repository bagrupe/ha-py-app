import 'package:app/common/gemeinde_prefs.dart';
import 'package:app/common/kommune.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/profil/mitteilungen/components/__generated__/news.graphql.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget zur Anzeige der News-Benachrichtigungen im Profilbereich.
class NewsBenachrichtungen extends ConsumerStatefulWidget {
  const NewsBenachrichtungen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewsBenachrichtigungen();
}

/// State-Klasse für das [NewsBenachrichtungen]-Widget, die die Darstellung steuert.
class _NewsBenachrichtigungen extends ConsumerState<NewsBenachrichtungen> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            'Wählen Sie für welche Gemeinden Sie Benachrichtigungen über News erhalten möchten.',
          ),
        ),
        Switches(),
      ],
    );
  }
}

/// Widget zur Darstellung der Schalter für die News-Benachrichtigungspräferenzen.
class Switches extends ConsumerStatefulWidget {
  const Switches({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Switches();
}

/// State-Klasse für das [Switches]-Widget, verwaltet den Zustand der Benachrichtigungspräferenzen.
class _Switches extends ConsumerState<Switches> {
  Map<String, bool> newsPreferencesState = {};
  Set<String> pending = {};

  /// Aktualisiert die Benachrichtigungspräferenz für eine Organisationseinheit.
  /// [organisationseinheitId] ist die ID der Gemeinde, [notificationsEnabled] gibt an, ob Benachrichtigungen aktiviert sind.
  Future<void> updatePreferences(
    String organisationseinheitId,
    bool notificationsEnabled,
  ) async {
    setState(() {
      pending.add(organisationseinheitId);
    });
    final graphQlClient = ref.read(graphqlClientProvider);
    try {
      final result = await graphQlClient
          .mutate_UpdateNewsNotificationsPreferences(
            Options_Mutation_UpdateNewsNotificationsPreferences(
              variables: Variables_Mutation_UpdateNewsNotificationsPreferences(
                input: Input_UpdateNewsNotificationsPreferencesInput(
                  organisationseinheitId: organisationseinheitId,
                  notificationsEnabled: notificationsEnabled,
                ),
              ),
            ),
          );

      if (result.parsedData?.updateNewsNotificationsPreferences.boolean ??
          false) {
        setState(() {
          newsPreferencesState[organisationseinheitId] = notificationsEnabled;
          pending.remove(organisationseinheitId);
        });
      }
    } catch (e) {
      setState(() {
        pending.remove(organisationseinheitId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final kommune = ref.watch(kommuneProvider).value;
    final gemeindeFilterState = ref.watch(gemeindeFilterProvider);
    final theme = Theme.of(context);

    if (kommune == null) return const SizedBox.shrink();

    return Query_GemeindeNewsPreferences_Widget(
      options: Options_Query_GemeindeNewsPreferences(
        variables: Variables_Query_GemeindeNewsPreferences(
          kommuneId: kommune.bereichAId,
        ),
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) {
          return const CircularProgressIndicator();
        }

        final organisationseinheitenList =
            result.parsedData?.kommune.organisationseinheiten.where(
              (untereinheit) => gemeindeFilterState.currentGemeindePrefs
                  .contains(untereinheit.id),
            ) ??
            [];

        return Column(
          children: organisationseinheitenList
              .map(
                (gemeinde) => Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          gemeinde.name,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ),
                    Switch(
                      value:
                          newsPreferencesState[gemeinde.id] ??
                          gemeinde.newsNotificationsEnabled,
                      onChanged: pending.contains(gemeinde.id)
                          ? null
                          : (value) {
                              updatePreferences(gemeinde.id, value);
                            },
                      activeThumbColor: theme.primaryColor,
                    ),
                  ],
                ),
              )
              .toList(),
        );
      },
    );
  }
}

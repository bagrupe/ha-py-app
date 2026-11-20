import 'package:app/graphql/__generated__/maengel.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql/client.dart';

/// Typalias für eine Liste von Mangel-Ausführungen.
typedef Ausfuehrungen = List<Fragment_MangelAusfuehrung>;

/// Funktionstyp, der eine Widget-Liste aus Mangel-Ausführungen erzeugt.
typedef AusfuehrungListBuilderFunction = Widget Function(Ausfuehrungen);

/// Funktionstyp, der einen Stream von Mangel-Ausführungs-Listen aus einem GraphQL-Client liefert.
typedef AusfuehrungListGenerator =
    Stream<Ausfuehrungen?> Function(GraphQLClient);

/// Widget, das eine Liste von Mangel-Ausführungen über einen Stream lädt und mit einem Builder darstellt.
class AusfuehrungListBuilder extends ConsumerWidget {
  /// Erzeugt ein neues AusfuehrungListBuilder-Widget mit Generator und Builder.
  const AusfuehrungListBuilder({
    required this.generator,
    required this.builder,
    super.key,
  });

  /// Funktion, die den Stream der Mangel-Ausführungen erzeugt.
  final AusfuehrungListGenerator generator;

  /// Funktion, die aus den geladenen Mangel-Ausführungen ein Widget erstellt.
  final AusfuehrungListBuilderFunction builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(graphqlClientProvider);
    final stream = generator(client);

    return StreamBuilder<Ausfuehrungen?>(
      stream: stream,
      builder: (context, snapshot) {
        final ausfuehrungen = snapshot.data ?? [];

        return builder(ausfuehrungen);
      },
    );
  }
}

// ignore_for_file: inference_failure_on_function_invocation

import 'package:gql/ast.dart';
import 'package:graphql/client.dart';

/// Erweiterung für GraphQLClient zur erneuten Abfrage von Queries anhand ihres Namens.
extension RefetchQueryByNameExtension on GraphQLClient {
  /// Führt eine erneute Abfrage aller Queries mit dem angegebenen Operationsnamen durch.
  ///
  /// [operationName] ist der Name der Operation, die neu abgefragt werden soll.
  Future<void> refetchByName(String operationName) async {
    final toRefetch = queryManager.queries.values.where(
      (query) => query.options.document.definitions.any(
        (d) => d is OperationDefinitionNode && d.name?.value == operationName,
      ),
    );

    final refetches = toRefetch.map(
      (q) => queryManager.refetchQuery(q.queryId),
    );

    await Future.wait(refetches);
  }
}

/// Erweiterung für Request zur Identifikation von Authentifizierungsoperationen, die ignoriert werden sollen.
extension RequestExtension on Request {
  /// Prüft, ob die Operation eine schwache Login- oder Registrierungsoperation ist, die keine Authentifizierung benötigt.
  bool get isIgnoreAuthOperation {
    return operation.document.definitions.every(
      (d) =>
          d is OperationDefinitionNode &&
          (d.name?.value == 'WeakLogin' || d.name?.value == 'WeakRegister'),
    );
  }
}

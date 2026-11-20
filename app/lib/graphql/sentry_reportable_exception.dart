import 'package:gql/ast.dart';
import 'package:graphql/client.dart';

const _operationsWithSecrets = {
  'KeyEscrow',
  'StoreKeyEscrow',
  'ValidateSmsCode',
};

Object sentryReportableException(Request request, LinkException exception) {
  final operationName =
      request.operation.operationName ??
      request.operation.document.definitions
          .whereType<OperationDefinitionNode>()
          .firstOrNull
          ?.name
          ?.value;
  if (!_operationsWithSecrets.contains(operationName)) return exception;

  return StateError('${exception.runtimeType} in $operationName');
}

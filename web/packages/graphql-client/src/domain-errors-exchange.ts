import {type Exchange} from 'urql';
import {pipe, map} from 'wonka';

export interface CreateDomainErrorsExchangeOptions {
  onError: (message: string) => void;
}

export const createDomainErrorsExchange =
  ({onError}: CreateDomainErrorsExchangeOptions): Exchange =>
  ({forward}) =>
  (ops$) =>
    pipe(
      forward(ops$),
      map((operationResult) => {
        if (operationResult.operation.kind === 'mutation') {
          for (const value of Object.values(operationResult.data ?? {})) {
            if (
              value &&
              typeof value === 'object' &&
              'errors' in value &&
              Array.isArray(value.errors) &&
              value.errors.length > 0
            ) {
              onError(
                (value.errors[0] as {message?: string}).message ??
                  'Ein unbekannter Fehler ist aufgetreten',
              );
              break;
            }
          }
        }
        return operationResult;
      }),
    );

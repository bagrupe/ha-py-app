import {type CombinedError, type Operation} from 'urql';

/**
 * Checks whether a mutation failed before a usable GraphQL payload was returned.
 * Domain-specific payload errors must still be checked by the caller.
 */
export const mutationFailed = (result: {
  data?: unknown;
  error?: CombinedError;
}): boolean => Boolean(result.error) || result.data == null;

/** Returns whether a top-level urql error needs the generic mutation toast. */
export const shouldToastMutationError = (
  error: Pick<CombinedError, 'graphQLErrors'>,
  operation: Pick<Operation, 'kind'>,
): boolean =>
  operation.kind === 'mutation' &&
  !error.graphQLErrors.some(({message}) => message === 'Unauthenticated');

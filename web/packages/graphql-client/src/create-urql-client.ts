import {
  cacheExchange,
  type Client,
  createClient,
  errorExchange,
  type Exchange,
  fetchExchange,
} from 'urql';
import customScalarsExchange from 'urql-custom-scalars-exchange';
import {createAuthExchange} from './auth-exchange.ts';
import {buildScalarsConfig} from './scalars.ts';

export interface IntrospectionLike {
  readonly __schema: unknown;
}

export interface CreateUrqlClientOptions {
  url: string;
  introspection: IntrospectionLike;
  getToken?: () => string | undefined;
  onUnauthenticated?: () => void;
  cache?: boolean;
  extraExchanges?: Exchange[];
}

export const createUrqlClient = ({
  url,
  introspection,
  getToken,
  onUnauthenticated,
  cache,
  extraExchanges = [],
}: CreateUrqlClientOptions): Client =>
  createClient({
    url,
    requestPolicy: cache ? 'cache-first' : 'network-only',
    fetchOptions: {headers: {Accept: '*/*'}},
    exchanges: [
      customScalarsExchange({
        schema: introspection as never,
        scalars: buildScalarsConfig(),
      }),
      createAuthExchange({getToken}),
      ...(cache ? [cacheExchange] : []),
      ...(onUnauthenticated
        ? [
            errorExchange({
              onError(error) {
                if (
                  error?.graphQLErrors.some(
                    (e) => e.message === 'Unauthenticated',
                  )
                ) {
                  onUnauthenticated();
                }
              },
            }),
          ]
        : []),
      ...extraExchanges,
      fetchExchange,
    ],
  });

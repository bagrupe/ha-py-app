import {
  createDomainErrorsExchange,
  createUrqlClient as baseCreateUrqlClient,
} from '@kommunalapp/graphql-client';
import {type FC, type PropsWithChildren, useMemo} from 'react';
import {type NavigateFunction} from 'react-router';
import {toast} from 'react-toastify';
import {errorExchange, Provider} from 'urql';
import introspectionSchema from './__generated__/introspection';
import {useAuth} from './lib/context/auth/auth.tsx';
import {shouldToastMutationError} from './lib/mutation.ts';

/**
 * Erstellt einen URQL-Client mit optionaler Authentifizierung, Cache und Navigation.
 * @param param0 Objekt mit optionalem Token, Cache-Flag und Navigationsfunktion.
 * @returns Konfigurierter URQL-Client.
 */
export const createUrqlClient = ({
  token,
  cache,
  navigate,
  invalidateSession,
}: {
  token?: string;
  cache?: boolean;
  navigate?: NavigateFunction;
  invalidateSession?: () => void;
} = {}) =>
  baseCreateUrqlClient({
    url: '/graphql',
    introspection: introspectionSchema,
    getToken: () => token,
    cache,
    onUnauthenticated: navigate
      ? () => {
          invalidateSession?.();
          navigate('/auth/login');
        }
      : undefined,
    extraExchanges: [
      errorExchange({
        onError(error, operation) {
          if (shouldToastMutationError(error, operation)) {
            toast.error(
              'Die Aktion ist fehlgeschlagen. Bitte versuchen Sie es erneut.',
            );
          }
        },
      }),
      createDomainErrorsExchange({onError: (msg) => toast.error(msg)}),
    ],
  });

/**
 * React-Komponente, die den URQL-Provider mit Authentifizierungs-Token und Navigation bereitstellt.
 * @param props Enthält optionale Navigationsfunktion und Kinderkomponenten.
 * @returns URQL-Provider mit konfiguriertem Client.
 */
export const UrqlProvider: FC<
  PropsWithChildren<{navigate?: NavigateFunction}>
> = ({children, navigate}) => {
  const {token, logout} = useAuth();
  const client = useMemo(
    () =>
      createUrqlClient({
        token,
        cache: true,
        navigate,
        invalidateSession: logout,
      }),
    [navigate, token, logout],
  );

  return <Provider value={client}>{children}</Provider>;
};

/**
 * Fehlerklasse, die ausgelöst wird, wenn ein erforderlicher Kontext nicht bereitgestellt wurde.
 */
export class NoContextProvidedError extends Error {
  /**
   * Erzeugt eine neue Instanz mit einer Fehlermeldung zum fehlenden Kontext.
   * @param contextName Name des fehlenden Kontexts.
   */
  constructor(contextName: string) {
    super(`${contextName} must be provided before using it.`);
  }
}

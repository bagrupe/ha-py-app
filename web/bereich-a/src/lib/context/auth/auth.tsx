import {useSharedSessionStorage} from '@kommunalapp/common';
import {
  createContext,
  type FC,
  type PropsWithChildren,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useRef,
  useState,
} from 'react';
import {LoginResult} from '../../../__generated__/graphql';
import {createUrqlClient, NoContextProvidedError} from '../../../urql';
import {
  decryptOrganisationKey,
  decryptPersonalKey,
  getServerLoginPassword,
} from '../../crypto/crypto';
import {
  LoginDocument,
  type LoginMutation,
  type LoginMutationVariables,
  MyDocument,
  type MyQuery,
  type UserFragment,
} from './auth.generated';

/**
 * Ergebnis von {@link AuthContextData.passwordLogin}: bei Erfolg inkl. frisch geladener Nutzerdaten
 * (für Weiterleitung ohne stale Context aus dem vorherigen Render).
 */
export type PasswordLoginResult =
  | {ok: true; user: UserFragment}
  | {ok: false; result: LoginResult | undefined};

/**
 * Typ für die Authentifizierungs-Kontextdaten mit Status, Nutzerinformationen und Funktionen.
 */
type AuthContextData = {
  isLoggedIn: boolean;
  user: Extract<UserFragment, {__typename: 'BackofficeUser'}> | null;
  passwordLogin: (
    email: string,
    password: string,
    twoFactorCode?: string,
  ) => Promise<PasswordLoginResult>;
  logout: (passwordChanged?: boolean) => Promise<void>;
  personalPrivateKey: CryptoKey | undefined;
  organisationPrivateKey: CryptoKey | undefined;
  redirectedFromPwChange: boolean;
  token?: string;
  refetch: () => void;
};

/**
 * Typ für die im Session-Speicher abgelegten Authentifizierungsdaten.
 */
type SessionData = {
  user?: UserFragment;
  password?: string;
  personalPrivateKey?: CryptoKey;
  organisationPrivateKey?: CryptoKey;
  token?: string;
};

/**
 * React-Kontext für die Authentifizierung.
 */
export const AuthContext = createContext<AuthContextData | null>(null);

/**
 * Hook zum Zugriff auf den Authentifizierungs-Kontext.
 * @throws Fehler, wenn der Kontext nicht vorhanden ist.
 */
export const useAuth = () => {
  const auth = useContext(AuthContext);

  if (!auth) {
    throw new NoContextProvidedError('AuthContext');
  }

  return auth;
};

/**
 * Typ für die verschiedenen Nutzerrollen.
 */
export type UserTypes = UserFragment['__typename'];

/**
 * Mindestlänge des Passworts abhängig vom Nutzertyp.
 */
export const userTypePasswordMinLength: Record<UserTypes, number> = {
  Buerger: 8,
  BackofficeUser: 12,
  SystemUser: 100,
};

/**
 * Liefert die minimale Passwortlänge für einen gegebenen Nutzertyp.
 * @param userType Der Typ des Nutzers.
 * @returns Minimale Passwortlänge.
 */
export const getPasswordMinLengthByUser = (userType?: UserTypes) => {
  if (!userType || !(userType in userTypePasswordMinLength)) {
    return 12;
  }
  return userTypePasswordMinLength[userType];
};

/**
 * Provider-Komponente für den Authentifizierungs-Kontext.
 * Verwaltet Login, Logout, Session-Daten und Schlüssel.
 */
export const AuthProvider: FC<
  PropsWithChildren<{broadcastTimeout?: number}>
> = ({children, broadcastTimeout}) => {
  const [redirectedFromPwChange, setRedirectedFromPwChange] = useState(false);
  const client = createUrqlClient();
  const didFetch = useRef(false);

  const {
    data: session = {},
    setData: setSessionData,
    clear: clearSessionData,
    loading,
  } = useSharedSessionStorage<SessionData>({broadcastTimeout});

  const isLoggedIn = !!session.user;

  const passwordLogin = useCallback(
    async (email: string, rawPassword: string) => {
      email = email.toLowerCase();

      const serverLoginPassword = await getServerLoginPassword(
        rawPassword,
        email,
      );
      setRedirectedFromPwChange(false);

      if (!serverLoginPassword) {
        return {ok: false as const, result: undefined};
      }
      const response = await client.mutation<
        LoginMutation,
        LoginMutationVariables
      >(LoginDocument, {
        input: {
          email,
          password: serverLoginPassword,
        },
      });
      const {result = LoginResult.WrongLogin, token} =
        response.data?.login ?? {};

      if (result !== LoginResult.Success || !token) {
        return {ok: false as const, result};
      }

      const authenticatedClient = createUrqlClient({token});

      const user = (await authenticatedClient.query<MyQuery>(MyDocument, {}))
        .data?.my;

      if (!user) {
        return {ok: false as const, result};
      }

      if (
        !(
          ['Buerger', 'BackofficeUser'] satisfies UserTypes[] as string[]
        ).includes(user.__typename) ||
        !('personalPrivateKeySalt' in user)
      ) {
        return {ok: false as const, result};
      }

      const personalPrivateKey = await decryptPersonalKey(
        rawPassword,
        user.personalPrivateKeySalt!,
        user.personalPrivateKey!,
      );

      let organisationPrivateKey: CryptoKey | undefined;

      if (user.__typename === 'BackofficeUser') {
        organisationPrivateKey = await decryptOrganisationKey(
          personalPrivateKey,
          user.organisationPrivateKey!,
          user.kommune.privateKey!,
        );
      }

      const sessionData = {
        password: rawPassword,
        token,
        user,
        personalPrivateKey,
        organisationPrivateKey,
      };

      await setSessionData(sessionData);

      return {ok: true as const, user};
    },
    [client, setSessionData],
  );

  /**
   * Führt den Logout durch und löscht die Session-Daten.
   * @param passwordChanged Gibt an, ob das Passwort geändert wurde.
   */
  const logout = useCallback(
    async (passwordChanged?: boolean) => {
      // Rufe Backend-Endpoint auf, um das Bereich B Cookie zu löschen
      try {
        await fetch('/api/logout', {
          method: 'POST',
          credentials: 'include',
        });
      } catch (error) {
        console.error('Fehler beim Logout:', error);
      }
      clearSessionData();
      setRedirectedFromPwChange(passwordChanged || false);
      // Make sure that nothing is still loaded in the cache
      location.reload();
    },
    [clearSessionData],
  );

  /**
   * Lädt die Nutzerdaten neu vom Server und aktualisiert die Session.
   */
  const refetch = useCallback(async () => {
    if (!session.token) return;

    const authenticatedClient = createUrqlClient({token: session.token});

    const user = (await authenticatedClient.query<MyQuery>(MyDocument, {})).data
      ?.my;

    if (user) {
      await setSessionData({...session, user});
    }
  }, [session, setSessionData]);

  useEffect(() => {
    if (!session.token || didFetch.current) return;
    void refetch();
    didFetch.current = true;
  }, [refetch, session.token]);

  const contextValue = useMemo<AuthContextData>(
    () => ({
      isLoggedIn,
      passwordLogin,
      logout,
      user:
        (session.user as Extract<
          UserFragment,
          {__typename: 'BackofficeUser'}
        >) ?? null,
      personalPrivateKey: session.personalPrivateKey,
      organisationPrivateKey: session.organisationPrivateKey,
      redirectedFromPwChange,
      token: session.token,
      refetch,
    }),
    [
      isLoggedIn,
      passwordLogin,
      logout,
      session.user,
      session.personalPrivateKey,
      session.organisationPrivateKey,
      session.token,
      redirectedFromPwChange,
      refetch,
    ],
  );

  return loading ? null : (
    <AuthContext.Provider value={contextValue}>{children}</AuthContext.Provider>
  );
};

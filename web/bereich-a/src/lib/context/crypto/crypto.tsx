import {
  createContext,
  type FC,
  type PropsWithChildren,
  useContext,
  useMemo,
} from 'react';
import {type CryptoCache} from '../../hooks/use-crypto-cache.ts';

/**
 * Typ für die Daten des Kryptografie-Kontexts mit optionalem Entschlüsselungsschlüssel und Cache.
 */
type CryptoContextData = {
  decryptionKey?: CryptoKey;
  cryptoCache?: CryptoCache;
};

/**
 * React-Kontext zur Bereitstellung von Kryptografie-Daten.
 */
const CryptoContext = createContext<CryptoContextData>({
  decryptionKey: undefined,
  cryptoCache: undefined,
});

/**
 * Eigenschaften für den Kryptografie-Provider mit Entschlüsselungsschlüssel und Cache.
 */
export type CryptoProviderProps = PropsWithChildren<{
  decryptionKey: CryptoKey;
  cryptoCache: CryptoCache;
}>;

/**
 * Provider-Komponente, die Kryptografie-Daten im Kontext bereitstellt.
 * @param decryptionKey Der Entschlüsselungsschlüssel
 * @param cryptoCache Der Kryptografie-Cache
 * @param children Eingebettete React-Komponenten
 */
export const CryptoProvider: FC<CryptoProviderProps> = ({
  decryptionKey,
  cryptoCache,
  children,
}) => {
  const value = useMemo(
    () => ({decryptionKey, cryptoCache}),
    [decryptionKey, cryptoCache],
  );

  return (
    <CryptoContext.Provider value={value}>{children}</CryptoContext.Provider>
  );
};

/**
 * Hook zum Zugriff auf den Kryptografie-Kontext.
 * @throws Fehler, wenn der Hook außerhalb des CryptoProviders verwendet wird.
 * @returns Die Kryptografie-Daten aus dem Kontext
 */
export const useCrypto = () => {
  const context = useContext(CryptoContext);

  if (!context) throw new Error('useCrypto used outside of CryptoProvider');

  return context;
};

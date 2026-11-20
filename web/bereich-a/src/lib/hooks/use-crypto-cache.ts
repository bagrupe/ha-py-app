import {useMemo, useRef} from 'react';
import {
  asymmetricUnwrapKey,
  type EncryptedValue,
  symmetricDecryptValue,
} from '../crypto/crypto.tsx';

/**
 * Typ für einen Cache, der entschlüsselte Werte und asymmetrisch entschlüsselte Schlüssel speichert.
 */
export type CryptoCache = {
  /**
   * Liefert einen entschlüsselten Wert aus dem Cache oder entschlüsselt ihn bei Bedarf.
   * @param key Der Schlüssel zur Entschlüsselung.
   * @param value Der verschlüsselte Wert.
   * @returns Das entschlüsselte Ergebnis als Promise.
   */
  getDecryptedValueCached: (
    key: CryptoKey,
    value: EncryptedValue,
  ) => Promise<string>;
  /**
   * Liefert einen asymmetrisch entschlüsselten Schlüssel aus dem Cache oder entschlüsselt ihn bei Bedarf.
   * @param key Der Schlüssel zur Entschlüsselung.
   * @param value Der verschlüsselte Schlüssel als String.
   * @returns Den entschlüsselten CryptoKey als Promise.
   */
  getAsymmetricUnwrappedKeyCached: (
    key: CryptoKey,
    value: string,
  ) => Promise<CryptoKey>;
};

/**
 * Erzeugt einen eindeutigen Schlüssel für den Cache basierend auf den Bestandteilen eines verschlüsselten Werts.
 * @param encryptedValue Der verschlüsselte Wert.
 * @returns Ein String, der als Cache-Schlüssel dient.
 */
const createCacheKey = (encryptedValue: EncryptedValue) =>
  `${encryptedValue.tag};${encryptedValue.cipher};${encryptedValue.nonce}`;

/**
 * React-Hook, der einen Cache für entschlüsselte Werte und Schlüssel bereitstellt.
 * Er vermeidet wiederholte Entschlüsselungen durch Zwischenspeicherung.
 * @returns Ein Objekt mit Methoden zum Zugriff auf den Cache.
 */
export const useCryptoCache = () => {
  const cacheRef = useRef<Map<string, string>>(undefined);
  const keyCacheRef = useRef<Map<string, CryptoKey>>(undefined);

  let cache: Map<string, string>;

  // FIXME(react-hooks v7): lazy ref init reads/mutates ref during render.
  // eslint-disable-next-line react-hooks/refs
  if (!cacheRef.current) {
    cache = new Map<string, string>();
    cacheRef.current = cache;
  } else {
    cache = cacheRef.current;
  }

  let keyCache: Map<string, CryptoKey>;

  // FIXME(react-hooks v7): lazy ref init reads/mutates ref during render.
  // eslint-disable-next-line react-hooks/refs
  if (!keyCacheRef.current) {
    keyCache = new Map<string, CryptoKey>();
    keyCacheRef.current = keyCache;
  } else {
    keyCache = keyCacheRef.current;
  }

  return useMemo<CryptoCache>(
    () => ({
      async getDecryptedValueCached(key, value: EncryptedValue) {
        const cached = cache.get(createCacheKey(value));

        if (cached) {
          return cached;
        }

        const decrypted = await symmetricDecryptValue(key, value);
        cache.set(createCacheKey(value), decrypted);

        return decrypted;
      },
      async getAsymmetricUnwrappedKeyCached(key, value) {
        const cached = keyCache.get(value);

        if (cached) {
          return cached;
        }

        const decrypted = await asymmetricUnwrapKey(key, value);

        keyCache.set(value, decrypted);

        return decrypted;
      },
    }),
    [cache, keyCache],
  );
};

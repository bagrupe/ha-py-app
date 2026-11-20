import {useAuth} from '../context/auth/auth.tsx';
import {asymmetricUnwrapKeyWithCache} from '../crypto/crypto.tsx';
import {useAsyncMemo} from './use-async-memo.ts';
import {type CryptoCache} from './use-crypto-cache.ts';

/**
 * React-Hook, der einen entschlüsselten Schlüssel aus einem verschlüsselten Schlüssel und einem privaten Organisationsschlüssel liefert.
 * Nutzt optional einen Cache zur Vermeidung wiederholter Entschlüsselungen.
 * @param encryptedKey Der verschlüsselte Schlüssel als Base64-kodierter String.
 * @param cryptoCache Optionaler Cache für entschlüsselte Schlüssel.
 * @returns Den entschlüsselten CryptoKey und einen möglichen Fehler.
 */
export function useDecryptedKey(
  encryptedKey: string | undefined | null,
  cryptoCache?: CryptoCache,
) {
  const {organisationPrivateKey} = useAuth();

  return useAsyncMemo(async () => {
    if (organisationPrivateKey === undefined || !encryptedKey) {
      return undefined;
    }

    return await asymmetricUnwrapKeyWithCache(
      organisationPrivateKey,
      encryptedKey,
      cryptoCache,
    );
  }, [encryptedKey, organisationPrivateKey, cryptoCache]);
}

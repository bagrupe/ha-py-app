import {type FC, type ReactNode} from 'react';
import {type EncryptedValueFragment} from '../../lib/context/auth/auth.generated';
import {useCrypto} from '../../lib/context/crypto/crypto.tsx';
import {symmetricDecryptValueWithCache} from '../../lib/crypto/crypto';
import {useAsyncMemo} from '../../lib/hooks/use-async-memo.ts';
import {type CryptoCache} from '../../lib/hooks/use-crypto-cache.ts';
import {Skeleton} from '../skeleton.tsx';

/**
 * Eigenschaften für die `DecryptValue`-Komponente.
 * Enthält den zu entschlüsselnden Wert, optionalen Schlüssel und Cache sowie eine Renderfunktion für den entschlüsselten Text.
 */
export type DecryptValueProps = {
  value: EncryptedValueFragment | string;
  decryptionKey?: CryptoKey;
  cryptoCache?: CryptoCache;
  children?: (decrypted: string) => ReactNode;
};

/**
 * Komponente zur Entschlüsselung eines Wertes und Darstellung des entschlüsselten Textes.
 * Nutzt Kontext oder übergebene Schlüssel und Cache zur Entschlüsselung.
 */
export const DecryptValue: FC<DecryptValueProps> = ({
  value,
  decryptionKey: providedKey,
  cryptoCache: providedCache,
  children,
}) => {
  const {decryptionKey = providedKey, cryptoCache = providedCache} =
    useCrypto();

  const {value: decrypted, error} = useAsyncMemo(async () => {
    if (typeof value === 'string') return value;
    if (decryptionKey === undefined) {
      return '';
    }

    return await symmetricDecryptValueWithCache(
      decryptionKey,
      value,
      cryptoCache,
    );
  }, [value, decryptionKey, cryptoCache]);

  if (error) {
    return (
      <span className='text-red-600'>Entschlüsselung fehlgeschlagen.</span>
    );
  }

  if (decrypted === undefined || decryptionKey === undefined) {
    return <Skeleton className='inline-block w-24' />;
  }

  if (!children) {
    return <>{decrypted}</>;
  }

  return <>{children(decrypted)}</>;
};

type ObjectWithMultiple = {
  [key: string]: EncryptedValueFragment | string | null | undefined;
};
type MapPropertiesToString<T extends ObjectWithMultiple> = {
  [P in keyof T]: string;
};

/**
 * Komponente zur gleichzeitigen Entschlüsselung mehrerer Werte.
 * Erwartet ein Objekt mit verschlüsselten oder unverschlüsselten Werten und gibt ein Objekt mit entschlüsselten Strings zurück.
 */
export function DecryptValueMultiple<T extends ObjectWithMultiple>({
  value,
  decryptionKey: providedKey,
  cryptoCache: providedCache,
  children,
}: {
  value: T;
  decryptionKey?: CryptoKey;
  cryptoCache?: CryptoCache;
  children: (decrypted: MapPropertiesToString<T>) => ReactNode;
}) {
  const {decryptionKey = providedKey, cryptoCache = providedCache} =
    useCrypto();

  const {value: decrypted, error} = useAsyncMemo<
    MapPropertiesToString<T>
  >(async () => {
    const promises = Object.entries(value).map(([k, v]) => {
      if (decryptionKey === undefined || v === null || v === undefined) {
        return Promise.resolve([k, '']);
      } else if (typeof v === 'string') {
        return Promise.resolve([k, v]);
      } else {
        return symmetricDecryptValueWithCache(
          decryptionKey,
          v,
          cryptoCache,
        ).then((d) => [k, d]);
      }
    });

    return Object.fromEntries(await Promise.all(promises));
  }, [value, decryptionKey, cryptoCache]);

  if (error) {
    return (
      <span className='text-red-600'>Entschlüsselung fehlgeschlagen.</span>
    );
  }
  if (decrypted === undefined || decryptionKey === undefined) {
    return <Skeleton className='inline-block w-24' />;
  }

  return <>{children(decrypted)}</>;
}

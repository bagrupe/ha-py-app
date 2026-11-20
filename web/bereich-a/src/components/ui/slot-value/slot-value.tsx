import {Fragment, type ReactNode} from 'react';
import {type CryptoCache} from '../../../lib/hooks/use-crypto-cache.ts';
import {DecryptValue} from '../decrypt-value.tsx';
import {type SlotValueFragment} from './slot-value.generated.ts';

/**
 * Eigenschaften für die `SlotValue`-Komponente.
 *
 * @template T - Typ des dargestellten Wertes.
 * @param value - Der anzuzeigende Wert, entweder als Klartext oder verschlüsselt.
 * @param children - Funktion zur individuellen Darstellung des Wertes.
 * @param decryptionKey - Schlüssel zur Entschlüsselung, falls der Wert verschlüsselt ist.
 * @param cryptoCache - Cache zur Optimierung der Entschlüsselung.
 */
export type SlotValueProps<T> = {
  value: SlotValueFragment | string;
  children?: (value: T | string) => ReactNode;

  decryptionKey?: CryptoKey;
  cryptoCache?: CryptoCache;
};

/**
 * Komponente zur Darstellung eines Slot-Wertes, der entweder als Klartext oder verschlüsselt vorliegt.
 * Nutzt bei verschlüsselten Werten die `DecryptValue`-Komponente zur Entschlüsselung.
 *
 * @template T - Typ des dargestellten Wertes.
 * @param props - Eigenschaften der Komponente.
 * @returns Die gerenderte Darstellung des Wertes.
 */
export function SlotValue<T>({value, children, ...decrypt}: SlotValueProps<T>) {
  children ??= (value: T | string) => <>{value}</>;

  if (typeof value === 'string') return children(value);

  if (value.__typename === 'PlainSlotValue') {
    if (Array.isArray(value.plainValue)) {
      return (
        <>
          {value.plainValue.map((v, i) => (
            <Fragment key={i}>{children?.(v as T)}</Fragment>
          ))}
        </>
      );
    }

    return children(value.plainValue as T);
  }

  if (value.__typename === 'EncryptedSlotValue') {
    return (
      <DecryptValue value={value.encryptedValue} {...decrypt}>
        {children}
      </DecryptValue>
    );
  }
}

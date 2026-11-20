import {
  type SlotValue_EncryptedSlotValue_Fragment,
  type SlotValue_PlainSlotValue_Fragment,
} from '../../components/ui/slot-value/slot-value.generated';
import {useAsyncMemo} from '../../lib/hooks/use-async-memo.ts';
import {type CryptoCache} from '../../lib/hooks/use-crypto-cache';

/**
 * Typ für eine Liste von Slot-Werten, die entweder verschlüsselt oder im Klartext vorliegen.
 */
type SlotValues = Array<
  | ({
      __typename?: 'EncryptedSlotValue';
    } & SlotValue_EncryptedSlotValue_Fragment)
  | ({__typename?: 'PlainSlotValue'} & SlotValue_PlainSlotValue_Fragment)
>;

/**
 * Hook zum asynchronen Entschlüsseln von Slot-Werten.
 * Nutzt einen CryptoCache und einen Entschlüsselungsschlüssel, um verschlüsselte Werte zu entschlüsseln.
 * Gibt ein Objekt mit den entschlüsselten oder im Klartext vorliegenden Slot-Werten zurück.
 *
 * @param cryptoCache Cache für kryptographische Operationen
 * @param decryptionKey Schlüssel zur Entschlüsselung der Werte
 * @param slotValues Liste der zu verarbeitenden Slot-Werte
 * @returns Ein Objekt mit den entschlüsselten Slot-Werten, indexiert nach Slot-Namen
 */
export const useDecryptedSlots = (
  cryptoCache: CryptoCache | undefined,
  decryptionKey: CryptoKey | undefined,
  slotValues: SlotValues | undefined,
) =>
  useAsyncMemo(async () => {
    const map: Record<string, unknown> = {};
    if (!cryptoCache || !decryptionKey || !slotValues) {
      return map;
    }

    for (const slotValue of slotValues) {
      if (slotValue.__typename === 'PlainSlotValue') {
        map[slotValue.slotName] = slotValue.plainValue;
      } else if (slotValue.__typename === 'EncryptedSlotValue') {
        map[slotValue.slotName] = await cryptoCache.getDecryptedValueCached(
          decryptionKey,
          slotValue.encryptedValue,
        );
      }
    }

    return map;
  }, [cryptoCache, decryptionKey, slotValues]);

import {ZustaendigkeitArt} from 'src/__generated__/graphql.ts';
import type {CryptoCache} from 'src/lib/hooks/use-crypto-cache.ts';
import type {AusfuehrungFragment} from '../ausfuehrungen.generated.ts';

/**
 * Liefert die Anzeigebezeichnung der verantwortlichen Gruppe wie in der Ausführungen-Tabelle.
 */
export function formatVerantwortlicheGruppeLabel(
  ausfuehrung: AusfuehrungFragment,
): string {
  const z = ausfuehrung.istZustaendigkeit;
  if (z.art === ZustaendigkeitArt.Buerger) {
    return 'Bürger';
  }
  return (
    z.dienstleister?.name ??
    z.mitarbeiterGruppe?.name ??
    z.organisationseinheit?.name ??
    ''
  );
}

/**
 * Baut die Slot-Werte für die Auswertung des Beschreibungstexts (entschlüsselt wo nötig).
 */
export async function buildBeschreibungstextSlotsMap(
  ausfuehrung: AusfuehrungFragment,
  decryptionKey: CryptoKey,
  cryptoCache: CryptoCache,
): Promise<Record<string, unknown>> {
  const map: Record<string, unknown> = {};

  for (const slotValue of ausfuehrung.beschreibungstextSlotValues) {
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
}

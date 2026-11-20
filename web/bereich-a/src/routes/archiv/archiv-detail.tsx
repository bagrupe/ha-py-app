import {format} from 'date-fns';
import {type FC, type ReactNode} from 'react';
import {Link, useParams} from 'react-router';
import {useAsyncMemoAndResetOnChange} from 'src/lib/hooks/use-async-memo.ts';
import {useCryptoCache} from 'src/lib/hooks/use-crypto-cache.ts';
import {useDecryptedKey} from 'src/lib/hooks/use-decrypted-key.ts';
import {AusfuehrungVerlauf} from '../antraege/detail/components/ausfuehrung-verlauf.tsx';
import {useArchivierterAntragQuery} from './archiv.generated';

const formatDatum = (d?: Date | null): string =>
  d ? format(d, 'dd.MM.yyyy HH:mm') : '–';

/** Erkennt Base64-Bilddaten und baut eine Data-URL. */
const toImageSrc = (b64: string): string | null => {
  if (b64.startsWith('data:image')) return b64;
  if (b64.startsWith('/9j/')) return `data:image/jpeg;base64,${b64}`;
  if (b64.startsWith('iVBORw0KGgo')) return `data:image/png;base64,${b64}`;
  if (b64.startsWith('R0lGOD')) return `data:image/gif;base64,${b64}`;
  return null;
};

/** Stellt einen entschlüsselten Slot-Wert lesbar dar (String, Bild, Objekt …). */
export const renderWert = (raw: string): ReactNode => {
  if (raw === '') return <span className='text-gray-400'>–</span>;

  let parsed: unknown;
  try {
    parsed = JSON.parse(raw);
  } catch {
    return raw;
  }

  if (typeof parsed === 'string') return parsed === '' ? '–' : parsed;
  if (typeof parsed === 'number' || typeof parsed === 'boolean') {
    return String(parsed);
  }

  if (Array.isArray(parsed)) {
    const imgs = parsed
      .map((v) => (typeof v === 'string' ? toImageSrc(v) : null))
      .filter((s): s is string => s !== null);
    if (imgs.length > 0 && imgs.length === parsed.length) {
      return (
        <div className='flex flex-wrap gap-2'>
          {imgs.map((src, i) => (
            <img
              key={i}
              src={src}
              alt={`Bild ${i + 1}`}
              className='max-h-40 max-w-full rounded border border-gray-200'
            />
          ))}
        </div>
      );
    }
    return JSON.stringify(parsed);
  }

  if (parsed && typeof parsed === 'object') {
    return (
      <pre className='whitespace-pre-wrap break-words text-sm text-gray-700'>
        {JSON.stringify(parsed, null, 2)}
      </pre>
    );
  }

  return raw;
};

/**
 * Read-only Detailansicht eines archivierten Antrags (Berechtigung "Archiv einsehen" erforderlich,
 * per <IfFunktionsberechtigung> auf Routen-Ebene durchgesetzt).
 * Entschlüsselt die Slot-Werte mit dem bestehenden Krypto-Weg (Kommune-Schlüssel).
 */
export const ArchivDetail: FC = () => {
  const {id = ''} = useParams();
  const cryptoCache = useCryptoCache();

  const [{data, fetching}] = useArchivierterAntragQuery({
    variables: {id},
    pause: !id,
  });

  const antrag = data?.archivierterAntrag ?? null;
  const {value: decryptionKey, error: decryptionKeyError} = useDecryptedKey(
    antrag?.sharedKeyEncryptedForKommune,
    cryptoCache,
  );

  // useAsyncMemoAndResetOnChange statt useAsyncMemo: setzt den Wert bei Wechsel auf einen
  // anderen archivierten Antrag zurück, statt kurzzeitig die zuvor entschlüsselten Daten des
  // vorherigen Antrags anzuzeigen.
  const {value: entschluesselt, error: slotValuesError} =
    useAsyncMemoAndResetOnChange(async () => {
      const map: Record<string, string> = {};
      if (!antrag) return map;
      for (const s of antrag.slotWerte) {
        if (s.encrypted) {
          if (decryptionKey && s.encryptedValue) {
            map[s.slotName] = await cryptoCache.getDecryptedValueCached(
              decryptionKey,
              s.encryptedValue,
            );
          }
        } else {
          map[s.slotName] = s.plainValue ?? '';
        }
      }
      return map;
    }, [antrag, decryptionKey, cryptoCache]);

  const entschluesselnFehler = decryptionKeyError || slotValuesError;

  return (
    <div className='mx-auto flex max-w-3xl flex-col gap-4 p-6'>
      <Link to='/archiv' className='text-primary'>
        ← Zurück zum Archiv
      </Link>

      {fetching ? (
        <p>Lädt …</p>
      ) : !antrag ? (
        <p className='text-gray-500'>Archivierter Antrag nicht gefunden.</p>
      ) : (
        <>
          <div>
            <h1 className='text-2xl font-bold'>
              {antrag.prozessBezeichnung ?? 'Archivierter Antrag'}
            </h1>
            <p className='mt-1 text-sm text-gray-500'>
              Erstellt: {formatDatum(antrag.createdAt)} · Abgeschlossen:{' '}
              {formatDatum(antrag.abgeschlossenAm)} · Archiviert:{' '}
              {formatDatum(antrag.archiviertAm)}
            </p>
          </div>

          {entschluesselnFehler && (
            <p className='rounded-md bg-red-50 px-4 py-2 text-red-700'>
              Die Antragsdaten konnten nicht entschlüsselt werden.
            </p>
          )}

          <div className='rounded-lg border border-gray-200'>
            <div className='border-b border-gray-100 px-4 py-2 font-semibold'>
              Antragsdaten (schreibgeschützt)
            </div>
            {antrag.slotWerte.length === 0 ? (
              <p className='px-4 py-3 text-gray-500'>Keine Daten vorhanden.</p>
            ) : (
              <table className='w-full table-fixed border-collapse text-left'>
                <tbody>
                  {antrag.slotWerte.map((s) => (
                    <tr key={s.slotName} className='border-b border-gray-100'>
                      <td className='w-1/3 break-words px-4 py-2 align-top font-medium text-gray-600 [overflow-wrap:anywhere]'>
                        {s.slotName}
                      </td>
                      <td className='break-words px-4 py-2'>
                        {s.encrypted && entschluesselnFehler
                          ? 'Entschlüsselung fehlgeschlagen.'
                          : s.encrypted && !decryptionKey
                          ? 'Entschlüssele …'
                          : renderWert(entschluesselt?.[s.slotName] ?? '')}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>

          <AusfuehrungVerlauf historie={antrag.verlauf} />
        </>
      )}
    </div>
  );
};

import * as Dialog from '@radix-ui/react-dialog';
import {type FC, useState} from 'react';
import {Link, useNavigate, useParams} from 'react-router';
import {Button} from 'src/components/ui/button';
import {useAsyncMemoAndResetOnChange} from 'src/lib/hooks/use-async-memo.ts';
import {useCryptoCache} from 'src/lib/hooks/use-crypto-cache.ts';
import {useDecryptedKey} from 'src/lib/hooks/use-decrypted-key.ts';
import {AusfuehrungVerlauf} from '../antraege/detail/components/ausfuehrung-verlauf.tsx';
import {renderWert} from '../archiv/archiv-detail.tsx';
import {AntragWiederherstellen} from './antrag-wiederherstellen.tsx';
import {formatDatum} from './papierkorb-liste.tsx';
import {useGeloeschterAntragQuery} from './papierkorb.generated';

export const PapierkorbDetail: FC = () => {
  const {id = ''} = useParams();
  const navigate = useNavigate();
  const cryptoCache = useCryptoCache();
  const [wiederherstellenOpen, setWiederherstellenOpen] = useState(false);

  const [{data, fetching}] = useGeloeschterAntragQuery({
    variables: {id},
    pause: !id,
    requestPolicy: 'cache-and-network',
  });

  const detail = data?.geloeschterAntrag ?? null;
  const antrag = detail?.antrag ?? null;
  const {value: decryptionKey, error: decryptionKeyError} = useDecryptedKey(
    detail?.sharedKeyEncryptedForKommune,
    cryptoCache,
  );

  const {value: entschluesselt, error: slotValuesError} =
    useAsyncMemoAndResetOnChange(async () => {
      const map: Record<string, string> = {};
      if (!detail) return map;
      for (const s of detail.slotWerte) {
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
    }, [detail, decryptionKey, cryptoCache]);

  const entschluesselnFehler = decryptionKeyError || slotValuesError;

  return (
    <div className='mx-auto flex max-w-3xl flex-col gap-4 p-6'>
      <Link to='/papierkorb' className='text-primary'>
        ← Zurück zum Papierkorb
      </Link>

      {fetching && !detail ? (
        <p>Lädt …</p>
      ) : !detail || !antrag ? (
        <p className='text-gray-500'>
          Antrag nicht gefunden. Möglicherweise wurde er bereits endgültig
          gelöscht oder wiederhergestellt.
        </p>
      ) : (
        <>
          <div className='flex items-start justify-between gap-4'>
            <div className='min-w-0'>
              <h1 className='text-2xl font-bold'>
                {antrag.prozessBezeichnung}
              </h1>
              <p className='mt-1 text-sm text-gray-500'>
                Eingereicht: {formatDatum(antrag.createdAt)} · Gelöscht:{' '}
                {formatDatum(antrag.geloeschtAm)}
                {antrag.geloeschtVon ? ` von ${antrag.geloeschtVon}` : ''}
              </p>
              <p className='mt-1 text-sm text-gray-500'>
                Endgültige Löschung:{' '}
                {antrag.endgueltigGeloeschtAm
                  ? formatDatum(antrag.endgueltigGeloeschtAm)
                  : 'keine Frist'}
              </p>
              <p className='mt-1 whitespace-pre-wrap break-words text-sm'>
                <span className='font-medium'>Löschgrund:</span>{' '}
                {antrag.loeschgrund ?? '–'}
              </p>
            </div>
            <Dialog.Root
              open={wiederherstellenOpen}
              onOpenChange={setWiederherstellenOpen}
            >
              <Dialog.Trigger asChild>
                <Button className='shrink-0'>Wiederherstellen</Button>
              </Dialog.Trigger>
              <AntragWiederherstellen
                ausfuehrungId={antrag.id}
                onOpenChange={setWiederherstellenOpen}
                onWiederhergestellt={() => navigate('/papierkorb')}
              />
            </Dialog.Root>
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
            {detail.slotWerte.length === 0 ? (
              <p className='px-4 py-3 text-gray-500'>Keine Daten vorhanden.</p>
            ) : (
              <table className='w-full table-fixed border-collapse text-left'>
                <tbody>
                  {detail.slotWerte.map((s) => (
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

          <AusfuehrungVerlauf historie={detail.verlauf} />
        </>
      )}
    </div>
  );
};

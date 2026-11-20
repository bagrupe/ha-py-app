import {type FC} from 'react';
import {MdAccountCircle} from 'react-icons/md';
import {InputField} from '../../../../../components/form/fields/input-field';
import {useCrypto} from '../../../../../lib/context/crypto/crypto.tsx';
import {useAsyncMemo} from '../../../../../lib/hooks/use-async-memo.ts';
import {
  type AntragDetailAusfuehrung,
  type AntragDetailSchritt_EmailForwarderExportSchritt,
} from '../../detail.generated.ts';

/**
 * Eigenschaften für die Komponente EmailForwarderExportSchritt.
 * Enthält optional das Bearbeitungsdatum, den Schritt mit E-Mail-Daten und die Ausführung des Antrags.
 */
export type EmailForwarderExportSchrittProps = {
  bearbeitungsDatum?: Date;
  schritt: AntragDetailSchritt_EmailForwarderExportSchritt;
  ausfuehrung: AntragDetailAusfuehrung;
};

/**
 * Komponente zur Darstellung eines E-Mail-Forwarder-Exportschritts.
 * Nutzt verschlüsselte und unverschlüsselte Slotwerte zur Anzeige von Betreff, E-Mail-Adresse, Datum und Bemerkung.
 * @param bearbeitungsDatum Optionales Datum der Bearbeitung
 * @param schritt Enthält die Daten des E-Mail-Forwarder-Exportschritts
 * @param ausfuehrung Die Ausführung des Antrags mit Slotwerten
 */
export const EmailForwarderExportSchritt: FC<
  EmailForwarderExportSchrittProps
> = ({bearbeitungsDatum, schritt, ausfuehrung}) => {
  const {decryptionKey, cryptoCache} = useCrypto();

  const {value: slots, error} = useAsyncMemo(async () => {
    const map: Record<string, unknown> = {};
    if (!cryptoCache || !decryptionKey) {
      return map;
    }

    for (const slotValue of ausfuehrung.slotValues) {
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
  }, []);

  if (error) {
    return (
      <p className='rounded-md bg-red-50 px-4 py-2 text-red-700'>
        Entschlüsselung fehlgeschlagen.
      </p>
    );
  }

  if (!slots) {
    return null;
  }

  return (
    <div className='flex gap-4 p-2'>
      <div className='mt-2 flex flex-col gap-4'>
        <p className='font-bold leading-none'>
          {schritt.subject.evaluate(slots)}
        </p>
        <div className='flex items-center gap-2'>
          <MdAccountCircle className='size-10 text-primary' />
          <div className='flex flex-col'>
            {bearbeitungsDatum && (
              <p className='text-sm font-light'>
                {bearbeitungsDatum.toLocaleDateString('de-DE', {
                  dateStyle: 'medium',
                })}
              </p>
            )}
            <p className='font-bold leading-none'>
              {schritt.emailAddress.evaluate(slots)}
            </p>
          </div>
        </div>
      </div>
      <InputField
        multiLine
        value={schritt.body.evaluate(slots)}
        label='Bemerkung'
        className='w-full bg-gray-50'
        inputClass='resize-none'
      />
    </div>
  );
};

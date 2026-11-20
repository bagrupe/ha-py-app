import {Fragment, type FC} from 'react';
import {useCrypto} from '../../../../../lib/context/crypto/crypto.tsx';
import {useDecryptedSlots} from '../../../utils.ts';
import {
  type AntragDetailAusfuehrung,
  type AntragDetailSchritt_FormularSchritt,
} from '../../detail.generated.ts';
import {CheckboxListFormularFeld} from '../felder/checkbox-list-formular-feld.tsx';
import {DateFormularFeld} from '../felder/date-formular-feld.tsx';
import {LocationFormularFeld} from '../felder/location-formular-feld.tsx';
import {StringFormularFeld} from '../felder/string-formular-feld.tsx';
import {TimeFormularFeld} from '../felder/time-formular-feld.tsx';
import {UploadFormularFeld} from '../felder/upload-formular-feld.tsx';

/**
 * Eigenschaften für die FormularSchritt-Komponente.
 * Enthält den Formularschritt und die zugehörige Ausführung.
 */
export type FormularSchrittProps = {
  schritt: AntragDetailSchritt_FormularSchritt;
  ausfuehrung: AntragDetailAusfuehrung;
};

/**
 * Komponente zur Darstellung eines Formularschritts mit verschiedenen Formularfeldern.
 * Nutzt entschlüsselte Slot-Werte zur Anzeige relevanter Felder.
 * @param schritt Der Formularschritt mit den Feldern
 * @param ausfuehrung Die Ausführung des Antrags mit Slot-Werten
 */
export const FormularSchritt: FC<FormularSchrittProps> = ({
  schritt,
  ausfuehrung,
}) => {
  const {decryptionKey, cryptoCache} = useCrypto();

  const {value: slots, error} = useDecryptedSlots(
    cryptoCache,
    decryptionKey,
    ausfuehrung.slotValues,
  );

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
    <>
      <div className='flex flex-wrap gap-12 p-2  text-neutral-600'>
        {schritt.felder
          .filter((f) => f.istRelevant.evaluate(slots))
          .map((f) => {
            const content = (
              <>
                {f.__typename === 'StringFormularFeld' && (
                  <StringFormularFeld feld={f} ausfuehrung={ausfuehrung} />
                )}
                {f.__typename === 'LocationFormularFeld' && (
                  <LocationFormularFeld
                    slotName={f.slotName}
                    ausfuehrung={ausfuehrung}
                  />
                )}
                {f.__typename === 'SignatureFormularFeld' && (
                  <UploadFormularFeld
                    anweisung={f.anweisung ?? undefined}
                    slotName={f.slotName}
                    ausfuehrung={ausfuehrung}
                    slots={schritt.slots}
                  />
                )}
                {f.__typename === 'UploadFormularFeld' && (
                  <UploadFormularFeld
                    anweisung={f.anweisung ?? undefined}
                    slotName={f.slotName}
                    ausfuehrung={ausfuehrung}
                    slots={schritt.slots}
                  />
                )}
                {f.__typename === 'CheckboxListFormularFeld' && (
                  <CheckboxListFormularFeld
                    slotName={f.slotName}
                    ausfuehrung={ausfuehrung}
                  />
                )}
                {f.__typename === 'DateFormularFeld' && (
                  <DateFormularFeld
                    slotName={f.slotName}
                    ausfuehrung={ausfuehrung}
                  />
                )}
                {f.__typename === 'TimeFormularFeld' && (
                  <TimeFormularFeld
                    slotName={f.slotName}
                    ausfuehrung={ausfuehrung}
                  />
                )}
                {f.__typename === 'AnzeigeTextBlockFeld' && (
                  <p className='whitespace-pre-wrap break-words'>{f.text}</p>
                )}
              </>
            );

            return (
              <Fragment key={f.slotName}>
                {f.__typename == 'UploadFormularFeld' ? (
                  <>{content}</>
                ) : (
                  <div className='mb-2 flex max-w-full flex-col gap-2'>
                    {f.angezeigterName && (
                      <div className='font-bold leading-none'>
                        {f.angezeigterName}
                        {f.pflichtfeld && '*'}
                      </div>
                    )}
                    <div className='leading-snug'>{content}</div>
                  </div>
                )}
              </Fragment>
            );
          })}
      </div>
      {schritt.felder
        .filter((f) => f.__typename == 'LocationFormularFeld')
        .map((f) => (
          <LocationFormularFeld
            key={`${f.slotName}-map`}
            slotName={f.slotName}
            ausfuehrung={ausfuehrung}
            renderAsMap
          />
        ))}
    </>
  );
};

import {type FC} from 'react';
import {FaFilePdf} from 'react-icons/fa';
import {twMerge} from 'tailwind-merge';
import {SlotValue} from '../../../../../components/ui/slot-value';
import {
  type SlotFragment,
  type AntragDetailAusfuehrung,
} from '../../detail.generated.ts';
import {FreigabeStatus} from '../freigabe-status.tsx';

/**
 * Prüft, ob die übergebenen Daten eine PDF-Datei repräsentieren.
 * @param data Base64-kodierte Daten als String
 * @returns true, wenn die Daten mit dem PDF-Magic-Header beginnen
 */
const guessIsPdf = (data: string) => data.startsWith('JVBERi0');

/**
 * Eigenschaften für das UploadFormularFeld-Komponenten-Interface.
 */
export type UploadFormularFeldProps = {
  slotName: string;
  anweisung?: string;
  ausfuehrung: AntragDetailAusfuehrung;
  slots: SlotFragment[];
};

/**
 * Komponente zur Darstellung eines Upload-Feldes im Formular, das PDF- und Bilddateien unterstützt.
 * Zeigt je nach Dateityp ein PDF-Symbol oder ein Bild an und ermöglicht das Öffnen des Bildes in einem neuen Tab.
 * @param ausfuehrung Daten des Antrags mit Slot-Werten
 * @param slotName Name des Slots, dessen Wert angezeigt wird
 * @param anweisung optionale Anweisungstexte zum Feld
 * @param slots verfügbare Slots zur Freigabedarstellung
 */
export const UploadFormularFeld: FC<UploadFormularFeldProps> = ({
  ausfuehrung,
  slotName,
  anweisung,
  slots,
}) => {
  const slotValue = ausfuehrung.slotValues.find(
    (sv) => sv.slotName === slotName,
  );

  // Optional uploads may be missing; an empty value would otherwise render as a broken image marked "Freigegeben".
  if (!slotValue) {
    return (
      <div className='flex h-fit w-full flex-col gap-4 rounded-lg border border-gray-300 bg-gray-50 p-4'>
        <p className='text-neutral-500'>Keine Datei hochgeladen.</p>
        {anweisung && <p>{anweisung}</p>}
      </div>
    );
  }

  return (
    <div
      className={twMerge(
        'flex h-fit w-full flex-col gap-4 rounded-lg border border-gray-300 bg-gray-50 p-4',
      )}
    >
      <div className='flex grow gap-4 '>
        <SlotValue<string> value={slotValue}>
          {(value) =>
            guessIsPdf(value) ? (
              <a
                download='document.pdf'
                href={'data:application/pdf;base64,' + value}
                className='flex min-h-20 w-full items-center justify-center border border-black hover:cursor-pointer'
              >
                <FaFilePdf className='size-12 text-red-600' />
              </a>
            ) : (
              <div className='flex h-52 w-max border border-black'>
                <img
                  alt=''
                  className='cursor-pointer'
                  src={'data:image/jpg;base64,' + value}
                  onClick={() => openImageInNewTab(value)}
                />
              </div>
            )
          }
        </SlotValue>
      </div>
      <FreigabeStatus
        ausfuehrungId={ausfuehrung.id}
        slotValue={slotValue}
        slots={slots}
      />
      {anweisung && <p className='min-h-16'>{anweisung}</p>}
    </div>
  );
};

const openImageInNewTab = (value: string) => {
  const byteCharacters = atob(value);
  const byteNumbers = new Array(byteCharacters.length);
  for (let i = 0; i < byteCharacters.length; i++) {
    byteNumbers[i] = byteCharacters.charCodeAt(i);
  }
  const byteArray = new Uint8Array(byteNumbers);
  const blob = new Blob([byteArray], {type: 'image/jpg'});
  const blobUrl = URL.createObjectURL(blob);

  const newTab = window.open();
  if (newTab) {
    newTab.location.href = blobUrl;
  }
};

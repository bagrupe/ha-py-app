import {type FC} from 'react';
import {SlotValue} from '../../../../../components/ui/slot-value';
import {type AntragDetailAusfuehrung} from '../../detail.generated.ts';

/**
 * Eigenschaften für das Datumsformularfeld.
 * Enthält den Namen des Slots und die zugehörige Ausführung.
 */
export type DateFormularFeldProps = {
  slotName: string;
  ausfuehrung: AntragDetailAusfuehrung;
};

/**
 * Komponente zur Anzeige eines Datumswerts aus einem Formularfeld.
 * Liest den Wert aus der Ausführung anhand des Slotnamens aus und formatiert ihn als deutsches Datum.
 * @param slotName Name des Slots, dessen Wert angezeigt werden soll.
 * @param ausfuehrung Die Ausführung, aus der der Wert entnommen wird.
 */
export const DateFormularFeld: FC<DateFormularFeldProps> = ({
  slotName,
  ausfuehrung,
}) => (
  <SlotValue
    value={ausfuehrung.slotValues.find((sv) => sv.slotName === slotName) ?? ''}
  >
    {(value) =>
      new Date(value as string).toLocaleDateString('de-DE', {
        dateStyle: 'medium',
      })
    }
  </SlotValue>
);

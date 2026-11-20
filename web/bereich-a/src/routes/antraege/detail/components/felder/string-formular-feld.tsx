import {type FC} from 'react';
import {SlotValue} from '../../../../../components/ui/slot-value';
import {
  type FormularSchrittFeld_StringFormularFeld_Fragment,
  type AntragDetailAusfuehrung,
} from '../../detail.generated.ts';

/**
 * Eigenschaften für das StringFormularFeld-Komponenten.
 * Enthält die Ausführung des Antrags und das zugehörige Formularfeld.
 */
export type StringFormularFeldProps = {
  ausfuehrung: AntragDetailAusfuehrung;
  feld: FormularSchrittFeld_StringFormularFeld_Fragment;
};

/**
 * Komponente zur Darstellung eines String-Formularfelds.
 * Zeigt den Wert des Feldes an, wobei bei vorhandenen Optionen der passende Wert angezeigt wird.
 * @param ausfuehrung - Die Ausführung des Antrags mit den Slot-Werten
 * @param feld - Das Formularfeld mit möglichen Optionen und Slot-Namen
 */
export const StringFormularFeld: FC<StringFormularFeldProps> = ({
  ausfuehrung,
  feld,
}) => {
  const slotValue =
    ausfuehrung.slotValues.find((sv) => sv.slotName === feld.slotName) ?? '';
  const hasOptions = feld.options.length > 0;
  return (
    <SlotValue<string> value={slotValue}>
      {(value) => (
        <>
          {hasOptions
            ? feld.options.find((o) => o.key === value)?.value
            : value}
        </>
      )}
    </SlotValue>
  );
};

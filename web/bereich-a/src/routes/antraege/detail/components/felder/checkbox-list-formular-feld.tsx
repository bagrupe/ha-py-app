import {type FC} from 'react';
import {CheckboxField} from '../../../../../components/form/fields/checkbox-field';
import {SlotValue} from '../../../../../components/ui/slot-value';
import {type AntragDetailAusfuehrung} from '../../detail.generated.ts';

/**
 * Eigenschaften für das CheckboxListFormularFeld.
 * Enthält den Namen des Slots und die Ausführung des Antrags.
 */
export type CheckboxListFormularFeldProps = {
  slotName: string;
  ausfuehrung: AntragDetailAusfuehrung;
};

/**
 * Komponente zur Darstellung eines Formularfeldes mit einer Liste von Checkboxen.
 * Zeigt die Optionen als deaktivierte Checkboxen an, die auf den gespeicherten Slot-Werten basieren.
 * @param slotName Name des Slots, dessen Wert angezeigt werden soll.
 * @param ausfuehrung Die Ausführung des Antrags mit den zugehörigen Bearbeitungen und Slot-Werten.
 */
export const CheckboxListFormularFeld: FC<CheckboxListFormularFeldProps> = ({
  slotName,
  ausfuehrung,
}) => {
  const slotValue =
    ausfuehrung.slotValues.find((sv) => sv.slotName === slotName) ?? '';
  const feld = ausfuehrung.bearbeitungen
    .flatMap((b) =>
      b.schritt.__typename === 'FormularSchritt' ? b.schritt.felder : [],
    )
    .find(
      (f) =>
        f.slotName === slotName && f.__typename === 'CheckboxListFormularFeld',
    );

  if (!feld || feld.__typename !== 'CheckboxListFormularFeld') return;

  return (
    <SlotValue<string> value={slotValue}>
      {(value) => {
        const checkedKeys = new Set(value.split(','));

        return (
          <div className='mt-2 flex flex-col gap-2'>
            {feld.options.map((o) => (
              <CheckboxField
                key={o.key}
                label={o.label}
                value={checkedKeys.has(o.key)}
                orientation='checkbox-left'
                disabled
              />
            ))}
          </div>
        );
      }}
    </SlotValue>
  );
};

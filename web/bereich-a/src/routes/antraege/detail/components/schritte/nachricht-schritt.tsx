import {type FC} from 'react';
import {type AntragDetailAusfuehrung} from '../../detail.generated.ts';

export const NACHRICHT_SLOT_NAME = 'nachricht';

export type NachrichtSchrittProps = {
  ausfuehrung: AntragDetailAusfuehrung;
};

export const NachrichtSchritt: FC<NachrichtSchrittProps> = ({ausfuehrung}) => {
  const slotValue = ausfuehrung.slotValues.find(
    (sv) => sv.slotName === NACHRICHT_SLOT_NAME,
  );
  const nachricht =
    slotValue?.__typename === 'PlainSlotValue' &&
    typeof slotValue.plainValue === 'string'
      ? slotValue.plainValue
      : null;

  return (
    <p className='whitespace-pre-wrap break-words p-2 leading-snug'>
      {nachricht ?? 'Es wurde keine Nachricht verfasst.'}
    </p>
  );
};

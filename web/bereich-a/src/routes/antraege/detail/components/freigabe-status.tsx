import {type FC} from 'react';
import {Button} from '../../../../components/ui/button';
import {
  type SlotValue_EncryptedSlotValue_Fragment,
  type SlotValue_PlainSlotValue_Fragment,
} from '../../../../components/ui/slot-value';
import {mutationFailed} from '../../../../lib/mutation';
import {
  type SlotFragment,
  useAusfuehrungQuery,
  useUpdateIstFreigegebenSlotValueMutation,
} from '../detail.generated';

/**
 * Typ für die Eigenschaften der FreigabeStatus-Komponente.
 * Enthält die ID der Ausführung, die Slots und den aktuellen Slotwert.
 */
export type FreigabeStatus = {
  ausfuehrungId: string;
  slots: SlotFragment[];
  slotValue:
    | SlotValue_EncryptedSlotValue_Fragment
    | SlotValue_PlainSlotValue_Fragment
    | undefined;
};

/**
 * Komponente zur Anzeige und Steuerung des Freigabestatus eines Slotwerts.
 * Zeigt den aktuellen Status an und ermöglicht das Freigeben oder Ablehnen.
 * @param ausfuehrungId ID der Ausführung
 * @param slotValue Der aktuelle Slotwert, der freigegeben werden kann
 * @param slots Liste der verfügbaren Slots zur Bestimmung der Freigabebedürftigkeit
 */
export const FreigabeStatus: FC<FreigabeStatus> = ({
  ausfuehrungId,
  slotValue,
  slots,
}) => {
  const slot = slots.find((s) => s.name === slotValue?.slotName);

  const feldBenoetigtFreigabe =
    slot?.brauchtFreigabe && !slotValue?.istFreigegeben;

  const aktivAbgelehnt = slotValue?.istFreigegeben == false;

  const [, ausfuehrungQuery] = useAusfuehrungQuery({
    variables: {
      ausfuehrungId: ausfuehrungId,
    },
  });

  const [, updateIstFreigegebenSlotValue] =
    useUpdateIstFreigegebenSlotValueMutation();

  const updateSlotValue = async (istFreigegeben: boolean) => {
    const result = await updateIstFreigegebenSlotValue({
      input: {
        ausfuehrungId: ausfuehrungId,
        istFreigegeben: istFreigegeben,
        slotValueId: slotValue?.id ?? '',
      },
    });
    if (
      mutationFailed(result) ||
      !result.data!.updateIstFreigegebenSlotValue.ausfuehrung
    ) {
      return;
    }
    ausfuehrungQuery({requestPolicy: 'cache-and-network'});
  };

  return (
    <div>
      <div className='font-bold'>Status:</div>
      {feldBenoetigtFreigabe ? (
        <div className='flex shrink flex-col flex-wrap  gap-4'>
          {aktivAbgelehnt ? (
            <div>Abgelehnt</div>
          ) : (
            <div>Bilder benötigen eine Freigabe durch einen Sachbearbeiter</div>
          )}
          <div className='flex flex-wrap gap-2'>
            {!aktivAbgelehnt && (
              <Button
                className='bg-red-500 active:text-white'
                variant='solid'
                onClick={() => updateSlotValue(false)}
              >
                Nicht freigeben
              </Button>
            )}
            <Button variant='outlined' onClick={() => updateSlotValue(true)}>
              Freigeben
            </Button>
          </div>
        </div>
      ) : (
        <div className='text-green-500'>Freigegeben</div>
      )}
    </div>
  );
};

import {type FC} from 'react';
import {toast} from 'react-toastify';
import {Modal} from 'src/components/modal/modal';
import {Button} from 'src/components/ui/button';
import {mutationFailed} from 'src/lib/mutation';
import {useAntragWiederherstellenMutation} from './papierkorb.generated';

type AntragWiederherstellenProps = {
  ausfuehrungId: string;
  onOpenChange: (open: boolean) => void;
  onWiederhergestellt: (success: boolean) => void;
};

export const AntragWiederherstellen: FC<AntragWiederherstellenProps> = ({
  ausfuehrungId,
  onOpenChange,
  onWiederhergestellt,
}) => {
  const [{fetching}, wiederherstellen] = useAntragWiederherstellenMutation();

  const onConfirm = async () => {
    const result = await wiederherstellen({input: {ausfuehrungId}});
    if (mutationFailed(result)) return;
    const errors = result.data!.antragWiederherstellen.errors;
    if (errors && errors.length > 0) {
      onOpenChange(false);
      onWiederhergestellt(false);
      return;
    }
    toast.success('Antrag wiederhergestellt.');
    onOpenChange(false);
    onWiederhergestellt(true);
  };

  return (
    <Modal title='Antrag wiederherstellen'>
      <div className='flex flex-col gap-4'>
        <p className='text-gray-600'>
          Der Antrag erscheint danach wieder in der Antragsübersicht (je nach
          Status unter Neu, In Bearbeitung oder Abgeschlossen).
        </p>
        <div className='flex justify-end gap-3'>
          <Button
            variant='text-secondary'
            onClick={() => onOpenChange(false)}
            disabled={fetching}
          >
            Abbrechen
          </Button>
          <Button variant='solid' onClick={onConfirm} disabled={fetching}>
            Wiederherstellen
          </Button>
        </div>
      </div>
    </Modal>
  );
};

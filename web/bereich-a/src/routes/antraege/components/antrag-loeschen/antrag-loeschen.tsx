import {type FC, useState} from 'react';
import {useNavigate} from 'react-router';
import {toast} from 'react-toastify';
import {Modal} from 'src/components/modal/modal';
import {Button} from 'src/components/ui/button';
import {mutationFailed} from 'src/lib/mutation';
import {useAntragSoftLoeschenMutation} from './antrag-loeschen.generated';

type AntragLoeschenProps = {
  ausfuehrungId: string;
  onOpenChange: (open: boolean) => void;
};

/**
 * Modal-Inhalt zum Soft-Löschen eines Antrags (Berechtigung "Anträge löschen" erforderlich).
 * Verlangt einen Pflicht-Löschgrund. Bei Erfolg wird zur Antragsliste navigiert.
 * Muss innerhalb einer `Dialog.Root` gerendert werden (analog zu AusfuehrungWeiterleiten).
 */
export const AntragLoeschen: FC<AntragLoeschenProps> = ({
  ausfuehrungId,
  onOpenChange,
}) => {
  const [grund, setGrund] = useState('');
  const [{fetching}, loeschen] = useAntragSoftLoeschenMutation();
  const navigate = useNavigate();

  const onConfirm = async () => {
    if (!grund.trim()) {
      toast.error('Bitte einen Löschgrund angeben.');
      return;
    }
    const result = await loeschen({
      input: {ausfuehrungId, grund: grund.trim()},
    });
    if (mutationFailed(result)) return;
    const errors = result.data!.antragSoftLoeschen.errors;
    if (errors && errors.length > 0) {
      return;
    }
    toast.success('Antrag gelöscht.');
    onOpenChange(false);
    navigate('/antraege/neu');
  };

  return (
    <Modal title='Antrag löschen'>
      <div className='flex flex-col gap-4'>
        <p className='text-gray-600'>
          Der Antrag wird ausgeblendet und nach Ablauf der konfigurierten
          Karenzzeit endgültig gelöscht. Bis dahin kann er von berechtigten
          Nutzer:innen wiederhergestellt werden.
        </p>
        <label className='flex flex-col gap-1'>
          <span className='font-medium'>Löschgrund (Pflicht)</span>
          <textarea
            value={grund}
            onChange={(e) => setGrund(e.target.value)}
            rows={3}
            className='rounded-md border border-gray-300 px-3 py-2'
            placeholder='z. B. Doppelt eingereichter, fehlerfreier Antrag'
          />
        </label>
        <div className='flex justify-end gap-3'>
          <Button
            variant='text-secondary'
            onClick={() => onOpenChange(false)}
            disabled={fetching}
          >
            Abbrechen
          </Button>
          <Button variant='destructive' onClick={onConfirm} disabled={fetching}>
            Löschen
          </Button>
        </div>
      </div>
    </Modal>
  );
};

import * as Dialog from '@radix-ui/react-dialog';
import {type FC, type ReactNode, useState} from 'react';
import {
  ExterneStelle,
  type MeldungKlasse,
} from '../../../__generated__/graphql.ts';
import {Modal} from '../../../components/modal/modal.tsx';
import {Button} from '../../../components/ui/button';
import {
  KLASSEN,
  type Meldung,
  externeStelleLabel,
  klassenLabel,
  nummer,
  titel,
} from './meldung.ts';
import {type Einsatzleitung} from './use-lage-dashboard.ts';

const EXTERN_PREFIX = 'extern:';
export const ZIEL_STELLEN = [ExterneStelle.Bauhof, ExterneStelle.Thw];

export type Ziel =
  | {art: 'einsatzleitung'; id: string}
  | {art: 'extern'; stelle: ExterneStelle};

export const parseZiel = (value: string): Ziel =>
  value.startsWith(EXTERN_PREFIX)
    ? {
        art: 'extern',
        stelle: value.slice(EXTERN_PREFIX.length) as ExterneStelle,
      }
    : {art: 'einsatzleitung', id: value};

/** Other Einsatzleitungen first, then the external bodies the Leitstelle can hand over to. */
export const ZielOptionen: FC<{
  einsatzleitungen: Einsatzleitung[];
  ausser?: string | null;
  /** The Einsatzleitung a report came back from: still selectable, marked as sending it back. */
  zurueck?: string | null;
}> = ({einsatzleitungen, ausser, zurueck}) => (
  <>
    <optgroup label='Einsatzleitung'>
      {einsatzleitungen
        .filter((el) => el.id !== ausser)
        .map((el) => (
          <option key={el.id} value={el.id}>
            {el.id === zurueck ? `${el.name} (zurück)` : el.name}
          </option>
        ))}
    </optgroup>
    <optgroup label='Externe Stelle (schließt das Ereignis)'>
      {ZIEL_STELLEN.map((s) => (
        <option key={s} value={`${EXTERN_PREFIX}${s}`}>
          {externeStelleLabel[s]}
        </option>
      ))}
    </optgroup>
  </>
);

export const DialogRahmen: FC<{
  title: string;
  onClose: () => void;
  children: ReactNode;
}> = ({title, onClose, children}) => (
  <Dialog.Root open onOpenChange={(open) => !open && onClose()}>
    <Modal title={title} className='max-w-xl' global>
      <div className='flex flex-col gap-4 py-2'>{children}</div>
    </Modal>
  </Dialog.Root>
);

const Aktionen: FC<{
  onClose: () => void;
  confirmText: string;
  disabled?: boolean;
  destructive?: boolean;
}> = ({onClose, confirmText, disabled, destructive}) => (
  <div className='flex gap-3'>
    <Button
      type='submit'
      variant={destructive ? 'destructive' : 'solid'}
      disabled={disabled}
      className='flex-1'
    >
      {confirmText}
    </Button>
    <Button
      type='button'
      variant='outlined'
      className='flex-1'
      onClick={onClose}
    >
      Abbrechen
    </Button>
  </div>
);

export const BegruendungDialog: FC<{
  meldung: Meldung;
  title: string;
  confirmText: string;
  onClose: () => void;
  onSubmit: (begruendung: string) => Promise<boolean>;
}> = ({meldung, title, confirmText, onClose, onSubmit}) => {
  const [text, setText] = useState('');
  return (
    <DialogRahmen title={title} onClose={onClose}>
      <form
        className='flex flex-col gap-4'
        onSubmit={async (e) => {
          e.preventDefault();
          if (await onSubmit(text.trim())) onClose();
        }}
      >
        <p>
          <strong>{nummer(meldung)}</strong> · {titel(meldung)}
        </p>
        <label className='flex flex-col gap-1'>
          <span className='font-semibold'>Begründung (Pflicht)</span>
          <textarea
            required
            autoFocus
            rows={3}
            value={text}
            onChange={(e) => setText(e.target.value)}
            className='rounded-md border border-gray-300 p-2'
            placeholder='z. B. doppelt gemeldet, bereits erledigt'
          />
        </label>
        <p className='text-sm text-gray-700'>
          Bürger:innen sehen danach „Abgeschlossen“, die Begründung nicht.
        </p>
        <Aktionen
          onClose={onClose}
          confirmText={confirmText}
          disabled={!text.trim()}
          destructive
        />
      </form>
    </DialogRahmen>
  );
};

export const UmverteilenDialog: FC<{
  meldung: Meldung;
  einsatzleitungen: Einsatzleitung[];
  onClose: () => void;
  onSubmit: (ziel: Ziel) => Promise<boolean>;
}> = ({meldung, einsatzleitungen, onClose, onSubmit}) => {
  const aktuelle = meldung.istZustaendigkeit.mitarbeiterGruppeId;
  const [ziel, setZiel] = useState(
    einsatzleitungen.find((el) => el.id !== aktuelle)?.id ?? '',
  );
  return (
    <DialogRahmen title='Umverteilen' onClose={onClose}>
      <form
        className='flex flex-col gap-4'
        onSubmit={async (e) => {
          e.preventDefault();
          if (ziel && (await onSubmit(parseZiel(ziel)))) onClose();
        }}
      >
        <p>
          <strong>{nummer(meldung)}</strong> · {titel(meldung)}
        </p>
        <label className='flex flex-col gap-1'>
          <span className='font-semibold'>Neu zuweisen an</span>
          <select
            value={ziel}
            onChange={(e) => setZiel(e.target.value)}
            className='min-h-10 rounded-md border border-gray-300 px-2'
          >
            <ZielOptionen
              einsatzleitungen={einsatzleitungen}
              ausser={aktuelle}
            />
          </select>
        </label>
        <Aktionen onClose={onClose} confirmText='Zuweisen' disabled={!ziel} />
      </form>
    </DialogRahmen>
  );
};

export const BearbeitenDialog: FC<{
  meldung: Meldung;
  bekannteAusruestung: string[];
  onClose: () => void;
  onSubmit: (klasse: MeldungKlasse, ausruestung: string[]) => Promise<boolean>;
}> = ({meldung, bekannteAusruestung, onClose, onSubmit}) => {
  const [klasse, setKlasse] = useState<MeldungKlasse>(
    meldung.klasse ?? KLASSEN[3],
  );
  const [ausruestung, setAusruestung] = useState<string[]>(
    meldung.benoetigteAusruestung ?? [],
  );
  const optionen = [
    ...new Set([...bekannteAusruestung, ...ausruestung]),
  ].sort();
  return (
    <DialogRahmen title='Einschätzung bearbeiten' onClose={onClose}>
      <form
        className='flex flex-col gap-4'
        onSubmit={async (e) => {
          e.preventDefault();
          if (await onSubmit(klasse, ausruestung)) onClose();
        }}
      >
        <p>
          <strong>{nummer(meldung)}</strong> · {titel(meldung)}
        </p>
        <label className='flex flex-col gap-1'>
          <span className='font-semibold'>Klasse</span>
          <select
            value={klasse}
            onChange={(e) => setKlasse(e.target.value as MeldungKlasse)}
            className='min-h-10 rounded-md border border-gray-300 px-2'
          >
            {KLASSEN.map((k) => (
              <option key={k} value={k}>
                {klassenLabel[k]}
              </option>
            ))}
          </select>
        </label>
        <fieldset className='flex flex-col gap-1'>
          <legend className='font-semibold'>Benötigte Ausrüstung</legend>
          <div className='flex flex-wrap gap-x-4 gap-y-1'>
            {optionen.map((a) => (
              <label key={a} className='flex items-center gap-2'>
                <input
                  type='checkbox'
                  checked={ausruestung.includes(a)}
                  onChange={(e) =>
                    setAusruestung((alt) =>
                      e.target.checked
                        ? [...alt, a]
                        : alt.filter((x) => x !== a),
                    )
                  }
                />
                {a}
              </label>
            ))}
          </div>
        </fieldset>
        <p className='text-sm text-gray-700'>
          Kategorie, Beschreibung und Ort kommen aus der Meldung der
          Bürger:innen und lassen sich hier nicht ändern.
        </p>
        <Aktionen onClose={onClose} confirmText='Speichern' />
      </form>
    </DialogRahmen>
  );
};

import {type FC, useState} from 'react';
import {Button} from '../../../components/ui/button';
import {type DashboardEinheitFragment} from './dashboard.generated.ts';
import {DialogRahmen} from './dialoge.tsx';
import {AUSRUESTUNG} from './meldung.ts';
import {type MeldungAktionen} from './use-meldung-aktionen.ts';

type Einheit = DashboardEinheitFragment;

const AusruestungAuswahl: FC<{
  legend: string;
  value: string[];
  onChange: (value: string[]) => void;
}> = ({legend, value, onChange}) => {
  const optionen = [...new Set([...AUSRUESTUNG, ...value])];
  return (
    <fieldset className='flex flex-col gap-1'>
      <legend className='text-sm font-semibold'>{legend}</legend>
      <div className='flex flex-wrap gap-x-4 gap-y-1'>
        {optionen.map((a) => (
          <label key={a} className='flex items-center gap-2 text-sm'>
            <input
              type='checkbox'
              checked={value.includes(a)}
              onChange={(e) =>
                onChange(
                  e.target.checked
                    ? [...value, a]
                    : value.filter((x) => x !== a),
                )
              }
            />
            {a}
          </label>
        ))}
      </div>
    </fieldset>
  );
};

const gleich = (a: string[], b: string[]) =>
  a.length === b.length && a.every((x) => b.includes(x));

const EinheitZeile: FC<{
  einheit: Einheit;
  auftraege: number;
  aktionen: MeldungAktionen;
}> = ({einheit, auftraege, aktionen}) => {
  const [name, setName] = useState(einheit.name);
  const [ausruestung, setAusruestung] = useState(einheit.ausruestung);
  const [loeschenFragen, setLoeschenFragen] = useState(false);
  const geaendert =
    name.trim() !== einheit.name || !gleich(ausruestung, einheit.ausruestung);

  return (
    <li className='flex flex-col gap-3 rounded-xl border border-gray-200 p-3'>
      <form
        className='flex flex-col gap-3'
        onSubmit={(e) => {
          e.preventDefault();
          void aktionen.einheitAendern(einheit.id, name, ausruestung);
        }}
      >
        <label className='flex flex-col gap-1'>
          <span className='text-sm font-semibold'>Name</span>
          <input
            required
            value={name}
            onChange={(e) => setName(e.target.value)}
            className='min-h-10 rounded-md border border-gray-300 px-2'
          />
        </label>
        <AusruestungAuswahl
          legend='Ausrüstung an Bord'
          value={ausruestung}
          onChange={setAusruestung}
        />
        <div className='flex flex-wrap items-center gap-3'>
          <Button
            type='submit'
            variant='outlined-secondary'
            disabled={!geaendert || !name.trim()}
          >
            Speichern
          </Button>
          {loeschenFragen ? (
            <span className='flex flex-wrap items-center gap-2 text-sm'>
              {auftraege > 0
                ? `${auftraege} Ereignis${
                    auftraege > 1 ? 'se gehen' : ' geht'
                  } zurück in den Eingang.`
                : 'Wirklich löschen?'}
              <Button
                type='button'
                variant='destructive'
                onClick={() => void aktionen.einheitLoeschen(einheit.id)}
              >
                Löschen
              </Button>
              <Button
                type='button'
                variant='text-secondary'
                onClick={() => setLoeschenFragen(false)}
              >
                Abbrechen
              </Button>
            </span>
          ) : (
            <Button
              type='button'
              variant='text-secondary'
              onClick={() => setLoeschenFragen(true)}
            >
              Löschen …
            </Button>
          )}
        </div>
      </form>
    </li>
  );
};

const NeueEinheit: FC<{
  gruppeId: string;
  aktionen: MeldungAktionen;
}> = ({gruppeId, aktionen}) => {
  const [name, setName] = useState('');
  const [standard, setStandard] = useState(true);
  const [ausruestung, setAusruestung] = useState<string[]>([]);

  return (
    <form
      className='flex flex-col gap-3 rounded-xl border border-dashed border-gray-300 p-3'
      onSubmit={async (e) => {
        e.preventDefault();
        if (
          await aktionen.einheitAnlegen(
            gruppeId,
            name,
            standard ? null : ausruestung,
          )
        ) {
          setName('');
          setAusruestung([]);
        }
      }}
    >
      <h3 className='font-bold'>Neue Einheit</h3>
      <label className='flex flex-col gap-1'>
        <span className='text-sm font-semibold'>Name</span>
        <input
          required
          value={name}
          onChange={(e) => setName(e.target.value)}
          placeholder='z. B. HLF 20 Hameln'
          className='min-h-10 rounded-md border border-gray-300 px-2'
        />
      </label>
      <label className='flex items-center gap-2 text-sm'>
        <input
          type='checkbox'
          checked={standard}
          onChange={(e) => setStandard(e.target.checked)}
        />
        Ausrüstung nach Fahrzeugtyp vorbelegen (HLF, LF, TLF, DLK, RW, MTW,
        GW-L, RL)
      </label>
      {!standard && (
        <AusruestungAuswahl
          legend='Ausrüstung an Bord'
          value={ausruestung}
          onChange={setAusruestung}
        />
      )}
      <div>
        <Button
          type='submit'
          variant='outlined-secondary'
          disabled={!name.trim()}
        >
          Anlegen
        </Button>
      </div>
    </form>
  );
};

/** Lets the Einsatzleitung (or the Leitstelle on its behalf) keep its units and their equipment current. */
export const EinheitenDialog: FC<{
  einsatzleitungName: string;
  gruppeId: string;
  einheiten: Einheit[];
  auftraege: (einheit: Einheit) => number;
  aktionen: MeldungAktionen;
  onClose: () => void;
}> = ({
  einsatzleitungName,
  gruppeId,
  einheiten,
  auftraege,
  aktionen,
  onClose,
}) => (
  <DialogRahmen title={`Einheiten · ${einsatzleitungName}`} onClose={onClose}>
    <p className='text-sm text-gray-700'>
      Die Ausrüstung entscheidet, ob eine Einheit zu einem Ereignis „passt“.
    </p>
    {einheiten.length > 0 && (
      <ul className='flex flex-col gap-3'>
        {einheiten.map((einheit) => (
          <EinheitZeile
            // Remount after a save so the form starts from the stored values.
            key={`${einheit.id}:${einheit.name}:${einheit.ausruestung.join()}`}
            einheit={einheit}
            auftraege={auftraege(einheit)}
            aktionen={aktionen}
          />
        ))}
      </ul>
    )}
    <NeueEinheit gruppeId={gruppeId} aktionen={aktionen} />
    <Button type='button' variant='outlined-secondary' onClick={onClose}>
      Schließen
    </Button>
  </DialogRahmen>
);

import {type DragEvent, type FC, useMemo, useState} from 'react';
import {twMerge} from 'tailwind-merge';
import {
  AbgabeGrund,
  EreignisStatus,
  MeldungKlasse,
} from '../../../__generated__/graphql.ts';
import {useConfirm} from '../../../components/modal/confirm-modal.tsx';
import {Button} from '../../../components/ui/button';
import {Badge, Kennzahlen, MeldungBadges, Panel} from './dashboard-ui.tsx';
import {type DashboardEinheitFragment} from './dashboard.generated.ts';
import {EinheitenDialog} from './einheiten-dialog.tsx';
import {
  GebietLegende,
  type KartenMarker,
  LageKarte,
  liveGebietIds,
} from './lage-karte.tsx';
import {
  LANGE_WARTEZEIT_MS,
  type Meldung,
  abgabeGrundLabel,
  fehlendeAusruestung,
  formatDauer,
  kategorie,
  kategorieFarben,
  koordinaten,
  nachDringlichkeit,
  nummer,
  ort,
  titel,
  wartetMs,
} from './meldung.ts';
import {type LageDashboardData, useNow} from './use-lage-dashboard.ts';
import {type MeldungAktionen} from './use-meldung-aktionen.ts';

const DRAG_TYPE = 'application/x-deich-meldung';

const FILTER_ALLE = 'Alle';
const FILTER_KLASSE_A = 'Klasse A';
const FILTER_PLUS = '+1 ab 3';

const imEinsatz = (m: Meldung) =>
  m.ereignisStatus === EreignisStatus.Zugewiesen ||
  m.ereignisStatus === EreignisStatus.InBearbeitung;

const zuweisbar = (m?: Meldung) =>
  m !== undefined &&
  (m.ereignisStatus === EreignisStatus.Eingegangen ||
    (imEinsatz(m) && !m.einheit));

export const EinsatzleitungAnsicht: FC<{
  data: LageDashboardData;
  gruppeId: string;
  aktionen: MeldungAktionen;
}> = ({data, gruppeId, aktionen}) => {
  const now = useNow();
  const confirm = useConfirm();
  const [filter, setFilter] = useState(FILTER_ALLE);
  const [ausgewaehlt, setAusgewaehlt] = useState<string | null>(null);
  const [gezogen, setGezogen] = useState<string | null>(null);
  const [dropZielId, setDropZielId] = useState<string | null>(null);
  const [abgabeOffen, setAbgabeOffen] = useState<string | null>(null);
  const [einheitenOffen, setEinheitenOffen] = useState(false);

  const einsatzleitung = data.einsatzleitungen.find((e) => e.id === gruppeId);
  const eigene = useMemo(
    () =>
      data.meldungen.filter(
        (m) => m.istZustaendigkeit.mitarbeiterGruppeId === gruppeId,
      ),
    [data.meldungen, gruppeId],
  );
  const farbe = useMemo(
    () => kategorieFarben(data.meldungen.map(kategorie)),
    [data.meldungen],
  );
  const live = useMemo(() => liveGebietIds(data.lage), [data.lage]);
  const eingang = useMemo(
    () =>
      eigene
        .filter((m) => m.ereignisStatus === EreignisStatus.Eingegangen)
        .sort(nachDringlichkeit),
    [eigene],
  );
  // Moved on in the process view ("Einsatz läuft") without an Einheit, so neither Eingang nor a unit lists them.
  const ohneEinheit = useMemo(
    () =>
      eigene.filter((m) => imEinsatz(m) && !m.einheit).sort(nachDringlichkeit),
    [eigene],
  );
  const kategorien = [...new Set(eingang.map(kategorie))].sort();
  const filter_ = (m: Meldung) =>
    filter === FILTER_ALLE ||
    (filter === FILTER_KLASSE_A && m.klasse === MeldungKlasse.A) ||
    (filter === FILTER_PLUS && m.anzahlBestaetigungen >= 3) ||
    kategorie(m) === filter;
  const sichtbar = eingang.filter(filter_);

  const einheiten = data.einheiten.filter(
    (e) => e.mitarbeiterGruppeId === gruppeId,
  );
  const auftraege = (einheit: DashboardEinheitFragment) =>
    eigene.filter((m) => imEinsatz(m) && m.einheit?.id === einheit.id);

  const aktivId = gezogen ?? ausgewaehlt ?? eingang[0]?.id ?? null;
  const aktiv = eigene.find((m) => m.id === aktivId);

  const zuweisen = async (
    meldungId: string,
    einheit: DashboardEinheitFragment,
  ) => {
    const meldung = eigene.find((m) => m.id === meldungId);
    if (!meldung || meldung.einheit?.id === einheit.id) return;
    const fehlt = fehlendeAusruestung(meldung, einheit);
    if (
      fehlt.length > 0 &&
      !(await confirm({
        title: 'Ausrüstung fehlt',
        content: `${einheit.name} hat ${fehlt.join(
          ', ',
        )} nicht an Bord. ${nummer(meldung)} trotzdem zuweisen?`,
        confirmText: 'Trotzdem zuweisen',
      }))
    ) {
      return;
    }
    if (await aktionen.zuweisen(meldung.id, einheit.id)) setAusgewaehlt(null);
  };

  const onDragStart = (e: DragEvent, id: string) => {
    e.dataTransfer.setData(DRAG_TYPE, id);
    e.dataTransfer.effectAllowed = 'move';
    setGezogen(id);
    setDropZielId(null);
  };
  const dropTarget = (zielId: string, onDrop: (id: string) => void) => ({
    onDragOver: (e: DragEvent) => {
      if (!e.dataTransfer.types.includes(DRAG_TYPE)) return;
      e.preventDefault();
      setDropZielId(zielId);
    },
    onDragLeave: (e: DragEvent) => {
      if (!e.currentTarget.contains(e.relatedTarget as Node | null))
        setDropZielId((aktuell) => (aktuell === zielId ? null : aktuell));
    },
    onDrop: (e: DragEvent) => {
      e.preventDefault();
      setDropZielId(null);
      const id = e.dataTransfer.getData(DRAG_TYPE);
      setGezogen(null);
      if (id) onDrop(id);
    },
  });

  const karte = (m: Meldung) => (
    <EingangKarte
      key={m.id}
      meldung={m}
      farbe={farbe}
      now={now}
      aktiv={m.id === aktivId}
      abgabeOffen={abgabeOffen === m.id}
      onSelect={() => setAusgewaehlt(m.id)}
      onDragStart={(e) => onDragStart(e, m.id)}
      onDragEnd={() => setGezogen(null)}
      onAbgabeOeffnen={() => setAbgabeOffen(m.id)}
      onAbgabeSchliessen={() => setAbgabeOffen(null)}
      onAbgeben={async (grund, kommentar) => {
        if (await aktionen.abgeben(m.id, grund, kommentar))
          setAbgabeOffen(null);
      }}
    />
  );

  const marker: KartenMarker[] = eigene
    .filter(
      (m) => m.ereignisStatus === EreignisStatus.Eingegangen || imEinsatz(m),
    )
    .flatMap((m) => {
      const pos = koordinaten(m);
      return pos
        ? [
            {
              id: m.id,
              lng: pos[0],
              lat: pos[1],
              label: nummer(m),
              zahl: m.anzahlBestaetigungen,
              farbe: farbe(kategorie(m)).color,
              ausgewaehlt: m.id === aktivId,
            },
          ]
        : [];
    });
  const eigeneGebiete = data.gebiete.filter((g) =>
    g.einsatzleitungen.some((el) => el.id === gruppeId),
  );

  return (
    <div className='flex flex-col gap-5 p-6'>
      <div className='flex flex-wrap items-end justify-between gap-4'>
        <div>
          <h1 className='text-2xl font-bold'>
            {einsatzleitung?.name ?? 'Einsatzleitung'}
          </h1>
          <p className='text-gray-700'>
            {einsatzleitung?.gebiete.join(', ') || 'Kein Gebiet zugeordnet'}
          </p>
        </div>
        <Kennzahlen
          werte={[
            {label: 'neu', wert: eingang.length},
            {
              label: 'zugewiesen',
              wert: eigene.filter(
                (m) => m.ereignisStatus === EreignisStatus.Zugewiesen,
              ).length,
            },
            {
              label: 'in Bearbeitung',
              wert: eigene.filter(
                (m) => m.ereignisStatus === EreignisStatus.InBearbeitung,
              ).length,
            },
            {
              label: 'erledigt',
              wert: eigene.filter(
                (m) => m.ereignisStatus === EreignisStatus.Erledigt,
              ).length,
            },
          ]}
        />
      </div>

      <div className='grid gap-5 xl:grid-cols-[minmax(0,1fr)_minmax(0,1.2fr)_minmax(0,1fr)]'>
        <Panel
          labelledBy='eingang'
          title={`Eingang · ${eingang.length} Ereignisse`}
          hinweis='sortiert nach Klasse, +1, Wartezeit'
        >
          <div
            role='group'
            aria-label='Filter'
            className='flex flex-wrap gap-2'
          >
            {[FILTER_ALLE, FILTER_KLASSE_A, ...kategorien, FILTER_PLUS].map(
              (f) => (
                <button
                  key={f}
                  type='button'
                  aria-pressed={filter === f}
                  onClick={() => setFilter(f)}
                  className={twMerge(
                    'min-h-9 rounded-full border px-3 text-sm',
                    filter === f
                      ? 'border-gray-900 bg-gray-900 text-white'
                      : 'border-gray-300 bg-white',
                  )}
                >
                  {f}
                </button>
              ),
            )}
          </div>
          <p className='text-xs text-gray-700'>
            Ereignis antippen oder ziehen: Passende Einheiten werden grün,
            unpassende rot. Zurück in den Eingang: Ereignis hierher ziehen.
          </p>
          <div
            className='flex min-h-24 flex-col gap-3'
            {...dropTarget('eingang', (id) => {
              const m = eigene.find((x) => x.id === id);
              if (m?.einheit) void aktionen.zuweisen(id, null);
            })}
          >
            {sichtbar.length === 0 && (
              <p className='rounded-lg border border-dashed border-gray-300 p-4 text-center text-sm text-gray-700'>
                Keine neuen Ereignisse.
              </p>
            )}
            {sichtbar.map(karte)}
          </div>
          {ohneEinheit.length > 0 && (
            <section
              aria-labelledby='ohne-einheit'
              className='flex flex-col gap-3 border-t border-gray-200 pt-3'
            >
              <h3 id='ohne-einheit' className='font-bold'>
                Läuft ohne Einheit · {ohneEinheit.length}
              </h3>
              <p className='text-xs text-gray-700'>
                Im Vorgang weitergeschaltet, aber keiner Einheit zugewiesen. Zum
                Zuweisen auf eine Einheit ziehen.
              </p>
              {ohneEinheit.map(karte)}
            </section>
          )}
        </Panel>

        <Panel
          labelledBy='karte'
          title='Karte'
          hinweis='OpenStreetMap · Zuständigkeitsgebiet'
        >
          <LageKarte
            gebiete={eigeneGebiete}
            live={live}
            marker={marker}
            onMarkerClick={setAusgewaehlt}
          />
          <div className='flex flex-wrap gap-4 text-xs text-gray-700'>
            <GebietLegende />
            {[
              ...new Set(
                marker.map((mk) =>
                  kategorie(eigene.find((m) => m.id === mk.id)!),
                ),
              ),
            ]
              .sort()
              .map((k) => (
                <span key={k} className='flex items-center gap-1.5'>
                  <span
                    aria-hidden
                    className={twMerge('size-3 rounded-full', farbe(k).marker)}
                  />
                  {k}
                </span>
              ))}
            <span>Zahl im Punkt = Anzahl +1</span>
          </div>
        </Panel>

        <section
          aria-labelledby='einheiten'
          className='flex min-w-0 flex-col gap-3'
        >
          <div className='flex flex-wrap items-baseline justify-between gap-2'>
            <div className='flex items-baseline gap-3'>
              <h2 id='einheiten' className='text-base font-bold'>
                Einheiten
              </h2>
              <Button
                type='button'
                variant='text-secondary'
                className='p-0 text-sm underline'
                onClick={() => setEinheitenOffen(true)}
              >
                Verwalten
              </Button>
            </div>
            {aktiv && zuweisbar(aktiv) ? (
              <span className='text-xs text-gray-700'>
                {gezogen ? 'Gezogen' : 'Ausgewählt'}:{' '}
                <strong>{nummer(aktiv)}</strong> · braucht{' '}
                {aktiv.benoetigteAusruestung?.join(', ') || 'nichts Besonderes'}
              </span>
            ) : (
              <span className='text-xs text-gray-700'>
                Ereignis auf Einheit ziehen
              </span>
            )}
          </div>
          {einheiten.length === 0 && (
            <p className='rounded-xl border border-dashed border-gray-300 bg-white p-4 text-sm text-gray-700'>
              Diese Einsatzleitung hat noch keine Einheiten.{' '}
              <button
                type='button'
                className='font-semibold underline'
                onClick={() => setEinheitenOffen(true)}
              >
                Einheit anlegen
              </button>
            </p>
          )}
          {einheiten.map((einheit) => (
            <EinheitKachel
              key={einheit.id}
              einheit={einheit}
              auftraege={auftraege(einheit)}
              pruefen={zuweisbar(aktiv) ? aktiv : undefined}
              dropProps={dropTarget(
                einheit.id,
                (id) => void zuweisen(id, einheit),
              )}
              dropAktiv={gezogen !== null && dropZielId === einheit.id}
              onKlick={() => aktiv && void zuweisen(aktiv.id, einheit)}
              onDragStart={onDragStart}
              onDragEnd={() => setGezogen(null)}
              aktionen={aktionen}
            />
          ))}
        </section>
      </div>
      {einheitenOffen && (
        <EinheitenDialog
          einsatzleitungName={einsatzleitung?.name ?? 'Einsatzleitung'}
          gruppeId={gruppeId}
          einheiten={einheiten}
          auftraege={(einheit) => auftraege(einheit).length}
          aktionen={aktionen}
          onClose={() => setEinheitenOffen(false)}
        />
      )}
    </div>
  );
};

const EingangKarte: FC<{
  meldung: Meldung;
  farbe: ReturnType<typeof kategorieFarben>;
  now: number;
  aktiv: boolean;
  abgabeOffen: boolean;
  onSelect: () => void;
  onDragStart: (e: DragEvent) => void;
  onDragEnd: () => void;
  onAbgabeOeffnen: () => void;
  onAbgabeSchliessen: () => void;
  onAbgeben: (grund: AbgabeGrund, kommentar: string) => Promise<void>;
}> = ({
  meldung,
  farbe,
  now,
  aktiv,
  abgabeOffen,
  onSelect,
  onDragStart,
  onDragEnd,
  onAbgabeOeffnen,
  onAbgabeSchliessen,
  onAbgeben,
}) => {
  const wartet = wartetMs(meldung, now);
  return (
    <article
      draggable
      onDragStart={onDragStart}
      onDragEnd={onDragEnd}
      className={twMerge(
        'flex cursor-grab flex-col gap-2 rounded-lg border bg-white p-3',
        aktiv ? 'border-2 border-gray-900' : 'border-gray-300',
      )}
    >
      <div
        role='button'
        tabIndex={0}
        aria-pressed={aktiv}
        onClick={onSelect}
        onKeyDown={(e) => {
          if (e.key === 'Enter' || e.key === ' ') {
            e.preventDefault();
            onSelect();
          }
        }}
        className='flex flex-col gap-2 focus:outline-none'
      >
        <div className='flex items-start gap-2'>
          <div className='flex flex-1 flex-wrap items-center gap-2'>
            <MeldungBadges meldung={meldung} farbe={farbe} />
          </div>
          <Badge className='shrink-0 bg-gray-100 text-gray-900'>
            +{meldung.anzahlBestaetigungen}
          </Badge>
        </div>
        <div className='font-semibold'>{titel(meldung)}</div>
        <div className='flex flex-wrap gap-3 text-sm text-gray-700'>
          <span>{ort(meldung)}</span>
          <span
            className={twMerge(
              wartet > LANGE_WARTEZEIT_MS && 'font-semibold text-warning-text',
            )}
          >
            wartet {formatDauer(wartet)}
          </span>
        </div>
        {meldung.benoetigteAusruestung &&
          meldung.benoetigteAusruestung.length > 0 && (
            <div className='flex flex-wrap items-center gap-2 text-sm'>
              <Badge className='bg-bedarf-surface text-bedarf-text'>
                Braucht
              </Badge>
              <span>{meldung.benoetigteAusruestung.join(', ')}</span>
            </div>
          )}
      </div>
      {abgabeOffen ? (
        <AbgabeFormular onAbbrechen={onAbgabeSchliessen} onSenden={onAbgeben} />
      ) : (
        <div>
          <button
            type='button'
            onClick={onAbgabeOeffnen}
            className='min-h-8 rounded-md border border-warning px-3 text-sm font-semibold text-warning-text hover:bg-warning-surface'
          >
            An Leitstelle abgeben
          </button>
        </div>
      )}
    </article>
  );
};

const AbgabeFormular: FC<{
  onAbbrechen: () => void;
  onSenden: (grund: AbgabeGrund, kommentar: string) => Promise<void>;
}> = ({onAbbrechen, onSenden}) => {
  const [grund, setGrund] = useState<AbgabeGrund | ''>('');
  const [kommentar, setKommentar] = useState('');
  const kommentarPflicht = grund === AbgabeGrund.Sonstiges;
  const gueltig = grund !== '' && (!kommentarPflicht || kommentar.trim());
  return (
    <form
      className='flex flex-col gap-2 rounded-lg bg-warning-surface p-3 text-sm'
      onSubmit={(e) => {
        e.preventDefault();
        if (grund) void onSenden(grund, kommentar.trim());
      }}
    >
      <label className='flex flex-col gap-1'>
        <span className='font-semibold'>
          Warum können wir es nicht übernehmen?
        </span>
        <select
          required
          value={grund}
          onChange={(e) => setGrund(e.target.value as AbgabeGrund)}
          className='min-h-9 rounded-md border border-gray-300 bg-white px-2'
        >
          <option value='' disabled>
            Grund wählen
          </option>
          {Object.values(AbgabeGrund).map((g) => (
            <option key={g} value={g}>
              {abgabeGrundLabel[g]}
            </option>
          ))}
        </select>
      </label>
      <label className='flex flex-col gap-1'>
        <span className='font-semibold'>
          Kommentar{kommentarPflicht ? ' (Pflicht)' : ' (freiwillig)'}
        </span>
        <input
          value={kommentar}
          required={kommentarPflicht}
          onChange={(e) => setKommentar(e.target.value)}
          placeholder='z. B. Radlader nötig'
          className='min-h-9 rounded-md border border-gray-300 bg-white px-2'
        />
      </label>
      <div className='flex gap-2'>
        <Button
          type='submit'
          variant='solid'
          disabled={!gueltig}
          className='bg-warning py-1'
        >
          An Leitstelle senden
        </Button>
        <Button
          type='button'
          variant='outlined-secondary'
          className='py-1'
          onClick={onAbbrechen}
        >
          Abbrechen
        </Button>
      </div>
    </form>
  );
};

const EinheitKachel: FC<{
  einheit: DashboardEinheitFragment;
  auftraege: Meldung[];
  pruefen?: Meldung;
  dropProps: {
    onDragOver: (e: DragEvent) => void;
    onDragLeave: (e: DragEvent) => void;
    onDrop: (e: DragEvent) => void;
  };
  dropAktiv: boolean;
  onKlick: () => void;
  onDragStart: (e: DragEvent, id: string) => void;
  onDragEnd: () => void;
  aktionen: MeldungAktionen;
}> = ({
  einheit,
  auftraege,
  pruefen,
  dropProps,
  dropAktiv,
  onKlick,
  onDragStart,
  onDragEnd,
  aktionen,
}) => {
  const fehlt = pruefen ? fehlendeAusruestung(pruefen, einheit) : [];
  const passt = pruefen && fehlt.length === 0;
  return (
    <div
      {...dropProps}
      className={twMerge(
        'flex flex-col gap-2 rounded-xl border bg-white p-3 transition-shadow',
        pruefen
          ? passt
            ? 'border-2 border-success'
            : 'border-2 border-danger'
          : 'border-gray-300',
        dropAktiv &&
          (passt
            ? 'bg-success-surface shadow-lg ring-4 ring-success/40'
            : 'bg-danger-surface shadow-lg ring-4 ring-danger/40'),
      )}
    >
      <div className='flex items-start gap-2'>
        <div className='min-w-0 flex-1'>
          <div className='font-bold'>{einheit.name}</div>
          <div className='text-xs text-gray-700'>
            An Bord: {einheit.ausruestung.join(', ') || '–'}
          </div>
          <div className='text-xs text-gray-700'>
            {auftraege.length > 0
              ? 'Status 4 · am Einsatzort'
              : 'Status 2 · frei auf Wache'}{' '}
            (aus ELS)
          </div>
        </div>
        {pruefen &&
          (passt ? (
            <Badge className='bg-success-surface text-success-text'>
              ✓ passt
            </Badge>
          ) : (
            <Badge className='bg-danger-surface text-danger-text'>
              ✗ fehlt: {fehlt.join(', ')}
            </Badge>
          ))}
      </div>
      {auftraege.map((m) => (
        <div
          key={m.id}
          draggable
          onDragStart={(e) => onDragStart(e, m.id)}
          onDragEnd={onDragEnd}
          className='flex cursor-grab flex-wrap items-center gap-2 rounded-lg bg-gray-50 p-2 text-sm'
        >
          <span className='text-gray-700'>{nummer(m)}</span>
          <span className='min-w-0 flex-1 truncate'>{titel(m)}</span>
          <span className='text-xs text-gray-700'>
            {m.ereignisStatus === EreignisStatus.InBearbeitung
              ? 'in Bearbeitung'
              : 'zugewiesen'}
          </span>
          {m.ereignisStatus === EreignisStatus.Zugewiesen && (
            <Button
              variant='outlined-secondary'
              className='px-2 py-1 text-xs'
              onClick={() => void aktionen.laeuft(m.id)}
            >
              Läuft
            </Button>
          )}
          <Button
            variant='outlined-secondary'
            className='px-2 py-1 text-xs font-semibold'
            onClick={() => void aktionen.erledigt(m.id)}
          >
            Erledigt
          </Button>
        </div>
      ))}
      {pruefen && (
        <button
          type='button'
          onClick={onKlick}
          className='min-h-9 rounded-lg border border-dashed border-gray-300 text-sm text-gray-700 hover:bg-gray-50'
        >
          {nummer(pruefen)} hierher zuweisen
        </button>
      )}
      {dropAktiv && pruefen && (
        <div
          aria-hidden
          className={twMerge(
            'rounded-lg border-2 border-dashed p-2 text-center text-sm font-semibold',
            passt
              ? 'border-success text-success-text'
              : 'border-danger text-danger-text',
          )}
        >
          Loslassen zum Zuweisen: {nummer(pruefen)}
        </div>
      )}
    </div>
  );
};

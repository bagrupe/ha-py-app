import {type FC, useMemo, useState} from 'react';
import {twMerge} from 'tailwind-merge';
import {
  EreignisStatus,
  NotfallPruefung,
} from '../../../__generated__/graphql.ts';
import {Button} from '../../../components/ui/button';
import {Badge, Kennzahlen, MeldungBadges, Panel} from './dashboard-ui.tsx';
import {
  BearbeitenDialog,
  BegruendungDialog,
  UmverteilenDialog,
  type Ziel,
  ZielOptionen,
  parseZiel,
} from './dialoge.tsx';
import {type KartenMarker, LageKarte} from './lage-karte.tsx';
import {
  LANGE_WARTEZEIT_MS,
  type Meldung,
  abgabeGrundLabel,
  externeStelleLabel,
  formatDauer,
  gemeinde,
  istOffen,
  kategorie,
  kategorieFarben,
  koordinaten,
  nachDringlichkeit,
  nummer,
  statusLabel,
  titel,
  wartetMs,
} from './meldung.ts';
import {type LageDashboardData, useNow} from './use-lage-dashboard.ts';
import {type MeldungAktionen} from './use-meldung-aktionen.ts';

const ALLE = 'alle';
type Tab = 'offen' | 'archiv';

type OffenerDialog = {
  art: 'verwerfen' | 'umverteilen' | 'bearbeiten';
  meldung: Meldung;
} | null;

export const LeitstelleAnsicht: FC<{
  data: LageDashboardData;
  aktionen: MeldungAktionen;
}> = ({data, aktionen}) => {
  const now = useNow();
  const [tab, setTab] = useState<Tab>('offen');
  const [elFilter, setElFilter] = useState(ALLE);
  const [dialog, setDialog] = useState<OffenerDialog>(null);
  const {meldungen, einsatzleitungen, einheiten} = data;

  const farbe = useMemo(
    () => kategorieFarben(meldungen.map(kategorie)),
    [meldungen],
  );
  const elName = (id?: string | null) =>
    einsatzleitungen.find((el) => el.id === id)?.name ?? '–';
  const anzahl = (status: EreignisStatus) =>
    meldungen.filter((m) => m.ereignisStatus === status).length;

  const offen = meldungen.filter(istOffen);
  const notfaelle = offen.filter(
    (m) => m.moeglicherNotfall && !m.notfallPruefung,
  );
  const klaerung = offen
    .filter((m) => m.ereignisStatus === EreignisStatus.InKlaerung)
    .sort(
      (a, b) =>
        (a.klaerungSeit?.getTime() ?? 0) - (b.klaerungSeit?.getTime() ?? 0),
    );

  const elKennzahlen = einsatzleitungen
    .map((el) => {
      const eigeneEinheiten = einheiten.filter(
        (e) => e.mitarbeiterGruppeId === el.id,
      );
      const belegt = new Set(
        offen
          .filter(
            (m) =>
              m.einheit &&
              (m.ereignisStatus === EreignisStatus.Zugewiesen ||
                m.ereignisStatus === EreignisStatus.InBearbeitung),
          )
          .map((m) => m.einheit!.id),
      );
      return {
        ...el,
        neu: offen.filter(
          (m) =>
            m.istZustaendigkeit.mitarbeiterGruppeId === el.id &&
            m.ereignisStatus === EreignisStatus.Eingegangen,
        ).length,
        frei: eigeneEinheiten.filter((e) => !belegt.has(e.id)).length,
        gesamt: eigeneEinheiten.length,
      };
    })
    .filter((el) => el.neu > 0 || el.gesamt > 0);

  const zuweisen = (meldung: Meldung, ziel: Ziel) =>
    ziel.art === 'einsatzleitung'
      ? aktionen.umverteilen(meldung.id, ziel.id)
      : aktionen.extern(meldung.id, ziel.stelle);

  const tabelle = meldungen
    .filter((m) => (tab === 'offen' ? istOffen(m) : !istOffen(m)))
    .filter(
      (m) =>
        elFilter === ALLE ||
        m.istZustaendigkeit.mitarbeiterGruppeId === elFilter,
    )
    .sort(
      tab === 'offen'
        ? nachDringlichkeit
        : (a, b) =>
            (b.abgeschlossenAm?.getTime() ?? 0) -
            (a.abgeschlossenAm?.getTime() ?? 0),
    );

  const marker: KartenMarker[] = offen.flatMap((m) => {
    const pos = koordinaten(m);
    return pos
      ? [
          {
            id: m.id,
            lng: pos[0],
            lat: pos[1],
            zahl: m.anzahlBestaetigungen,
            farbe: farbe(kategorie(m)).color,
            klaerung: m.ereignisStatus === EreignisStatus.InKlaerung,
            label:
              m.ereignisStatus === EreignisStatus.InKlaerung
                ? nummer(m)
                : undefined,
          },
        ]
      : [];
  });
  const bekannteAusruestung = [
    ...new Set(einheiten.flatMap((e) => e.ausruestung)),
  ];

  return (
    <div className='flex flex-col gap-5 p-6'>
      <h1 className='sr-only'>Leitstelle</h1>
      <Kennzahlen
        werte={[
          {label: 'neu', wert: anzahl(EreignisStatus.Eingegangen)},
          {
            label: 'in Arbeit',
            wert:
              anzahl(EreignisStatus.Zugewiesen) +
              anzahl(EreignisStatus.InBearbeitung),
          },
          {
            label: 'in Klärung',
            wert: klaerung.length,
            hervorheben: klaerung.length > 0,
          },
          {label: 'erledigt', wert: anzahl(EreignisStatus.Erledigt)},
        ]}
        rest={
          <>
            <span aria-hidden className='h-5 w-px bg-gray-300' />
            {elKennzahlen.map((el) => (
              <span key={el.id} className='text-gray-900'>
                {el.name.replace(/^Einsatzleitung /, '')}: {el.neu} neu ·{' '}
                {el.frei}/{el.gesamt} Einheiten frei
              </span>
            ))}
            <span aria-hidden className='h-5 w-px bg-gray-300' />
            <span title='Beispielwert, noch ohne Datenquelle'>
              B-Team: 4 Plätze besetzt · ≈ 4–5 Notrufplätze entlastet
            </span>
          </>
        }
      />

      {notfaelle.length > 0 && (
        <section
          aria-labelledby='notfall'
          className='flex flex-col gap-3 rounded-xl border-2 border-danger bg-danger-surface p-4 text-danger-text'
        >
          <h2 id='notfall' className='text-base font-bold'>
            {notfaelle.length === 1
              ? '1 möglicher Notfall erkannt'
              : `${notfaelle.length} mögliche Notfälle erkannt`}
          </h2>
          {notfaelle.map((m) => (
            <div
              key={m.id}
              className='flex flex-wrap items-center justify-between gap-3'
            >
              <p>
                <strong>
                  {nummer(m)} · {gemeinde(m)}:
                </strong>{' '}
                „{titel(m)}“. Bürger wurde zur 112 geleitet.
              </p>
              <div className='flex flex-wrap gap-2'>
                <Button
                  variant='destructive'
                  className='bg-danger py-1.5 text-sm'
                  onClick={() =>
                    void aktionen.notfallPruefen(
                      m.id,
                      NotfallPruefung.AnElsUebergeben,
                    )
                  }
                >
                  An ELS übergeben (EIDO)
                </Button>
                <Button
                  variant='outlined-secondary'
                  className='bg-white py-1.5 text-sm'
                  onClick={() =>
                    void aktionen.notfallPruefen(
                      m.id,
                      NotfallPruefung.KeinNotfall,
                    )
                  }
                >
                  Geprüft, kein Notfall
                </Button>
              </div>
            </div>
          ))}
        </section>
      )}

      <div className='grid gap-5 xl:grid-cols-[minmax(0,1fr)_minmax(0,1.3fr)]'>
        <Panel
          labelledBy='klaerung'
          title={`Klärung · ${klaerung.length} abgegebene Ereignisse`}
          hinweis='älteste zuerst'
          className={twMerge(klaerung.length > 0 && 'border-2 border-warning')}
        >
          {klaerung.length === 0 && (
            <p className='text-sm text-gray-700'>
              Keine Ereignisse in Klärung.
            </p>
          )}
          {klaerung.map((m) => (
            <KlaerungKarte
              key={m.id}
              meldung={m}
              farbe={farbe}
              now={now}
              abgebendeEl={elName(m.istZustaendigkeit.mitarbeiterGruppeId)}
              einsatzleitungen={einsatzleitungen}
              onZuweisen={(ziel) => zuweisen(m, ziel)}
              onSchliessen={() => setDialog({art: 'verwerfen', meldung: m})}
            />
          ))}
        </Panel>

        <Panel
          labelledBy='gesamtlage'
          title='Gesamtlage'
          hinweis='OpenStreetMap · alle Gebiete mit Einsatzleitung'
        >
          <LageKarte
            gebiete={data.gebiete.filter((g) => g.einsatzleitungen.length > 0)}
            marker={marker}
          />
          <div className='flex flex-wrap gap-4 text-xs text-gray-700'>
            {[...new Set(offen.map(kategorie))].sort().map((k) => (
              <span key={k} className='flex items-center gap-1.5'>
                <span
                  aria-hidden
                  className={twMerge('size-3 rounded-full', farbe(k).marker)}
                />
                {k}
              </span>
            ))}
            <span className='flex items-center gap-1.5'>
              <span aria-hidden className='size-3 rounded-full bg-warning' />
              in Klärung
            </span>
          </div>
        </Panel>
      </div>

      <Panel
        labelledBy='alle'
        title='Alle Ereignisse'
        hinweis={
          <span className='flex flex-wrap items-center gap-2'>
            {(['offen', 'archiv'] as const).map((t) => (
              <button
                key={t}
                type='button'
                aria-pressed={tab === t}
                onClick={() => setTab(t)}
                className={twMerge(
                  'min-h-9 rounded-full border px-3 text-sm',
                  tab === t
                    ? 'border-gray-900 bg-gray-900 text-white'
                    : 'border-gray-300 bg-white text-gray-900',
                )}
              >
                {t === 'offen' ? 'Offen' : 'Archiv'}
              </button>
            ))}
            <select
              aria-label='Einsatzleitung'
              value={elFilter}
              onChange={(e) => setElFilter(e.target.value)}
              className='min-h-9 rounded-full border border-gray-300 bg-white px-3 text-sm text-gray-900'
            >
              <option value={ALLE}>Alle Einsatzleitungen</option>
              {einsatzleitungen.map((el) => (
                <option key={el.id} value={el.id}>
                  {el.name}
                </option>
              ))}
            </select>
          </span>
        }
      >
        <div className='overflow-x-auto'>
          <table className='w-full min-w-[960px] border-collapse text-sm'>
            <thead>
              <tr className='border-b border-gray-300 text-left text-gray-700'>
                {[
                  'ID',
                  'Klasse',
                  'Kategorie',
                  'Ereignis',
                  'Gemeinde',
                  'Einsatzleitung',
                  'Status',
                  '+1',
                  tab === 'offen' ? 'Wartet' : 'Abschluss',
                  'Aktionen',
                ].map((h) => (
                  <th key={h} className='px-2 py-2.5 font-semibold'>
                    {h}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {tabelle.length === 0 && (
                <tr>
                  <td colSpan={10} className='px-2 py-4 text-gray-700'>
                    Keine Ereignisse.
                  </td>
                </tr>
              )}
              {tabelle.map((m) => {
                const wartet = wartetMs(m, now);
                return (
                  <tr key={m.id} className='border-b border-gray-100'>
                    <td className='whitespace-nowrap px-2 py-2.5 text-gray-700'>
                      {nummer(m)}
                    </td>
                    <td className='px-2 py-2.5'>{m.klasse ?? '–'}</td>
                    <td className='px-2 py-2.5'>{kategorie(m)}</td>
                    <td className='px-2 py-2.5 font-semibold'>{titel(m)}</td>
                    <td className='px-2 py-2.5'>{gemeinde(m)}</td>
                    <td className='px-2 py-2.5'>
                      {elName(m.istZustaendigkeit.mitarbeiterGruppeId)}
                    </td>
                    <td className='px-2 py-2.5'>
                      <Badge
                        className={
                          m.ereignisStatus === EreignisStatus.InKlaerung
                            ? 'bg-warning-surface text-warning-text'
                            : 'bg-gray-100 text-gray-900'
                        }
                      >
                        {m.ereignisStatus ? statusLabel[m.ereignisStatus] : '–'}
                        {m.externeStelle &&
                          ` · ${externeStelleLabel[m.externeStelle]}`}
                      </Badge>
                    </td>
                    <td className='px-2 py-2.5 font-bold'>
                      {m.anzahlBestaetigungen}
                    </td>
                    <td
                      className={twMerge(
                        'whitespace-nowrap px-2 py-2.5',
                        tab === 'offen' &&
                          wartet > LANGE_WARTEZEIT_MS &&
                          'font-semibold text-warning-text',
                      )}
                    >
                      {tab === 'offen'
                        ? m.ereignisStatus === EreignisStatus.InBearbeitung
                          ? '–'
                          : formatDauer(wartet)
                        : m.verwerfenGrund ?? m.externKommentar ?? '–'}
                    </td>
                    <td className='whitespace-nowrap px-2 py-1.5'>
                      {tab === 'offen' && (
                        <span className='flex gap-1.5'>
                          <TabellenButton
                            onClick={() =>
                              setDialog({art: 'umverteilen', meldung: m})
                            }
                          >
                            Umverteilen
                          </TabellenButton>
                          <TabellenButton
                            onClick={() =>
                              setDialog({art: 'bearbeiten', meldung: m})
                            }
                          >
                            Bearbeiten
                          </TabellenButton>
                          <TabellenButton
                            className='text-danger'
                            onClick={() =>
                              setDialog({art: 'verwerfen', meldung: m})
                            }
                          >
                            Verwerfen
                          </TabellenButton>
                        </span>
                      )}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </Panel>

      {dialog?.art === 'verwerfen' && (
        <BegruendungDialog
          meldung={dialog.meldung}
          title='Schließen mit Begründung'
          confirmText='Schließen'
          onClose={() => setDialog(null)}
          onSubmit={(begruendung) =>
            aktionen.verwerfen(dialog.meldung.id, begruendung)
          }
        />
      )}
      {dialog?.art === 'umverteilen' && (
        <UmverteilenDialog
          meldung={dialog.meldung}
          einsatzleitungen={einsatzleitungen}
          onClose={() => setDialog(null)}
          onSubmit={(ziel) => zuweisen(dialog.meldung, ziel)}
        />
      )}
      {dialog?.art === 'bearbeiten' && (
        <BearbeitenDialog
          meldung={dialog.meldung}
          bekannteAusruestung={bekannteAusruestung}
          onClose={() => setDialog(null)}
          onSubmit={(klasse, ausruestung) =>
            aktionen.einschaetzungSetzen(dialog.meldung.id, klasse, ausruestung)
          }
        />
      )}
    </div>
  );
};

const TabellenButton: FC<{
  onClick: () => void;
  className?: string;
  children: string;
}> = ({onClick, className, children}) => (
  <button
    type='button'
    onClick={onClick}
    className={twMerge(
      'min-h-8 rounded-md border border-gray-300 bg-white px-2.5 text-xs hover:bg-gray-50',
      className,
    )}
  >
    {children}
  </button>
);

const KlaerungKarte: FC<{
  meldung: Meldung;
  farbe: ReturnType<typeof kategorieFarben>;
  now: number;
  abgebendeEl: string;
  einsatzleitungen: LageDashboardData['einsatzleitungen'];
  onZuweisen: (ziel: Ziel) => Promise<boolean>;
  onSchliessen: () => void;
}> = ({
  meldung,
  farbe,
  now,
  abgebendeEl,
  einsatzleitungen,
  onZuweisen,
  onSchliessen,
}) => {
  const abgebend = meldung.istZustaendigkeit.mitarbeiterGruppeId;
  const [ziel, setZiel] = useState(
    einsatzleitungen.find((el) => el.id !== abgebend)?.id ?? '',
  );
  const seit = meldung.klaerungSeit ? now - meldung.klaerungSeit.getTime() : 0;
  return (
    <article className='flex flex-col gap-2.5 rounded-lg border border-gray-300 p-3'>
      <div className='flex flex-wrap items-center gap-2'>
        <MeldungBadges meldung={meldung} farbe={farbe} mitKlasse={false} />
        <span className='text-xs text-gray-700'>· {gemeinde(meldung)}</span>
        <span className='flex-1' />
        <span
          className={twMerge(
            'text-xs',
            seit > LANGE_WARTEZEIT_MS
              ? 'font-semibold text-warning-text'
              : 'text-gray-700',
          )}
        >
          in Klärung seit {formatDauer(seit)}
        </span>
      </div>
      <div className='font-semibold'>{titel(meldung)}</div>
      <div className='rounded-md bg-warning-surface px-2.5 py-2 text-sm text-warning-text'>
        <strong>
          {abgebendeEl}
          {meldung.klaerungGrund &&
            ` · ${abgabeGrundLabel[meldung.klaerungGrund]}`}
          {meldung.klaerungKommentar ? ':' : ''}
        </strong>
        {meldung.klaerungKommentar && ` „${meldung.klaerungKommentar}“`}
      </div>
      <div className='flex flex-wrap items-center gap-2'>
        <label className='flex items-center gap-2 text-sm text-gray-700'>
          Neu zuweisen an
          <select
            value={ziel}
            onChange={(e) => setZiel(e.target.value)}
            className='min-h-9 rounded-md border border-gray-300 px-2 text-gray-900'
          >
            <ZielOptionen
              einsatzleitungen={einsatzleitungen}
              ausser={abgebend}
            />
          </select>
        </label>
        <Button
          variant='solid'
          className='py-1.5 text-sm'
          disabled={!ziel}
          onClick={() => void onZuweisen(parseZiel(ziel))}
        >
          Zuweisen
        </Button>
        <Button
          variant='outlined-secondary'
          className='py-1.5 text-sm'
          onClick={onSchliessen}
        >
          Schließen mit Begründung
        </Button>
      </div>
    </article>
  );
};

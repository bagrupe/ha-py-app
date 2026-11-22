import {
  AbgabeGrund,
  EreignisStatus,
  ExterneStelle,
  MeldungKlasse,
} from '../../../__generated__/graphql.ts';
import {
  type DashboardEinheitFragment,
  type DashboardMeldungFragment,
} from './dashboard.generated.ts';

export type Meldung = DashboardMeldungFragment;

/** Equipment the backend rules ask for; units may carry more. */
export const AUSRUESTUNG = [
  'Motorkettensäge',
  'Drehleiter',
  'Pumpe',
  'Absperrung',
  'Radlader',
  'Seilwinde',
];

export const LANGE_WARTEZEIT_MS = 2 * 60 * 60 * 1000;

export const nummer = (meldung: Meldung) =>
  meldung.meldungsnummer ? `E-${meldung.meldungsnummer}` : '–';

const plainSlot = (meldung: Meldung, slotName: string): unknown => {
  const slot = meldung.slotValues.find((s) => s.slotName === slotName);
  return slot && 'value' in slot ? slot.value : undefined;
};

export const kategorie = (meldung: Meldung) => {
  const value = plainSlot(meldung, 'kategorie');
  return typeof value === 'string' ? value : 'Ohne Kategorie';
};

export const titel = (meldung: Meldung) => {
  const value = plainSlot(meldung, 'beschreibung');
  return typeof value === 'string' && value.trim()
    ? value.trim()
    : `Meldung ${kategorie(meldung)}`;
};

type Adresse = {addressString?: string; coordinates?: [number, number]};

const adresse = (meldung: Meldung): Adresse | undefined => {
  const value = plainSlot(meldung, 'adresse');
  return value && typeof value === 'object' ? (value as Adresse) : undefined;
};

export const koordinaten = (meldung: Meldung) => {
  const coordinates = adresse(meldung)?.coordinates;
  return Array.isArray(coordinates) && coordinates.length === 2
    ? coordinates
    : undefined;
};

export const ort = (meldung: Meldung) => {
  const gemeinde = meldung.lage?.gebietName;
  const strasse = gemeinde
    ? adresse(meldung)?.addressString?.replace(`${gemeinde}, `, '')
    : adresse(meldung)?.addressString;
  return [gemeinde, strasse && strasse !== gemeinde ? strasse : undefined]
    .filter(Boolean)
    .join(' · ');
};

export const gemeinde = (meldung: Meldung) => meldung.lage?.gebietName ?? '–';

export const formatDauer = (ms: number) => {
  const minuten = Math.max(0, Math.floor(ms / 60_000));
  const stunden = Math.floor(minuten / 60);
  return stunden > 0
    ? `${stunden} h ${String(minuten % 60).padStart(2, '0')} min`
    : `${minuten} min`;
};

export const wartetMs = (meldung: Meldung, now: number) =>
  now - meldung.createdAt.getTime();

export const KLASSEN: MeldungKlasse[] = [
  MeldungKlasse.A,
  MeldungKlasse.B,
  MeldungKlasse.C,
  MeldungKlasse.D,
];

export const klassenLabel: Record<MeldungKlasse, string> = {
  [MeldungKlasse.A]: 'A · dringend + wichtig',
  [MeldungKlasse.B]: 'B · wichtig',
  [MeldungKlasse.C]: 'C · dringend',
  [MeldungKlasse.D]: 'D',
};

export const klassenClass: Record<MeldungKlasse, string> = {
  [MeldungKlasse.A]: 'bg-danger text-white',
  [MeldungKlasse.B]: 'bg-klasse-b-surface text-klasse-b-text',
  [MeldungKlasse.C]: 'bg-klasse-c-surface text-klasse-c-text',
  [MeldungKlasse.D]: 'bg-gray-100 text-gray-700',
};

const klassenRang = (meldung: Meldung) =>
  meldung.klasse ? KLASSEN.indexOf(meldung.klasse) : KLASSEN.length;

/** Klasse first, then +1 count, then the longest wait. */
export const nachDringlichkeit = (a: Meldung, b: Meldung) =>
  klassenRang(a) - klassenRang(b) ||
  b.anzahlBestaetigungen - a.anzahlBestaetigungen ||
  a.createdAt.getTime() - b.createdAt.getTime();

const KATEGORIE_TOKENS = [
  'kategorie-1',
  'kategorie-2',
  'kategorie-3',
  'kategorie-4',
] as const;

const kategorieClasses = {
  'kategorie-1': {
    badge: 'bg-kategorie-1-surface text-kategorie-1-text',
    marker: 'bg-kategorie-1',
    color: 'rgb(var(--color-kategorie-1))',
  },
  'kategorie-2': {
    badge: 'bg-kategorie-2-surface text-kategorie-2-text',
    marker: 'bg-kategorie-2',
    color: 'rgb(var(--color-kategorie-2))',
  },
  'kategorie-3': {
    badge: 'bg-kategorie-3-surface text-kategorie-3-text',
    marker: 'bg-kategorie-3',
    color: 'rgb(var(--color-kategorie-3))',
  },
  'kategorie-4': {
    badge: 'bg-kategorie-4-surface text-kategorie-4-text',
    marker: 'bg-kategorie-4',
    color: 'rgb(var(--color-kategorie-4))',
  },
};

/** Categories come from process data, so they map to numbered tokens in a stable order of first appearance. */
export const kategorieFarben = (kategorien: string[]) => {
  const sorted = [...new Set(kategorien)].sort((a, b) => a.localeCompare(b));
  return (name: string) =>
    kategorieClasses[
      KATEGORIE_TOKENS[
        Math.max(0, sorted.indexOf(name)) % KATEGORIE_TOKENS.length
      ]
    ];
};

export const statusLabel: Record<EreignisStatus, string> = {
  [EreignisStatus.Eingegangen]: 'eingegangen',
  [EreignisStatus.Zugewiesen]: 'zugewiesen',
  [EreignisStatus.InBearbeitung]: 'in Bearbeitung',
  [EreignisStatus.InKlaerung]: 'Klärung',
  [EreignisStatus.Erledigt]: 'erledigt',
  [EreignisStatus.Verworfen]: 'verworfen',
  [EreignisStatus.ExternUebergeben]: 'extern übergeben',
};

export const abgabeGrundLabel: Record<AbgabeGrund, string> = {
  [AbgabeGrund.AusruestungFehlt]: 'Benötigte Ausrüstung fehlt',
  [AbgabeGrund.KeineEinheitFrei]: 'Keine Einheit frei',
  [AbgabeGrund.NichtUnserGebiet]: 'Nicht unser Gebiet',
  [AbgabeGrund.KeinFallFuerFeuerwehr]:
    'Kein Fall für die Feuerwehr (z. B. Bauhof)',
  [AbgabeGrund.Sonstiges]: 'Sonstiges',
};

export const externeStelleLabel: Record<ExterneStelle, string> = {
  [ExterneStelle.Bauhof]: 'Bauhof',
  [ExterneStelle.Thw]: 'THW',
  [ExterneStelle.Els]: 'ELS (112)',
};

export const fehlendeAusruestung = (
  meldung: Meldung | undefined,
  einheit: DashboardEinheitFragment,
) =>
  (meldung?.benoetigteAusruestung ?? []).filter(
    (a) => !einheit.ausruestung.includes(a),
  );

export const istOffen = (meldung: Meldung) =>
  meldung.ereignisStatus === EreignisStatus.Eingegangen ||
  meldung.ereignisStatus === EreignisStatus.Zugewiesen ||
  meldung.ereignisStatus === EreignisStatus.InBearbeitung ||
  meldung.ereignisStatus === EreignisStatus.InKlaerung;

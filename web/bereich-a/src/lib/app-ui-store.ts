import {create} from 'zustand';
import {persist} from 'zustand/middleware';

/** Schlüssel der Listen, die eine eigene, unabhängig persistierte Seitengröße haben. */
export type ListKey =
  | 'antraege'
  | 'nutzende'
  | 'prozesse'
  | 'archiv'
  | 'papierkorb';

const DEFAULT_SEITENGROESSEN: Record<ListKey, number> = {
  antraege: 20,
  nutzende: 20,
  prozesse: 20,
  archiv: 20,
  papierkorb: 20,
};

/**
 * Zustand-Typ für den UI-Status: Filter nach Antragsart, freie Suche und Seitengröße je Liste.
 */
type State = {
  antragsartFilter: string | null;
  /** Freitext-Suche über die geladene Anträge-Liste (inkl. entschlüsselter Beschreibung). */
  antragSuche: string;
  /** Anzahl Einträge pro Seite je Liste (vom Nutzer wählbar, max. 100 = Server-Limit). */
  seitengroessen: Record<ListKey, number>;
};

/**
 * Aktionen zum Aktualisieren des UI-Status.
 */
type Action = {
  /**
   * Aktualisiert den Filter für die Antragsart.
   * @param antragsArtFilter Neuer Wert des Filters oder null zum Zurücksetzen.
   */
  updateAntragsartFilter: (antragsArtFilter: State['antragsartFilter']) => void;
  /** Aktualisiert den Suchbegriff der Anträge-Liste. */
  setAntragSuche: (antragSuche: string) => void;
  /** Setzt die Anzahl Einträge pro Seite für die angegebene Liste. */
  setSeitengroesse: (list: ListKey, seitengroesse: number) => void;
};

/**
 * Zustand-Hook für UI-bezogene Zustände und Aktionen der App.
 * Persistiert NUR die Seitengrößen (Nutzer-Einstellung) in localStorage; Suche und
 * Antragsart-Filter bleiben bewusst flüchtig (nach Reload zurückgesetzt).
 */
export const useAppUiStore = create<State & Action>()(
  persist(
    (set) => ({
      antragsartFilter: null,
      antragSuche: '',
      seitengroessen: DEFAULT_SEITENGROESSEN,
      updateAntragsartFilter: (antragsartFilter) =>
        set(() => ({antragsartFilter: antragsartFilter})),
      setAntragSuche: (antragSuche) => set(() => ({antragSuche})),
      setSeitengroesse: (list, seitengroesse) =>
        set((state) => ({
          seitengroessen: {...state.seitengroessen, [list]: seitengroesse},
        })),
    }),
    {
      name: 'kommunalapp-ui',
      version: 1,
      partialize: (state) => ({seitengroessen: state.seitengroessen}),
      // Version 0 (vor der Mehrfach-Listen-Unterstützung) persistierte nur `seitengroesse: number`
      // für die Anträge-Liste. Bestehende Nutzer sollen diesen Wert nicht verlieren.
      migrate: (persisted, version) => {
        // Nur `seitengroessen` wird persistiert (s. `partialize`); zustand merged das
        // Ergebnis shallow auf den initialen State, ein vollständiges State&Action-Objekt
        // ist hier nicht nötig - der Cast spiegelt das tatsächliche Merge-Verhalten wider.
        if (version === 0) {
          const alt = persisted as {seitengroesse?: number};
          return {
            seitengroessen: {
              ...DEFAULT_SEITENGROESSEN,
              antraege: alt.seitengroesse ?? DEFAULT_SEITENGROESSEN.antraege,
            },
          } as State & Action;
        }
        return persisted as State & Action;
      },
      merge: (persisted, current) => ({
        ...current,
        ...(persisted as Partial<State>),
        seitengroessen: {
          ...current.seitengroessen,
          ...(persisted as Partial<State> | undefined)?.seitengroessen,
        },
      }),
    },
  ),
);

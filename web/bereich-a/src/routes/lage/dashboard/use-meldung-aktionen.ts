import {toast} from 'react-toastify';
import {
  type AbgabeGrund,
  type ExterneStelle,
  MeldungAktion,
  type MeldungKlasse,
  type NotfallPruefung,
} from '../../../__generated__/graphql.ts';
import {mutationFailed} from '../../../lib/mutation.ts';
import {
  useDashboardAnLeitstelleAbgebenMutation,
  useDashboardEinheitAendernMutation,
  useDashboardEinheitAnlegenMutation,
  useDashboardEinheitLoeschenMutation,
  useDashboardEinheitZuweisenMutation,
  useDashboardEinschaetzungSetzenMutation,
  useDashboardExternUebergebenMutation,
  useDashboardFortsetzenMutation,
  useDashboardMeldewegMutation,
  useDashboardNotfallPruefenMutation,
  useDashboardUmverteilenMutation,
  useDashboardVerwerfenMutation,
} from './dashboard.generated.ts';

type Payload = {errors?: unknown[] | null} | null | undefined;

/** Domain errors are toasted globally by the urql client; this only reports success. */
const ok = (
  result: {data?: Record<string, unknown> | null; error?: unknown},
  erfolg?: string,
) => {
  if (mutationFailed(result as Parameters<typeof mutationFailed>[0]))
    return false;
  const payload = Object.values(result.data ?? {})[0] as Payload;
  if (payload?.errors?.length) return false;
  if (erfolg) toast.success(erfolg);
  return true;
};

export const useMeldungAktionen = (onChange: () => void) => {
  const [, zuweisen] = useDashboardEinheitZuweisenMutation();
  const [, fortsetzen] = useDashboardFortsetzenMutation();
  const [, abgeben] = useDashboardAnLeitstelleAbgebenMutation();
  const [, umverteilen] = useDashboardUmverteilenMutation();
  const [, extern] = useDashboardExternUebergebenMutation();
  const [, verwerfen] = useDashboardVerwerfenMutation();
  const [, notfall] = useDashboardNotfallPruefenMutation();
  const [, einschaetzung] = useDashboardEinschaetzungSetzenMutation();
  const [, meldeweg] = useDashboardMeldewegMutation();
  const [, einheitAnlegen] = useDashboardEinheitAnlegenMutation();
  const [, einheitAendern] = useDashboardEinheitAendernMutation();
  const [, einheitLoeschen] = useDashboardEinheitLoeschenMutation();

  const done = (success: boolean) => {
    onChange();
    return success;
  };

  return {
    zuweisen: async (ausfuehrungId: string, einheitId: string | null) =>
      done(ok(await zuweisen({input: {ausfuehrungId, einheitId}}))),
    laeuft: async (ausfuehrungId: string) =>
      done(
        ok(
          await fortsetzen({
            input: {ausfuehrungId, aktion: MeldungAktion.HilfeEinleiten},
          }),
          'Hilfe eingeleitet.',
        ),
      ),
    erledigt: async (ausfuehrungId: string) =>
      done(
        ok(
          await fortsetzen({
            input: {ausfuehrungId, aktion: MeldungAktion.EinsatzAbschliessen},
          }),
          'Einsatz abgeschlossen.',
        ),
      ),
    abgeben: async (
      ausfuehrungId: string,
      grund: AbgabeGrund,
      kommentar: string,
    ) =>
      done(
        ok(
          await abgeben({
            input: {ausfuehrungId, grund, kommentar: kommentar || null},
          }),
          'An die Leitstelle abgegeben.',
        ),
      ),
    umverteilen: async (ausfuehrungId: string, mitarbeiterGruppeId: string) =>
      done(
        ok(
          await umverteilen({input: {ausfuehrungId, mitarbeiterGruppeId}}),
          'Ereignis neu zugewiesen.',
        ),
      ),
    extern: async (
      ausfuehrungId: string,
      stelle: ExterneStelle,
      kommentar?: string,
    ) =>
      done(
        ok(
          await extern({
            input: {ausfuehrungId, stelle, kommentar: kommentar || null},
          }),
          'Ereignis extern übergeben.',
        ),
      ),
    verwerfen: async (ausfuehrungId: string, begruendung: string) =>
      done(
        ok(
          await verwerfen({input: {ausfuehrungId, begruendung}}),
          'Ereignis geschlossen.',
        ),
      ),
    notfallPruefen: async (ausfuehrungId: string, ergebnis: NotfallPruefung) =>
      done(ok(await notfall({input: {ausfuehrungId, ergebnis}}))),
    einschaetzungSetzen: async (
      ausfuehrungId: string,
      klasse: MeldungKlasse,
      benoetigteAusruestung: string[],
    ) =>
      done(
        ok(
          await einschaetzung({
            input: {ausfuehrungId, klasse, benoetigteAusruestung},
          }),
          'Einschätzung gespeichert.',
        ),
      ),
    meldeweg: async (lageId: string, offen: boolean) =>
      done(
        ok(
          await meldeweg({input: {lageId, offen}}),
          offen ? 'Meldeweg ist wieder online.' : 'Meldeweg ist offline.',
        ),
      ),
    /** ausruestung: null takes the standard equipment of the vehicle type in the name. */
    einheitAnlegen: async (
      mitarbeiterGruppeId: string,
      name: string,
      ausruestung: string[] | null,
    ) =>
      done(
        ok(
          await einheitAnlegen({
            input: {mitarbeiterGruppeId, name, ausruestung},
          }),
          `${name.trim()} angelegt.`,
        ),
      ),
    einheitAendern: async (
      einheitId: string,
      name: string,
      ausruestung: string[],
    ) =>
      done(
        ok(
          await einheitAendern({input: {einheitId, name, ausruestung}}),
          'Einheit gespeichert.',
        ),
      ),
    einheitLoeschen: async (einheitId: string) =>
      done(
        ok(await einheitLoeschen({input: {einheitId}}), 'Einheit gelöscht.'),
      ),
  };
};

export type MeldungAktionen = ReturnType<typeof useMeldungAktionen>;

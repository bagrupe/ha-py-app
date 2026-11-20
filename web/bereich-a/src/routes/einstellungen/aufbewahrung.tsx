import {useFormBuilder} from '@atmina/formbuilder';
import {format} from 'date-fns';
import {type FC, useCallback, useMemo} from 'react';
import {toast} from 'react-toastify';
import {CheckboxFormField} from '../../components/form/fields/checkbox-field';
import {type CollectionItem} from '../../components/form/fields/collections.ts';
import {InputFormField} from '../../components/form/fields/input-field';
import {SelectFormField} from '../../components/form/fields/select-field';
import {Form} from '../../components/form/form.tsx';
import {PageHeader, PageShell} from '../../components/page-shell.tsx';
import {Button} from '../../components/ui/button';
import {mutationFailed} from '../../lib/mutation.ts';
import {
  useAufbewahrungsEinstellungenQuery,
  useAufbewahrungsEinstellungenAktualisierenMutation,
} from './aufbewahrung.generated';

type Einheit = 'minuten' | 'stunden' | 'tage';

const FAKTOR: Record<Einheit, number> = {
  minuten: 1,
  stunden: 60,
  tage: 60 * 24,
};

const EINHEIT_ITEMS: CollectionItem<Einheit>[] = [
  {value: 'minuten', name: 'Minuten'},
  {value: 'stunden', name: 'Stunden'},
  {value: 'tage', name: 'Tage'},
];

/** Wählt die gröbste Einheit, in der die Minuten ohne Rest aufgehen. */
const minutenZuDauer = (minuten: number): {wert: string; einheit: Einheit} => {
  if (minuten > 0 && minuten % FAKTOR.tage === 0) {
    return {wert: String(minuten / FAKTOR.tage), einheit: 'tage'};
  }
  if (minuten > 0 && minuten % FAKTOR.stunden === 0) {
    return {wert: String(minuten / FAKTOR.stunden), einheit: 'stunden'};
  }
  return {wert: String(minuten), einheit: 'minuten'};
};

const dauerZuMinuten = (wert: string, einheit: Einheit): number =>
  Math.max(0, Math.round(Number(wert) || 0)) * FAKTOR[einheit];

type AufbewahrungForm = {
  hardDeleteWert: string;
  hardDeleteEinheit: Einheit;
  archivWert: string;
  archivEinheit: Einheit;
  hardDeleteAktiv: boolean;
  archivierungAktiv: boolean;
};

/**
 * Einstellungen für Aufbewahrung/Löschung von Anträgen (Berechtigung "Aufbewahrung verwalten"
 * erforderlich, per <IfFunktionsberechtigung> auf Routen-Ebene durchgesetzt).
 * Zwei Fristen (endgültige Löschung soft-gelöschter Anträge, Archivierung abgeschlossener
 * Anträge) plus Aktiv-Schalter der zugehörigen Jobs.
 */
export const AufbewahrungEinstellungen: FC = () => {
  const [{data, fetching}] = useAufbewahrungsEinstellungenQuery();
  const [, speichern] = useAufbewahrungsEinstellungenAktualisierenMutation();

  // useFormBuilder synct "values" automatisch neu, sobald sich die geladenen Einstellungen
  // ändern - ersetzt den vorherigen useEffect + 6x useState, der lokalen Bearbeitungsstatus
  // manuell aus den Query-Daten initialisiert hat (inkl. eines eslint-disable für
  // react-hooks/set-state-in-effect, das damit ebenfalls entfällt).
  const values = useMemo<AufbewahrungForm | undefined>(() => {
    const e = data?.aufbewahrungsEinstellungen;
    if (!e) return undefined;
    const hd = minutenZuDauer(e.hardDeleteVerzoegerungMinuten);
    const ar = minutenZuDauer(e.archivVerzoegerungMinuten);
    return {
      hardDeleteWert: hd.wert,
      hardDeleteEinheit: hd.einheit,
      archivWert: ar.wert,
      archivEinheit: ar.einheit,
      hardDeleteAktiv: e.hardDeleteAktiv,
      archivierungAktiv: e.archivierungAktiv,
    };
  }, [data]);

  const builder = useFormBuilder<AufbewahrungForm>({values});

  const onSubmit = useCallback(
    async (form: AufbewahrungForm) => {
      const result = await speichern({
        input: {
          hardDeleteVerzoegerungMinuten: dauerZuMinuten(
            form.hardDeleteWert,
            form.hardDeleteEinheit,
          ),
          archivVerzoegerungMinuten: dauerZuMinuten(
            form.archivWert,
            form.archivEinheit,
          ),
          hardDeleteAktiv: form.hardDeleteAktiv,
          archivierungAktiv: form.archivierungAktiv,
        },
      });
      if (mutationFailed(result)) return;
      const errors =
        result.data!.aufbewahrungsEinstellungenAktualisieren.errors;
      if (errors && errors.length > 0) {
        return;
      }
      toast.success('Einstellungen gespeichert.');
    },
    [speichern],
  );

  return (
    <PageShell>
      <PageHeader
        title='Aufbewahrung & Löschung'
        description={
          <>
            Fristen und Jobs für das endgültige Löschen soft-gelöschter Anträge
            und das Archivieren abgeschlossener Anträge. Sichtbar für
            Nutzer:innen mit der Berechtigung „Aufbewahrung verwalten&rdquo;.
          </>
        }
      />

      {fetching || !values ? (
        <p>Lädt …</p>
      ) : (
        <Form
          builder={builder}
          onSubmit={onSubmit}
          className='flex flex-col gap-6'
        >
          <div className='grid gap-6 lg:grid-cols-2'>
            <section className='flex flex-col gap-4 rounded-lg border border-gray-200 p-5'>
              <h2 className='text-lg font-semibold'>Endgültige Löschung</h2>
              <p className='text-sm text-gray-500'>
                Zeit nach dem Soft-Löschen, bevor ein Antrag endgültig (inkl.
                Schlüssel) gelöscht wird.
              </p>
              <div className='flex items-center gap-2'>
                <InputFormField
                  on={builder.fields.hardDeleteWert}
                  rules={{min: 0}}
                  type='number'
                  label='Karenzzeit'
                  className='w-32'
                />
                <SelectFormField
                  on={builder.fields.hardDeleteEinheit}
                  items={EINHEIT_ITEMS}
                  className='w-36'
                />
              </div>
              <CheckboxFormField
                on={builder.fields.hardDeleteAktiv}
                label='Endgültige Löschung aktiv (Job läuft)'
              />
            </section>

            <section className='flex flex-col gap-4 rounded-lg border border-gray-200 p-5'>
              <h2 className='text-lg font-semibold'>Archivierung</h2>
              <p className='text-sm text-gray-500'>
                Zeit nach Abschluss eines Antrags, bevor er in die
                Archiv-Datenbank verschoben wird.
              </p>
              <div className='flex items-center gap-2'>
                <InputFormField
                  on={builder.fields.archivWert}
                  rules={{min: 0}}
                  type='number'
                  label='Archivfrist'
                  className='w-32'
                />
                <SelectFormField
                  on={builder.fields.archivEinheit}
                  items={EINHEIT_ITEMS}
                  className='w-36'
                />
              </div>
              <CheckboxFormField
                on={builder.fields.archivierungAktiv}
                label='Archivierung aktiv (Job läuft)'
              />
            </section>
          </div>

          <div className='flex items-center gap-4'>
            <Button type='submit' disabled={builder.formState.isSubmitting}>
              Speichern
            </Button>
            {data?.aufbewahrungsEinstellungen.aktualisiertAm && (
              <span className='text-sm text-gray-500'>
                Zuletzt geändert:{' '}
                {format(
                  data.aufbewahrungsEinstellungen.aktualisiertAm,
                  'dd.MM.yyyy HH:mm',
                )}
              </span>
            )}
          </div>
        </Form>
      )}
    </PageShell>
  );
};

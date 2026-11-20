import {useFormBuilder} from '@atmina/formbuilder';
import {useReactFlow} from '@xyflow/react';
import {type FC, useCallback, useEffect, useMemo} from 'react';
import {MdOutlineBackspace} from 'react-icons/md';
import {ExpressionInputFormField} from '../../../../components/form/fields/expression-input-field/expression-input-field.tsx';
import {InputFormField} from '../../../../components/form/fields/input-field';
import {Form} from '../../../../components/form/form.tsx';
import {Sidebar} from '../../../../components/sidebar/sidebar.tsx';
import {Button} from '../../../../components/ui/button';
import {type VerbindungDaten} from '../lib/domain-types.ts';
import {useProzessEditorStore} from '../lib/store';
import {SidebarHeader} from './sidebar-header';

/**
 * Typalias für das Formular, das die Daten einer Verbindung repräsentiert.
 */
type VerbindungForm = VerbindungDaten;

const DEFAULT_VERBINDUNG_FORM: VerbindungForm = {
  id: '',
  vonId: '',
  nachId: '',
  name: '',
  statusAenderung: '',
  statusAenderungBeschreibung: '',
  istRelevant: 'true',
};

const normalizeNullableText = (value: string | null | undefined): string =>
  value ?? '';

const emptyTextToNull = (value: string | null | undefined): string | null =>
  value === '' || value === undefined ? null : value;

const toVerbindungForm = (verbindung: VerbindungDaten): VerbindungForm => ({
  ...DEFAULT_VERBINDUNG_FORM,
  ...verbindung,
  name: normalizeNullableText(verbindung.name),
  statusAenderung: normalizeNullableText(verbindung.statusAenderung),
  statusAenderungBeschreibung: normalizeNullableText(
    verbindung.statusAenderungBeschreibung,
  ),
  istRelevant: verbindung.istRelevant ?? DEFAULT_VERBINDUNG_FORM.istRelevant,
});

/**
 * Sidebar-Komponente zur Anzeige und Bearbeitung einer ausgewählten Verbindung.
 * Stellt ein Formular bereit, um Verbindungsdaten zu bearbeiten und zu speichern.
 * Ermöglicht das Löschen der Verbindung mit Bestätigung (über `onBeforeDelete`).
 */
export const VerbindungSidebar: FC = () => {
  // Only a single-edge selection drives the connection editor.
  const selectedEdge = useProzessEditorStore((store) => {
    const selected = store.edges.filter((e) => e.selected);
    return selected.length === 1 ? selected[0] : undefined;
  });
  const updateConnectionData = useProzessEditorStore(
    (store) => store.updateConnectionData,
  );

  const flow = useReactFlow();

  const builder = useFormBuilder<VerbindungForm>({
    defaultValues: DEFAULT_VERBINDUNG_FORM,
  });
  const {reset} = builder;

  const selectedVerbindung = useMemo<VerbindungDaten | null>(
    () =>
      selectedEdge
        ? ({
            ...selectedEdge.data?.verbindung,
            id: selectedEdge.id,
            vonId: selectedEdge.source,
            nachId: selectedEdge.target,
          } as VerbindungDaten)
        : null,
    [selectedEdge],
  );

  useEffect(() => {
    if (!selectedVerbindung) {
      reset(DEFAULT_VERBINDUNG_FORM);
      return;
    }

    reset(toVerbindungForm(selectedVerbindung));
  }, [reset, selectedVerbindung]);

  /**
   * Übernimmt die Formularwerte als Verbindungsdaten. Die Kantenbeschriftung wird vom
   * Graph aus den Daten abgeleitet, daher entfällt das manuelle Setzen des Labels.
   * @param form Die aktuellen Formulardaten der Verbindung.
   */
  const handleSubmit = useCallback(
    (form: VerbindungForm) => {
      if (!selectedEdge) return;
      updateConnectionData(selectedEdge.id, {
        name: emptyTextToNull(form.name),
        statusAenderung: emptyTextToNull(form.statusAenderung),
        statusAenderungBeschreibung: emptyTextToNull(
          form.statusAenderungBeschreibung,
        ),
        istRelevant: form.istRelevant,
      });
    },
    [selectedEdge, updateConnectionData],
  );

  /**
   * Löscht die ausgewählte Verbindung über React Flow, das den Bestätigungsdialog in
   * `onBeforeDelete` auslöst.
   */
  const onDeleteVerbindung = useCallback(() => {
    if (!selectedEdge) return;
    flow.deleteElements({edges: [{id: selectedEdge.id}]});
  }, [flow, selectedEdge]);

  return (
    <Sidebar isOpen={!!selectedVerbindung}>
      <Form
        builder={builder}
        onSubmit={handleSubmit}
        className='flex grow flex-col overflow-hidden'
      >
        <SidebarHeader on={builder.fields.name} placeholder='Verbindung' />
        <div className='flex h-full w-[480px] flex-1 flex-col gap-4 overflow-auto p-4'>
          <InputFormField label='Name' on={builder.fields.name} />
          <InputFormField
            label='Statusänderung (Titel)'
            on={builder.fields.statusAenderung}
          />
          <InputFormField
            label='Statusänderung (Beschreibung)'
            on={builder.fields.statusAenderungBeschreibung}
          />
          <ExpressionInputFormField
            label='Bedingung'
            on={builder.fields.istRelevant}
            kind='bool'
          />

          <Button variant='solid'>Übernehmen</Button>

          <Button
            type='button'
            variant='destructive'
            onClick={onDeleteVerbindung}
          >
            <div className='flex flex-col'>
              <div>Verbindung löschen</div>
              <div className='text-xs text-red-200'>
                oder mit <MdOutlineBackspace className='mb-px inline-block' />{' '}
                Backspace
              </div>
            </div>
          </Button>
        </div>
      </Form>
    </Sidebar>
  );
};

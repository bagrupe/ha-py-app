import {type FormBuilder, useFormBuilder} from '@atmina/formbuilder';
import uniq from 'lodash/uniq';
import {useEffect, useMemo} from 'react';
import {MdAddCircleOutline} from 'react-icons/md';
import {RiDeleteBin6Line} from 'react-icons/ri';
import {SlotValueType} from 'src/__generated__/graphql.ts';
import {
  CheckboxFormField,
  SimpleCheckBoxFormField,
} from 'src/components/form/fields/checkbox-field/checkbox-field.tsx';
import {InputFormField} from 'src/components/form/fields/input-field/input-field.tsx';
import {Button} from 'src/components/ui/button/button.tsx';
import {type SchrittDaten} from '../../lib/domain-types.ts';
import {flowToDomain} from '../../lib/flow/flow-to-domain.ts';
import {
  dotPathToExportParts,
  getDefaultValuesFromExportParts,
} from '../../lib/gov-manager-export-converter.ts';
import {useProzessEditorStore} from '../../lib/store';
import {
  createProzessVisitor,
  VisitDirection,
} from '../../lib/validate-prozess.ts';
import {type ProzessEditorSchritt_GovManagerRestExportSchritt} from '../../prozess-version-erstellen.generated.ts';
import {FormCard} from './form-card.tsx';

/**
 * Eigenschaften für ein JSON-Slot-Formularfeld.
 * Gibt an, ob das Feld exportiert wird und den zugehörigen Exportpfad.
 */
export type JsonSlotFormFieldProps = {
  exportField: boolean;
  path: string;
};

/**
 * Komponente zur Darstellung eines JSON-Slot-Formularfelds mit Checkbox und optionalem Pfad-Eingabefeld.
 * @param on FormBuilder-Instanz für das Feld
 * @param label Beschriftung der Checkbox
 */
export const JsonSlotFormField = ({
  on,
  label,
}: {
  on: FormBuilder<JsonSlotFormFieldProps>;
  label: string;
}) => {
  const exportField = on.exportField.$useWatch();

  return (
    <div>
      <SimpleCheckBoxFormField on={on.exportField} label={label} />{' '}
      {exportField && <InputFormField on={on.path} label='Export Pfad' />}
    </div>
  );
};

/**
 * Eigenschaften für ein JSON-String-Formularfeld.
 * Enthält den Wert und den zugehörigen Exportpfad.
 */
export type JsonStringFormFieldProps = {
  path: string;
  value: string;
};

/**
 * Komponente zur Darstellung eines JSON-String-Formularfelds mit Wert- und Pfad-Eingabe.
 * @param on FormBuilder-Instanz für das Feld
 */
export const JsonStringFormField = ({
  on,
}: {
  on: FormBuilder<JsonStringFormFieldProps>;
}) => (
  <div className='w-full'>
    <InputFormField on={on.value} label='Wert' />
    <InputFormField on={on.path} label='Export Pfad' />
  </div>
);

/**
 * Typ für den GovManager REST Export Schritt, extrahiert aus den SchrittDaten.
 */
export type GovManagerRestExportSchritt = Extract<
  SchrittDaten,
  {__typename: 'GovManagerRestExportSchritt'}
>;

/**
 * Komponente zur Bearbeitung des GovManager REST Export Schritts.
 * Verwaltet die Exportfelder, deren Pfade und zusätzliche Werte.
 * Validiert die Pfade und synchronisiert die Exportteile mit dem Formularzustand.
 * @param on FormBuilder-Instanz für den Export Schritt
 * @param subFormIsValid Callback zur Meldung der Validität des Unterformulars
 * @param storeProzess Aktueller Prozesszustand aus dem Store
 */
export const GovManagerRestExportSchritt = ({
  on,
  subFormIsValid,
}: {
  on: FormBuilder<GovManagerRestExportSchritt>;
  subFormIsValid: (value: boolean) => void;
}) => {
  const currentExportParts = on.exportParts.$useWatch();
  const {id, exportFilePartsAsPdf} = on.$useWatch();
  const nodes = useProzessEditorStore((state) => state.nodes);
  const edges = useProzessEditorStore((state) => state.edges);
  const rollen = useProzessEditorStore((state) => state.metadata.rollen);

  /**
   * Upstream-Formularschritte (DFS). Slotnamen, die in mehr als einem Schritt vorkommen,
   * erscheinen einmal in der gemeinsamen Karte; übrige Slots je Schritt in der Schritt-Karte.
   */
  const {schrittExportCards, sharedSlotExportRows} = useMemo(() => {
    const {schritte, verbindungen} = flowToDomain(nodes, edges, rollen);
    const visitor = createProzessVisitor(schritte, verbindungen);
    const referenzierbareFormularSchrittIds: string[] = [];
    visitor.visitDfs([id], VisitDirection.Up, (schritt) => {
      if (
        schritt &&
        schritt.__typename === 'FormularSchritt' &&
        schritt.felder.some((feld) => feld.slotName)
      ) {
        referenzierbareFormularSchrittIds.unshift(schritt.id);
      }
    });

    const schrittById = new Map(schritte.map((s) => [s.id, s]));
    const upstreamFormularSchritte = uniq(referenzierbareFormularSchrittIds)
      .map((schrittId) => schrittById.get(schrittId))
      .filter(
        (s): s is Extract<SchrittDaten, {__typename: 'FormularSchritt'}> =>
          s?.__typename === 'FormularSchritt',
      );

    const slotNameToSchrittIds = new Map<string, Set<string>>();
    for (const schritt of upstreamFormularSchritte) {
      const seenInSchritt = new Set<string>();
      for (const feld of schritt.felder) {
        if (!feld.slotName || seenInSchritt.has(feld.slotName)) continue;
        seenInSchritt.add(feld.slotName);
        let set = slotNameToSchrittIds.get(feld.slotName);
        if (!set) {
          set = new Set<string>();
          slotNameToSchrittIds.set(feld.slotName, set);
        }
        set.add(schritt.id);
      }
    }

    const sharedSlotNames = new Set<string>();
    for (const [slotName, schrittIds] of slotNameToSchrittIds) {
      if (schrittIds.size > 1) {
        sharedSlotNames.add(slotName);
      }
    }

    const sharedSlotExportRows: {label: string; slotName: string}[] = [];
    const seenSharedSlot = new Set<string>();
    for (const schritt of upstreamFormularSchritte) {
      for (const feld of schritt.felder) {
        if (!feld.slotName || !sharedSlotNames.has(feld.slotName)) continue;
        if (seenSharedSlot.has(feld.slotName)) continue;
        seenSharedSlot.add(feld.slotName);
        sharedSlotExportRows.push({
          slotName: feld.slotName,
          label: feld.angezeigterName ?? feld.slotName,
        });
      }
    }

    const schrittExportCards: {
      felder: {key: string; label: string; slotName: string}[];
      schrittId: string;
      titel: string | null;
    }[] = [];

    for (const schritt of upstreamFormularSchritte) {
      const felder: {key: string; label: string; slotName: string}[] = [];
      const seenSlot = new Set<string>();
      for (const feld of schritt.felder) {
        if (!feld.slotName || sharedSlotNames.has(feld.slotName)) continue;
        if (seenSlot.has(feld.slotName)) continue;
        seenSlot.add(feld.slotName);
        felder.push({
          key: feld.id,
          slotName: feld.slotName,
          label: feld.angezeigterName ?? feld.slotName,
        });
      }
      if (felder.length > 0) {
        schrittExportCards.push({
          schrittId: schritt.id,
          titel: schritt.titel ?? null,
          felder,
        });
      }
    }

    return {schrittExportCards, sharedSlotExportRows};
  }, [id, nodes, edges, rollen]);

  const allSlots = useMemo(
    () =>
      flowToDomain(nodes, edges, rollen).schritte.flatMap((schritt) => {
        if (schritt.__typename === 'FormularSchritt') {
          return schritt.felder
            .filter((feld) => feld.slotName)
            .map((feld) => {
              const existing = schritt.slots.find(
                (s) => s.name === feld.slotName,
              );
              if (existing) return existing;
              return {
                __typename: 'Slot' as const,
                name: feld.slotName,
                encrypted: feld.encrypted,
                valueType:
                  feld.__typename === 'UploadFormularFeld'
                    ? SlotValueType.Upload
                    : SlotValueType.String,
                optional: !feld.pflichtfeld,
              };
            });
        }
        return schritt.slots;
      }),
    [nodes, edges, rollen],
  );
  const allSlotsNames = useMemo(() => allSlots.map((s) => s.name), [allSlots]);
  const {defaultJsonsSlotFormFields, defaultJsonStringFormFields} =
    getDefaultValuesFromExportParts(allSlotsNames, currentExportParts);

  const govManagerBuilder = useFormBuilder<{
    exportFilePartsAsPdf: ProzessEditorSchritt_GovManagerRestExportSchritt['exportFilePartsAsPdf'];
    jsonSlotFormFields: Record<string, JsonSlotFormFieldProps>;
    JsonStringFormFields: JsonStringFormFieldProps[];
  }>({
    defaultValues: {
      jsonSlotFormFields: defaultJsonsSlotFormFields,
      JsonStringFormFields: defaultJsonStringFormFields,
      exportFilePartsAsPdf: exportFilePartsAsPdf ?? false,
    },
  });

  const {formState, fields, clearErrors} = govManagerBuilder;

  const nextJsonSlotFormFields =
    govManagerBuilder.fields.jsonSlotFormFields.$useWatch();
  const nextStringFormFields =
    govManagerBuilder.fields.JsonStringFormFields.$useWatch();

  const jsonStringFromFieldArray =
    govManagerBuilder.fields.JsonStringFormFields.$useFieldArray();

  useEffect(() => {
    clearErrors();
    const allPaths = Object.values(nextJsonSlotFormFields).map(
      ({path}) => path,
    );

    Object.entries(nextJsonSlotFormFields)
      .filter(([, value]) => value.exportField)
      .forEach(([key, value]) => {
        if (value.exportField && !value.path) {
          fields.jsonSlotFormFields[key].$setError(
            {message: `Bitte geben Sie einen Pfad an.`},
            {shouldFocus: false},
          );
          return;
        }

        const badPathRegex = /^\.|\.$|\.\./;
        if (badPathRegex.test(value.path)) {
          fields.jsonSlotFormFields[key].$setError(
            {message: `Bitte geben Sie einen gültigen Pfad an`},
            {shouldFocus: false},
          );
          return;
        }

        const isDuplicate =
          allPaths.filter((path) => path === value.path).length !== 1;
        if (isDuplicate) {
          fields.jsonSlotFormFields[key].$setError(
            {message: 'Gleicher Pfad bereits unter anderem Feld vorhanden.'},
            {shouldFocus: false},
          );
          return;
        }
      });

    const nextParts = dotPathToExportParts(
      allSlots,
      nextJsonSlotFormFields,
      nextStringFormFields,
    );
    on.exportParts.$setValue(nextParts);
  }, [
    allSlots,
    nextJsonSlotFormFields,
    nextStringFormFields,
    fields,
    on.exportParts,
    clearErrors,
  ]);

  useEffect(() => {
    const hasErrors = Object.keys(formState.errors).length !== 0;
    subFormIsValid(!hasErrors);
  }, [formState, subFormIsValid]);

  return (
    <div className='space-y-4'>
      <FormCard heading='GovManager Routing'>
        <InputFormField on={on.vorgangsTyp} label='Vorgangstyp' />
        <InputFormField
          on={on.mandantenSchluessel}
          label='Mandantenschluessel'
        />
        <InputFormField on={on.vorgangsSchluessel} label='Vorgangsschluessel' />
      </FormCard>
      <div className='flex items-center gap-4 font-bold'>
        <h2 className='whitespace-nowrap'>Export Felder</h2>
        <hr className='ml-auto h-px w-full' />
      </div>
      <FormCard heading='Optionen' key={id}>
        <CheckboxFormField
          on={on.exportFilePartsAsPdf}
          label='Bürger Uploads in PDF-Format umwandeln'
        />
      </FormCard>
      <div className='space-y-4'>
        {sharedSlotExportRows.length > 0 && (
          <FormCard heading='Slots in mehreren Formularschritten'>
            <div className='space-y-4'>
              {sharedSlotExportRows.map(({slotName, label}) => (
                <JsonSlotFormField
                  key={slotName}
                  label={label}
                  on={govManagerBuilder.fields.jsonSlotFormFields[slotName]}
                />
              ))}
            </div>
          </FormCard>
        )}
        {schrittExportCards.map(({schrittId, titel, felder}) => (
          <FormCard heading={titel ?? 'Formularschritt'} key={schrittId}>
            <div className='space-y-4'>
              {felder.map(({key, slotName, label}) => (
                <JsonSlotFormField
                  key={key}
                  label={label}
                  on={govManagerBuilder.fields.jsonSlotFormFields[slotName]}
                />
              ))}
            </div>
          </FormCard>
        ))}
        <FormCard heading='Zusätzliche Werte' className='space-y-4'>
          {jsonStringFromFieldArray.fields.map((jsonStringField, index) => (
            <div className='flex w-full gap-4' key={jsonStringField.$key}>
              <JsonStringFormField on={jsonStringField} />
              <button
                type='button'
                onClick={() => jsonStringFromFieldArray.remove(index)}
              >
                <RiDeleteBin6Line className='size-6 text-red-500' />
              </button>
            </div>
          ))}

          <Button
            onClick={() => {
              jsonStringFromFieldArray.append({value: '', path: ''});
            }}
            variant='solid'
            type='button'
            className=' flex w-full items-center justify-center gap-2 bg-gray-300 text-gray-600'
          >
            <MdAddCircleOutline className='size-5' />
            Hinzufügen
          </Button>
        </FormCard>
      </div>
    </div>
  );
};

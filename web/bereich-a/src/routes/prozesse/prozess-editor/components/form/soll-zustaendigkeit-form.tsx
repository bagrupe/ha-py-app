import {type FormBuilder, useFormBuilder} from '@atmina/formbuilder';
import * as Dialog from '@radix-ui/react-dialog';
import * as Tabs from '@radix-ui/react-tabs';
import {type ReactNode, useCallback, useMemo, useState} from 'react';
import {MdAdd, MdInfoOutline} from 'react-icons/md';
import {ZustaendigkeitArt} from 'src/__generated__/graphql';
import {CheckboxFormField} from 'src/components/form/fields/checkbox-field';
import {type CollectionItem} from 'src/components/form/fields/collections';
import {getFieldError} from 'src/components/form/fields/common';
import {InputFormField} from 'src/components/form/fields/input-field';
import {
  SelectField,
  SelectFormField,
} from 'src/components/form/fields/select-field';
import {Modal} from 'src/components/modal/modal';
import {Button} from 'src/components/ui/button';
import {CheckboxCardListFormField} from '../../../../../components/form/fields/checkbox-card-list-field/checkbox-card-list-field.tsx';
import {
  type GhostSchritt,
  type SchrittDaten,
  type SollZustaendigkeit,
} from '../../lib/domain-types.ts';
import {
  type EmailRecipient,
  emailRecipient,
  supportsEmailNotification,
} from '../../lib/email-benachrichtigung.ts';
import {flowToDomain} from '../../lib/flow/flow-to-domain.ts';
import {useProzessEditorStore} from '../../lib/store';
import {
  collectAvailableRollen,
  createProzessVisitor,
} from '../../lib/validate-prozess';
import {useMoeglicheZustaendigeQuery} from '../../prozess-editor.generated';
import {type SchrittSollZustaendigkeitInput} from '../../prozess-version-erstellen.generated';

export type EditableSchrittDaten = Exclude<SchrittDaten, GhostSchritt>;

const ABTEILUNG_FEHLT_IN_OE =
  'Diese Organisationseinheit hat keine Abteilung. Bitte legen Sie zuerst eine Abteilung an.';

/**
 * Mapping der Zuständigkeitsarten zu ihren Anzeigenamen.
 */
export const zustaendigkeitArtNames: {[key in ZustaendigkeitArt]: string} = {
  [ZustaendigkeitArt.Buerger]: 'Bürger',
  [ZustaendigkeitArt.Organisationseinheit]: 'OE',
  [ZustaendigkeitArt.Dienstleister]: 'Dienstl.',
  [ZustaendigkeitArt.Dynamisch]: 'Dynamisch',
};

const zustaendigkeitArtLangnamen: {[key in ZustaendigkeitArt]: string} = {
  [ZustaendigkeitArt.Buerger]: 'Bürger',
  [ZustaendigkeitArt.Organisationseinheit]: 'Organisationseinheit',
  [ZustaendigkeitArt.Dienstleister]: 'Dienstleister',
  [ZustaendigkeitArt.Dynamisch]: 'Dynamisch',
};

/**
 * Tabbed picker for a step's Zuständigkeit, shared with the runtime picker in Anträge.
 * @param valueForArt The value a tab loads when selected, so no field of another Art leaks in.
 * @param children Rendered inside every tab except Bürger, below the Art's own fields.
 */
export const SollZustaendigkeitForm = ({
  on,
  arten,
  schrittId,
  valueForArt,
  langeNamen,
  children,
  abteilungPflicht = false,
}: {
  on: FormBuilder<SchrittSollZustaendigkeitInput>;
  schrittId: string;
  arten: ZustaendigkeitArt[];
  valueForArt: (art: ZustaendigkeitArt) => SchrittSollZustaendigkeitInput;
  langeNamen?: boolean;
  children?: ReactNode;
  abteilungPflicht?: boolean;
}) => {
  const [{data}] = useMoeglicheZustaendigeQuery();

  const sollZustaendigkeit = on.$useWatch();

  const organisationseinheiten = useMemo<
    CollectionItem<string | null>[]
  >(() => {
    if (data?.my.__typename !== 'BackofficeUser') return [];
    return [
      {name: 'Nicht zugeordnet', value: null},
      ...data.my.kommune.organisationseinheiten.map((o) => ({
        name: o.name,
        value: o.id,
      })),
    ];
  }, [data]);

  const gruppen = useMemo(() => {
    if (data?.my.__typename !== 'BackofficeUser') return [];

    const oeId = sollZustaendigkeit.organisationseinheitId;
    const nichtZugeordnet: CollectionItem<string | null>[] = abteilungPflicht
      ? []
      : [{name: 'Nicht zugeordnet', value: null}];
    if (oeId == null) return nichtZugeordnet;

    const oe = data.my.kommune.organisationseinheiten.find(
      (o) => o.id === oeId,
    );
    const gruppenDerOe = oe?.mitarbeiterGruppen ?? [];

    const items: CollectionItem<string | null>[] = gruppenDerOe.map((g) => ({
      name: g.name,
      value: g.id,
    }));

    return [...nichtZugeordnet, ...items];
  }, [data, sollZustaendigkeit.organisationseinheitId, abteilungPflicht]);

  const oeOhneAbteilung =
    abteilungPflicht &&
    sollZustaendigkeit.organisationseinheitId != null &&
    gruppen.length === 0;

  const dienstleister = useMemo<CollectionItem<string | null>[]>(() => {
    if (data?.my.__typename !== 'BackofficeUser') return [];
    const oeId = sollZustaendigkeit.organisationseinheitId;

    const forOe = data.my.kommune.dienstleister.filter(
      (dl) =>
        oeId == null || dl.organisationseinheiten.some((o) => o.id === oeId),
    );

    const selectedId = sollZustaendigkeit.dienstleisterId;
    const items = [...forOe];
    if (selectedId && !items.some((dl) => dl.id === selectedId)) {
      const current = data.my.kommune.dienstleister.find(
        (dl) => dl.id === selectedId,
      );
      if (current) items.push(current);
    }

    return [
      {name: 'Nicht zugeordnet', value: null},
      ...items.map((dl) => ({name: dl.name, value: dl.id})),
    ];
  }, [
    data,
    sollZustaendigkeit.organisationseinheitId,
    sollZustaendigkeit.dienstleisterId,
  ]);

  const {field: oeField} = on.organisationseinheitId.$useController();

  return (
    <div>
      <Tabs.Root
        className='space-y-4 rounded-t-md'
        defaultValue={sollZustaendigkeit.art}
        onValueChange={(value) =>
          on.$setValue(valueForArt(value as ZustaendigkeitArt))
        }
      >
        <Tabs.List className='flex overflow-hidden rounded-t-md border border-gray-200'>
          {arten.map((art) => (
            <Tabs.Trigger
              key={art}
              className='flex grow cursor-pointer select-none items-center justify-center gap-4  border-b-4 border-transparent bg-white p-5 leading-none outline-none first:rounded-tl-md last:rounded-tr-md hover:text-primary data-[state=active]:border-primary data-[state=active]:bg-primary-light/20 data-[state=active]:text-primary'
              value={art}
            >
              {
                (langeNamen
                  ? zustaendigkeitArtLangnamen
                  : zustaendigkeitArtNames)[art]
              }
            </Tabs.Trigger>
          ))}
        </Tabs.List>
        <div className='!mt-0 rounded-b-md border border-t-0 border-gray-200 p-4'>
          <Tabs.Content
            value={ZustaendigkeitArt.Buerger}
            className='flex max-h-[50vh] flex-col'
          >
            <p className='mb-4 flex items-start gap-2 rounded bg-gray-100 p-2 text-sm'>
              <MdInfoOutline className='size-5 shrink-0 text-primary' />
              <span>
                Schritt wird in der App durch einen Bürger bearbeitet.
              </span>
            </p>
          </Tabs.Content>
          <Tabs.Content
            value={ZustaendigkeitArt.Organisationseinheit}
            className='flex max-h-[50vh] flex-col'
          >
            <p className='mb-4 flex items-start gap-2 rounded bg-gray-100 p-2 text-sm'>
              <MdInfoOutline className='size-5 shrink-0 text-primary' />
              <span>
                Schritt wird im Backoffice durch die jeweilige
                Organisationseinheit/Abteilung bearbeitet.
              </span>
            </p>
            <SelectField
              value={oeField.value}
              onChange={(value) => {
                oeField.onChange(value);
                on.mitarbeiterGruppeId.$setValue(null);
              }}
              error={getFieldError(on.organisationseinheitId)}
              required
              items={organisationseinheiten}
              label='Organisationseinheit *'
            />
            <SelectFormField
              on={on.mitarbeiterGruppeId}
              items={gruppen}
              disabled={abteilungPflicht && gruppen.length === 0}
              label={abteilungPflicht ? 'Abteilung *' : 'Abteilung'}
              rules={
                abteilungPflicht
                  ? {
                      validate: (value) =>
                        value != null || 'Bitte wählen Sie eine Abteilung aus.',
                    }
                  : undefined
              }
            />
            {oeOhneAbteilung && (
              <p className='mb-4 text-sm text-red-600'>
                {ABTEILUNG_FEHLT_IN_OE}
              </p>
            )}
            {children}
          </Tabs.Content>
          <Tabs.Content
            value={ZustaendigkeitArt.Dienstleister}
            className='flex max-h-[50vh] flex-col'
          >
            <p className='mb-4 flex items-start gap-2 rounded bg-gray-100 p-2 text-sm'>
              <MdInfoOutline className='size-5 shrink-0 text-primary' />
              <span>
                Schritt wird im Backoffice von einem Externen Dienstleister
                bearbeitet.
              </span>
            </p>
            <SelectField
              value={oeField.value}
              onChange={(value) => {
                oeField.onChange(value);
                on.dienstleisterId.$setValue(null);
              }}
              error={getFieldError(on.organisationseinheitId)}
              required
              items={organisationseinheiten}
              label='Organisationseinheit *'
            />
            <SelectFormField
              on={on.dienstleisterId}
              items={dienstleister}
              disabled={
                sollZustaendigkeit.organisationseinheitId == null &&
                sollZustaendigkeit.dienstleisterId == null
              }
              label='Dienstleister *'
            />
            {children}
          </Tabs.Content>
          <Tabs.Content
            value={ZustaendigkeitArt.Dynamisch}
            className='flex max-h-[50vh] flex-col'
          >
            <p className='mb-4 flex items-start gap-2 rounded bg-gray-100 p-2 text-sm'>
              <MdInfoOutline className='size-5 shrink-0 text-primary' />
              <span>
                <strong className='font-medium'>Ohne Rolle</strong> wird die
                Zuständigkeit vor dem Übergang in diesen Schritt manuell
                gewählt.
                <br />
                <strong className='font-medium'>Mit Rolle</strong> wird die
                Zuständigkeit automatisch aus dieser übernommen.
              </span>
            </p>
            <ZustaendigkeitRolleForm
              schrittId={schrittId}
              on={on.liestRolleId}
              filterValid
              label='Aus Rolle übernehmen'
            />

            <div className='my-2 flex items-center gap-2'>
              <hr className='flex-1' />
              <span className='shrink-0 text-sm text-gray-900'>Oder</span>
              <hr className='flex-1' />
            </div>

            <CheckboxCardListFormField
              label='Erlaubte Zuständigkeiten'
              rules={{
                validate: (value) => {
                  const zustaendigkeiten = value?.length ?? 0;
                  if (
                    zustaendigkeiten < 1 &&
                    !sollZustaendigkeit.liestRolleId
                  ) {
                    return 'Es muss mindestens eine erlaubte Zuständigkeit ausgewählt oder oben eine Rolle übernommen werden.';
                  }
                },
              }}
              items={[
                {
                  id: ZustaendigkeitArt.Dienstleister,
                  name: 'Dienstleister',
                },
                {
                  id: ZustaendigkeitArt.Organisationseinheit,
                  name: 'Organisationseinheiten',
                },
              ]}
              on={on.dynamischeArten}
            />
            {children}
          </Tabs.Content>
        </div>
      </Tabs.Root>
    </div>
  );
};

const RECIPIENT_PHRASES = {
  abteilung: {subject: 'Die gewählte Abteilung', object: 'eine Abteilung'},
  dienstleister: {
    subject: 'Der gewählte Dienstleister',
    object: 'einen Dienstleister',
  },
};

const emailSupportText = (recipient: EmailRecipient | null): string => {
  if (recipient == null) {
    return 'Die zur Laufzeit gewählte Abteilung oder der gewählte Dienstleister wird per E-Mail benachrichtigt, sofern eine E-Mail-Adresse hinterlegt ist.';
  }
  const {subject, object} = RECIPIENT_PHRASES[recipient.kind];
  if (recipient.id == null) {
    return `Wählen Sie zuerst ${object} aus, um die Benachrichtigung zu aktivieren.`;
  }
  if (!recipient.hasEmail) {
    return `${subject} hat keine E-Mail-Adresse. Hinterlegen Sie eine in der Nutzendenverwaltung, um die Benachrichtigung zu aktivieren.`;
  }
  return `${subject} wird per E-Mail benachrichtigt, sobald ein Antrag diesen Schritt erreicht.`;
};

export const EMailBenachrichtigungForm = ({
  on,
}: {
  on: FormBuilder<SollZustaendigkeit>;
}) => {
  const catalog = useProzessEditorStore((state) => state.catalog);
  const sollZustaendigkeit = on.$useWatch();

  if (sollZustaendigkeit == null) return null;

  if (!supportsEmailNotification(sollZustaendigkeit)) return null;

  const recipient = emailRecipient(sollZustaendigkeit, catalog);
  const cannotSend = recipient != null && !recipient.hasEmail;
  const checked = sollZustaendigkeit.versendeEMailAnMitarbeiterGruppe;

  return (
    <CheckboxFormField
      on={on.versendeEMailAnMitarbeiterGruppe}
      orientation='checkbox-left'
      helperText={emailSupportText(recipient)}
      disabled={cannotSend && !checked}
      label='E-Mail Benachrichtigung'
      className='mt-2'
    />
  );
};

/**
 * Formular-Komponente zur Auswahl und Erstellung von zuständigen Rollen.
 * @param schrittId ID des aktuellen Schritts.
 * @param on FormBuilder für die Rollen-ID (string oder null).
 * @param filterValid Optionaler Filter, der nur gültige Rollen anzeigt.
 * @param label Beschriftung des Auswahlfeldes.
 */
export const ZustaendigkeitRolleForm = ({
  schrittId,
  on,
  filterValid,
  label,
}: {
  schrittId: string;
  on: FormBuilder<string | null>;
  filterValid?: boolean;
  label: string;
}) => {
  const nodes = useProzessEditorStore((state) => state.nodes);
  const edges = useProzessEditorStore((state) => state.edges);
  const rollen = useProzessEditorStore((state) => state.metadata.rollen);
  const addRole = useProzessEditorStore((state) => state.addRole);

  const [open, setOpen] = useState(false);
  const formbuilder = useFormBuilder<{name: string}>({
    defaultValues: {name: ''},
  });

  const currentRolleId = on.$useWatch();

  const filtered = useMemo(() => {
    if (!filterValid) return rollen;
    const {schritte, verbindungen} = flowToDomain(nodes, edges, rollen);
    const prozessVisitor = createProzessVisitor(schritte, verbindungen);

    const [incoming] = prozessVisitor.graph[schrittId] ?? [[], []];

    const availableRollenIds = collectAvailableRollen(prozessVisitor, incoming);

    const filtered = rollen.filter((z) => availableRollenIds.includes(z.id));

    if (currentRolleId && !filtered.some((z) => z.id === currentRolleId)) {
      const currentRolle = rollen.find((z) => z.id === currentRolleId)!;
      return [...filtered, currentRolle];
    }

    return filtered;
  }, [currentRolleId, filterValid, nodes, edges, schrittId, rollen]);

  const items = useMemo<CollectionItem<string | null>[]>(
    () => [
      {value: null, name: 'Keine Rolle'},
      ...filtered.map((nz) => ({name: nz.name, value: nz.id})),
    ],
    [filtered],
  );

  const onSubmit = useCallback(() => {
    const values = formbuilder.getValues();
    const zustaendigkeit = addRole(values.name);
    on.$setValue(zustaendigkeit.id);
    setOpen(false);
  }, [addRole, formbuilder, on]);

  return (
    <div className='flex items-center gap-2'>
      <SelectFormField items={items} on={on} label={label} />
      <Dialog.Root open={open} onOpenChange={setOpen}>
        <Dialog.Trigger asChild>
          <Button className='flex h-10 items-center'>
            <MdAdd /> <span>Rolle</span>
          </Button>
        </Dialog.Trigger>
        <Modal title='Rolle erstellen' className='max-w-md'>
          <InputFormField
            on={formbuilder.fields.name}
            label='Name'
            rules={{required: true}}
            onKeyUp={(e) => e.key == 'Enter' && onSubmit()}
          />
          <div className='mt-4 flex items-center justify-end gap-4'>
            <Button
              type='button'
              onClick={() => {
                setOpen(false);
                formbuilder.reset();
              }}
            >
              Abbrechen
            </Button>
            <Button type='button' variant='solid' onClick={onSubmit}>
              Erstellen
            </Button>
          </div>
        </Modal>
      </Dialog.Root>
    </div>
  );
};

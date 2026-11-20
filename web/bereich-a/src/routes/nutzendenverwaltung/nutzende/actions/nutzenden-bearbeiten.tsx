import {useFormBuilder} from '@atmina/formbuilder';
import * as Dialog from '@radix-ui/react-dialog';
import * as Tabs from '@radix-ui/react-tabs';
import {useState, type FC} from 'react';
import {MdAccountCircle} from 'react-icons/md';
import SVG from 'react-inlinesvg';
import {twMerge} from 'tailwind-merge';
import {CheckboxField} from 'src/components/form/fields/checkbox-field/checkbox-field.tsx';
import {Form} from 'src/components/form/form.tsx';
import {Modal} from 'src/components/modal/modal';
import {Button} from 'src/components/ui/button';
import {mutationFailed} from 'src/lib/mutation';
import {
  type BackofficeNutzerArt,
  type FunktionsberechtigungInOrganisationseinheit,
  type GlobaleFunktionsberechtigung,
} from '../../../../__generated__/graphql.ts';
import EditSquare from '../../../../assets/edit-square.svg';
import {SectionHeading} from '../../components/section-heading';
import {
  BackofficeUserOrganisationseinheitenSubform,
  FunktionsberechtigungenSubform,
} from '../../components/zuordnungen.tsx';
import {
  type VerwalteteUntereinheitFragment,
  useUntereinheitenQuery,
} from '../../organisationseinheiten/organisationseinheit.generated';
import {
  useBackofficeUserUpdateMutation,
  type MitarbeiterGruppeFragment,
  type BackofficeUserOrganisationseinheitFragment,
  type FunktionsberechtigungenMetadataFragment,
} from '../nutzende.generated';

/**
 * Eigenschaften für die Nutzenden-Verwalten-Komponente.
 * Enthält den zu bearbeitenden Nutzer, verfügbare Berechtigungen, Gruppen, Update-Callback und optionalen Disabled-Status.
 */
export type NutzenderVerwaltenProps = {
  nutzender: Nutzender;
  availableFunktionsberechtigungen: FunktionsberechtigungenMetadataFragment;
  gruppen: MitarbeiterGruppeFragment[];
  onUpdate: () => void;
  disabled?: boolean;
};

/**
 * Gruppenzugehörigkeit wie sie auf dem Nutzenden in Listenabfragen geliefert wird
 * (nur id/name; volle MitarbeiterGruppe-Metadaten kommen über die `gruppen`-Prop).
 */
type NutzenderZugeordneteGruppe = Pick<
  MitarbeiterGruppeFragment,
  'id' | 'name'
>;

/**
 * Typ für einen Nutzenden mit persönlichen Daten, Gruppen, Organisationseinheiten, Berechtigungen und Nutzerart.
 */
type Nutzender = {
  id: string;
  eMail: string;
  vorname: string;
  nachname: string;
  gruppen: NutzenderZugeordneteGruppe[];
  organisationseinheiten: BackofficeUserOrganisationseinheitFragment[];
  funktionsberechtigungen: GlobaleFunktionsberechtigung[];
  art: BackofficeNutzerArt;
};

/**
 * Typ für die Formular-Daten beim Bearbeiten eines Nutzenden.
 * Enthält globale Berechtigungen, Organisationseinheiten mit Zugehörigkeit und Berechtigungen sowie Abteilungs-IDs.
 */
type NutzendenBearbeitenFormData = {
  funktionsberechtigungen: GlobaleFunktionsberechtigung[];
  organisationseinheiten: Record<
    string,
    {
      zugehoerig: boolean;
      funktionsberechtigungen: FunktionsberechtigungInOrganisationseinheit[];
    }
  >;
  abteilungIds: string[];
};

/**
 * Komponente zur Bearbeitung eines Nutzenden mit Formular und Modal.
 * Zeigt einen Button zum Öffnen des Bearbeitungsdialogs und verwaltet den Zustand.
 * @param nutzender Der zu bearbeitende Nutzer
 * @param gruppen Verfügbare Mitarbeitergruppen
 * @param onUpdate Callback nach erfolgreichem Update
 * @param disabled Optionaler Disabled-Status für den Button
 * @param availableFunktionsberechtigungen Verfügbare Funktionsberechtigungen
 */
export const NutzendenBearbeiten: FC<NutzenderVerwaltenProps> = ({
  nutzender,
  gruppen,
  onUpdate,
  disabled,
  availableFunktionsberechtigungen,
}) => {
  const [{data}] = useUntereinheitenQuery({
    requestPolicy: 'network-only',
  });

  const untereinheiten =
    data?.my.__typename === 'BackofficeUser'
      ? data.my.kommune.untereinheiten
      : [];

  const [, updateBackofficeUser] = useBackofficeUserUpdateMutation();
  const [isOpen, setIsOpen] = useState(false);

  return (
    <Dialog.Root open={isOpen} onOpenChange={setIsOpen}>
      <Dialog.Trigger asChild disabled={disabled}>
        <Button
          variant='text'
          type='button'
          disabled={disabled}
          className='rounded-full px-2 hover:bg-primary/20'
        >
          <SVG src={EditSquare} className='fill-primary' />
        </Button>
      </Dialog.Trigger>

      {isOpen && (
        <NutzendenBearbeitenDialog
          nutzender={nutzender}
          gruppen={gruppen}
          untereinheiten={untereinheiten}
          availableFunktionsberechtigungen={availableFunktionsberechtigungen}
          onSubmit={async (data) => {
            const res = await updateBackofficeUser({
              input: {
                backofficeUserId: nutzender.id,
                assignedGroups: data.abteilungIds,
                funktionsberechtigungen: data.funktionsberechtigungen,
                organisationseinheiten: Object.entries(
                  data.organisationseinheiten,
                )
                  .filter(([, oe]) => oe?.zugehoerig)
                  .map(
                    ([organisationseinheitId, {funktionsberechtigungen}]) => ({
                      organisationseinheitId,
                      nutzerspezifischeFunktionsberechtigungen:
                        funktionsberechtigungen,
                      zugehoerig: true,
                    }),
                  ),
              },
            });

            if (mutationFailed(res)) return;
            if (res.data!.backofficeUserUpdate?.backofficeUser) {
              onUpdate();
              setIsOpen(false);
            }
          }}
        />
      )}
    </Dialog.Root>
  );
};

/**
 * Dialog-Komponente für das Bearbeiten eines Nutzenden.
 * Enthält das Formular mit Tabs für Organisationseinheiten, Abteilungen und globale Berechtigungen.
 * @param nutzender Der zu bearbeitende Nutzer
 * @param onSubmit Callback mit den Formular-Daten bei Absenden
 * @param untereinheiten Verfügbare Organisationseinheiten
 * @param gruppen Verfügbare Mitarbeitergruppen
 * @param availableFunktionsberechtigungen Verfügbare Funktionsberechtigungen
 */
const NutzendenBearbeitenDialog = ({
  nutzender,
  onSubmit,
  untereinheiten: organisationseinheiten,
  gruppen,
  availableFunktionsberechtigungen,
}: {
  nutzender: Nutzender;
  onSubmit: (input: NutzendenBearbeitenFormData) => void;
  untereinheiten: VerwalteteUntereinheitFragment[];
  gruppen: MitarbeiterGruppeFragment[];
  availableFunktionsberechtigungen: FunktionsberechtigungenMetadataFragment;
}) => {
  const backofficeUserFormbuilder = useFormBuilder<NutzendenBearbeitenFormData>(
    {
      defaultValues: {
        organisationseinheiten: Object.fromEntries(
          nutzender.organisationseinheiten.map(
            ({
              organisationseinheitId,
              zugehoerig,
              nutzerspezifischeFunktionsberechtigungen = [],
            }) =>
              [
                organisationseinheitId,
                {
                  zugehoerig,
                  funktionsberechtigungen:
                    nutzerspezifischeFunktionsberechtigungen,
                },
              ] as const,
          ),
        ),
        abteilungIds: nutzender.gruppen.map(({id}) => id),
        funktionsberechtigungen: nutzender.funktionsberechtigungen,
      } satisfies NutzendenBearbeitenFormData,
    },
  );
  const {fields} = backofficeUserFormbuilder;

  const assignedGroups = fields.abteilungIds.$useWatch();

  return (
    <Modal title='Nutzende verwalten' contentClassName='py-0'>
      <Form builder={backofficeUserFormbuilder} onSubmit={onSubmit}>
        <div className='space-y-6'>
          <div className='my-3 flex flex-col rounded-lg border border-neutral-300 bg-neutral-100 p-4 sm:flex-row'>
            <MdAccountCircle className='my-auto mr-7 size-10 text-primary' />
            <div className='flex-col pr-7'>
              <div className='text-sm'>Vorname</div>
              <div className='font-bold'>{nutzender.vorname}</div>
            </div>

            <div className='flex-col pr-7'>
              <div className='text-sm'>Nachname</div>
              <div className='font-bold'>{nutzender.nachname}</div>
            </div>

            <div className='flex-col pr-7'>
              <div className='text-sm'>E-Mail Adresse</div>
              <div className='font-bold'>{nutzender.eMail}</div>
            </div>
          </div>

          <div>
            <Tabs.Root
              className='space-y-4'
              defaultValue='organisationseinheiten'
            >
              <Tabs.List className='flex shrink-0 border-b border-gray-100'>
                <Tabs.Trigger
                  className='flex cursor-default select-none items-center justify-center gap-4  bg-white p-5 leading-none outline-none first:rounded-tl-md last:rounded-tr-md hover:text-primary data-[state=active]:border-b-4 data-[state=active]:border-primary data-[state=active]:bg-primary-light/20 data-[state=active]:text-primary '
                  value='organisationseinheiten'
                >
                  Organisationseinheiten
                </Tabs.Trigger>

                <Tabs.Trigger
                  className='flex cursor-default select-none items-center justify-center gap-4  bg-white p-5 leading-none outline-none first:rounded-tl-md last:rounded-tr-md hover:text-primary data-[state=active]:border-b-4 data-[state=active]:border-primary data-[state=active]:bg-primary-light/20 data-[state=active]:text-primary '
                  value='abteilungen'
                >
                  Abteilungen
                </Tabs.Trigger>

                <Tabs.Trigger
                  className='flex cursor-default select-none items-center justify-center gap-4  bg-white p-5 leading-none outline-none first:rounded-tl-md last:rounded-tr-md hover:text-primary data-[state=active]:border-b-4 data-[state=active]:border-primary data-[state=active]:bg-primary-light/20 data-[state=active]:text-primary '
                  value='globale-funktionsberechtigungen'
                >
                  Funktionsberechtigungen
                </Tabs.Trigger>
              </Tabs.List>

              <Tabs.Content
                value='abteilungen'
                className='flex flex-col space-y-2 '
              >
                <SectionHeading label='Zugehörige Abteilungen:' />

                <div className='flex flex-col gap-2'>
                  {gruppen.map((g) => {
                    const active = assignedGroups.includes(g.id);

                    return (
                      <CheckboxField
                        key={g.id}
                        label={g.name}
                        className={twMerge(
                          'rounded border p-2 hover:border-gray-400 hover:bg-gray-200',
                          active &&
                            'border-primary bg-primary/20 hover:bg-primary/50',
                        )}
                        onChange={() => {
                          if (active) {
                            const indexOfId = assignedGroups.indexOf(g.id);
                            assignedGroups.splice(indexOfId, 1);

                            return backofficeUserFormbuilder.fields.abteilungIds.$setValue(
                              assignedGroups,
                            );
                          } else {
                            return backofficeUserFormbuilder.fields.abteilungIds.$setValue(
                              [...assignedGroups, g.id],
                            );
                          }
                        }}
                        value={assignedGroups.includes(g.id)}
                      />
                    );
                  })}
                </div>
              </Tabs.Content>

              <Tabs.Content value='organisationseinheiten'>
                <BackofficeUserOrganisationseinheitenSubform
                  organisationseinheitenField={fields.organisationseinheiten}
                  currentOrganisationseinheiten={
                    nutzender.organisationseinheiten
                  }
                  availableOrganisationseinheiten={organisationseinheiten}
                  availableFunktionsberechtigungen={
                    availableFunktionsberechtigungen.inOrganisationseinheit
                  }
                  nutzerart={nutzender.art}
                />
              </Tabs.Content>

              <Tabs.Content value='globale-funktionsberechtigungen'>
                <FunktionsberechtigungenSubform
                  on={fields.funktionsberechtigungen}
                  availableFunktionsberechtigungen={
                    availableFunktionsberechtigungen.global
                  }
                />
              </Tabs.Content>
            </Tabs.Root>
          </div>

          <div className='sticky bottom-0 flex justify-end border-t bg-white py-3'>
            <Button variant='outlined'>Übernehmen</Button>
          </div>
        </div>
      </Form>
    </Modal>
  );
};

import * as Dialog from '@radix-ui/react-dialog';
import * as Tabs from '@radix-ui/react-tabs';
import {type FC, useState} from 'react';
import {Modal} from '../../../components/modal/modal.tsx';
import {Button} from '../../../components/ui/button/index.ts';
import {AbteilungenVerwalten} from '../abteilungen/abteilungen-verwalten.tsx';
import {DienstleisterVerwalten} from '../dienstleister/dienstleister-verwalten.tsx';
import {OrganisationseinheitenVerwalten} from '../organisationseinheiten/organisationseinheiten-verwalten.tsx';
import {type MitarbeiterGruppeFragment} from './nutzende.generated.ts';

/**
 * Eigenschaften für die Verwaltung von Gruppen.
 * Enthält eine Liste von Abteilungen und eine Callback-Funktion für Änderungen.
 */
export type GruppenVerwaltenProps = {
  abteilungen: MitarbeiterGruppeFragment[];
  onSaveDeleteOrUpdate: () => void;
};

/**
 * Komponente zur Verwaltung von Organisationseinheiten, Abteilungen und externen Dienstleistern.
 * Zeigt einen Dialog mit Tabs zur Auswahl der jeweiligen Verwaltungsansicht.
 * Standardmäßig unkontrolliert (eigener Button + eigener Open-State). Werden `open`/
 * `onOpenChange` übergeben, wird kein eigener Trigger-Button gerendert - die Sichtbarkeit
 * wird dann komplett vom Aufrufer gesteuert (z.B. von einem `DropdownMenu.Item`, das nicht
 * verschachtelt in einen `Dialog.Trigger` werden darf, da das mit Radix' Fokus-Handling
 * zwischen Dropdown und Dialog kollidiert).
 * @param abteilungen Liste der Abteilungen zur Verwaltung
 * @param onSaveDeleteOrUpdate Callback bei Änderungen an Abteilungen
 * @param canUpdateDienstleister Flag, ob externe Dienstleister verwaltet werden können
 * @param open Kontrollierter Open-State (aktiviert den kontrollierten Modus)
 * @param onOpenChange Callback für Änderungen am kontrollierten Open-State
 */
export const OrganisationseinheitVerwalten: FC<
  GruppenVerwaltenProps & {
    canUpdateDienstleister: boolean;
    open?: boolean;
    onOpenChange?: (open: boolean) => void;
  }
> = ({
  abteilungen,
  onSaveDeleteOrUpdate,
  canUpdateDienstleister,
  open: controlledOpen,
  onOpenChange: controlledOnOpenChange,
}) => {
  const [uncontrolledOpen, setUncontrolledOpen] = useState(false);
  const open = controlledOpen ?? uncontrolledOpen;
  const setOpen = controlledOnOpenChange ?? setUncontrolledOpen;

  return (
    <Dialog.Root open={open} onOpenChange={setOpen}>
      {controlledOpen === undefined && (
        <Dialog.Trigger asChild>
          <Button variant='outlined'>Organisationseinheit verwalten</Button>
        </Dialog.Trigger>
      )}
      <Modal title='Organisationseinheiten verwalten'>
        <Tabs.Root
          className='space-y-4'
          defaultValue='OrganisationseinheitenTab'
        >
          <Tabs.List className='flex shrink-0 overflow-hidden border-b border-gray-100'>
            <Tabs.Trigger
              className='flex cursor-default select-none items-center justify-center gap-4  bg-white p-5 leading-none outline-none first:rounded-tl-md last:rounded-tr-md hover:text-primary data-[state=active]:border-b-4 data-[state=active]:border-primary data-[state=active]:bg-primary-light/20 data-[state=active]:text-primary '
              value='OrganisationseinheitenTab'
            >
              Organisationseinheiten
            </Tabs.Trigger>
            <Tabs.Trigger
              className='flex cursor-default select-none items-center justify-center gap-4  bg-white p-5 leading-none outline-none first:rounded-tl-md last:rounded-tr-md hover:text-primary data-[state=active]:border-b-4 data-[state=active]:border-primary data-[state=active]:bg-primary-light/20 data-[state=active]:text-primary '
              value='AbteilungenTab'
            >
              Abteilungen
            </Tabs.Trigger>
            {canUpdateDienstleister && (
              <Tabs.Trigger
                className='flex cursor-default select-none items-center justify-center gap-4  bg-white p-5 leading-none outline-none first:rounded-tl-md last:rounded-tr-md hover:text-primary data-[state=active]:border-b-4 data-[state=active]:border-primary data-[state=active]:bg-primary-light/20 data-[state=active]:text-primary '
                value='DienstleisterTab'
              >
                Externe Dienstleister
              </Tabs.Trigger>
            )}
          </Tabs.List>
          <Tabs.Content
            value='OrganisationseinheitenTab'
            className='flex max-h-[50vh] flex-col'
          >
            <OrganisationseinheitenVerwalten />
          </Tabs.Content>
          {canUpdateDienstleister && (
            <Tabs.Content
              value='AbteilungenTab'
              className='flex max-h-[50vh] flex-col'
            >
              <AbteilungenVerwalten
                abteilungen={abteilungen}
                onSaveDeleteOrUpdate={onSaveDeleteOrUpdate}
              />
            </Tabs.Content>
          )}
          <Tabs.Content
            value='DienstleisterTab'
            className='flex max-h-[50vh] flex-col'
          >
            <DienstleisterVerwalten />
          </Tabs.Content>
        </Tabs.Root>
      </Modal>
    </Dialog.Root>
  );
};

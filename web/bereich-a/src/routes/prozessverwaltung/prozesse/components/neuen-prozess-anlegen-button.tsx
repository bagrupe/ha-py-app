import {useState} from 'react';
import {Button} from '../../../../components/ui/button';
import {DropdownMenu} from '../../../../components/ui/dropdown-menu/dropdown-menu.tsx';
import {ProzessAnlegenMenuItem} from './prozess/prozess-anlegen-menu-item.tsx';
import {ServicePortalLinkAnlegenMenuItem} from './service-portal-link/service-portal-link-anlegen-menu-item.tsx';

/**
 * Komponente für einen Button, der ein Dropdown-Menü zum Anlegen neuer Prozesse oder Service-Portal-Links öffnet.
 * Verwaltet den Zustand des geöffneten Menüs und schließt es bei Auswahl eines Menüelements.
 */
export const NeuenProzessAnlegenButton = () => {
  const [open, setOpen] = useState(false);

  return (
    <DropdownMenu modal={false} open={open} onOpenChange={setOpen}>
      <DropdownMenu.Trigger asChild>
        <Button>Neuen Prozess anlegen</Button>
      </DropdownMenu.Trigger>
      <DropdownMenu.Portal>
        <DropdownMenu.Content>
          <ProzessAnlegenMenuItem onDismiss={() => setOpen(false)} />
          <ServicePortalLinkAnlegenMenuItem onDismiss={() => setOpen(false)} />
          <DropdownMenu.Arrow />
        </DropdownMenu.Content>
      </DropdownMenu.Portal>
    </DropdownMenu>
  );
};

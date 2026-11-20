import * as Dialog from '@radix-ui/react-dialog';
import {type FC, useCallback, useState} from 'react';
import {DropdownMenu} from '../../../../../components/ui/dropdown-menu/dropdown-menu.tsx';
import {ProzessBearbeitenDialog} from './prozess-bearbeiten-dialog.tsx';

/**
 * Eigenschaften für das Menüelement zum Anlegen eines Prozesses.
 * @param onDismiss Optionale Callback-Funktion, die beim Schließen des Dialogs aufgerufen wird.
 */
type ServicePortalLinkAnlegenMenuItemProps = {
  onDismiss?: () => void;
};

/**
 * Menüelement-Komponente zum Anlegen eines neuen Prozesses.
 * Öffnet einen Dialog zur Bearbeitung eines neuen Prozesses und ruft bei Schließen optional eine Callback-Funktion auf.
 * @param onDismiss Callback, der nach dem Schließen des Dialogs ausgeführt wird.
 */
export const ProzessAnlegenMenuItem: FC<
  ServicePortalLinkAnlegenMenuItemProps
> = ({onDismiss}) => {
  const [open, setOpen] = useState(false);

  const onOpenChange = useCallback(
    (newOpen: boolean) => {
      setOpen(newOpen);
      if (!newOpen) {
        onDismiss?.();
      }
    },
    [onDismiss],
  );

  return (
    <Dialog.Root open={open} onOpenChange={onOpenChange}>
      <Dialog.Trigger asChild>
        {/* https://github.com/radix-ui/primitives/issues/1836#issuecomment-1674338372 */}
        <DropdownMenu.Item onSelect={(e) => e.preventDefault()}>
          Prozess
        </DropdownMenu.Item>
      </Dialog.Trigger>
      <ProzessBearbeitenDialog
        id={null}
        onAfterSave={() => onOpenChange(false)}
      />
    </Dialog.Root>
  );
};

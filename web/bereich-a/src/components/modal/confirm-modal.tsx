import * as Dialog from '@radix-ui/react-dialog';
import {
  type FC,
  createContext,
  useState,
  type ReactElement,
  type ReactNode,
  useRef,
  useCallback,
  useMemo,
  useContext,
} from 'react';
import {Button, type ButtonProps} from '../ui/button';
import {Modal} from './modal';

/**
 * Eigenschaften für die `ConfirmationDialog`-Komponente, die eine Bestätigungsmodale darstellt.
 *
 * @param title - Titel der Modale.
 * @param content - Inhalt der Modale (Text oder JSX-Element).
 * @param confirmText - Label des Bestätigungs-Buttons.
 * @param confirmVariant - Stilvariante des Bestätigungs-Buttons.
 * @param onConfirm - Callback, das ausgeführt wird, wenn der Benutzer bestätigt.
 * @param onCancel - Callback, das ausgeführt wird, wenn der Benutzer abbricht.
 */
export type ConfirmationDialogProps = {
  title?: string;
  content?: string | ReactElement;
  confirmText?: string;
  confirmVariant?: ButtonProps['variant'];
  onConfirm: () => void;
  onCancel: () => void;
};

/**
 * Modalkomponente zur Bestätigung einer Aktion durch den Benutzer.
 *
 * @param props - Eigenschaften wie Titel, Inhalt, Button-Labels und Callback-Funktionen für Bestätigung und Abbruch.
 */
export const ConfirmationDialog = ({
  title,
  content,
  confirmText,
  confirmVariant,
  onConfirm,
  onCancel,
}: ConfirmationDialogProps) => (
  <Dialog.Root
    open
    onOpenChange={(open) => {
      if (!open) {
        onCancel();
      }
    }}
  >
    <Modal title={title ?? 'Bestätigen'} className='max-w-2xl'>
      <div className='flex h-fit w-full flex-col gap-4 p-4 sm:min-w-96'>
        {typeof content === 'string' && <p className='font-bold'>{content}</p>}

        <div className='flex w-full gap-4'>
          <Button
            variant={confirmVariant ?? 'solid'}
            className='flex-1'
            onClick={onConfirm}
          >
            {confirmText ?? 'Bestätigen'}
          </Button>
          <Button variant='outlined' className='flex-1' onClick={onCancel}>
            Abbrechen
          </Button>
        </div>
      </div>
    </Modal>
  </Dialog.Root>
);

/**
 * Eigenschaften für die `confirm`-Methode, ohne `onConfirm` und `onCancel`.
 */
type ConfirmData = Omit<ConfirmationDialogProps, 'onConfirm' | 'onCancel'>;

/**
 * Kontextwert für die `ConfirmContext` mit der `confirm`-Funktion.
 *
 * @param confirm - Funktion, die eine Bestätigungsmodale anzeigt und eine Promise zurückgibt.
 */
export type ConfirmContextValue = {
  confirm: (data: ConfirmData) => Promise<boolean>;
};

/**
 * Kontext für die Bereitstellung der `confirm`-Funktion.
 */
export const ConfirmContext = createContext<ConfirmContextValue | null>(null);

/**
 * Custom Hook, um die `confirm`-Funktion zu verwenden.
 *
 * @throws Fehler, wenn der Hook außerhalb eines `ConfirmContextProvider` verwendet wird.
 *
 * @returns Funktion, um eine Bestätigungsmodale zu öffnen und eine Promise mit der Benutzerentscheidung zu erhalten.
 */
export const useConfirm = () => {
  const value = useContext(ConfirmContext);

  if (!value)
    throw new Error(
      'useConfirm must be used within a ConfirmationContextProvider',
    );

  return value.confirm;
};

/**
 * Eigenschaften für den `ConfirmContextProvider`.
 *
 * @param children - Kinderkomponenten, die innerhalb des Providers gerendert werden.
 */
interface ConfirmContextProviderProps {
  children: ReactNode;
}

/**
 * Kontextprovider für `ConfirmContext`, der die `confirm`-Funktion bereitstellt.
 *
 * Diese Komponente verwaltet die Anzeige von Bestätigungsmodalen und die zugehörige Logik.
 *
 * @param props - Eigenschaften wie Kinderkomponenten.
 */
export const ConfirmContextProvider: FC<ConfirmContextProviderProps> = ({
  children,
}) => {
  const confirmationPromiseRef = useRef<
    [promise: Promise<boolean>, resolve: (confirmed: boolean) => void] | null
  >(null);
  const [confirmData, setConfirmData] = useState<ConfirmData | null>(null);

  const confirm = useCallback((props: ConfirmData) => {
    if (confirmationPromiseRef.current) {
      return confirmationPromiseRef.current[0];
    }

    let resolve: (confirmed: boolean) => void | undefined;
    const promise = new Promise<boolean>((r) => {
      resolve = (c) => {
        r(c);
        confirmationPromiseRef.current = null;
      };
    });

    setConfirmData(props);

    confirmationPromiseRef.current = [promise, resolve!];

    return promise;
  }, []);

  const onDecide = useCallback((confirmed: boolean) => {
    setConfirmData(null);
    confirmationPromiseRef.current?.[1]?.(confirmed);
  }, []);

  return (
    <ConfirmContext.Provider value={useMemo(() => ({confirm}), [confirm])}>
      {children}
      {confirmData && (
        <ConfirmationDialog
          {...confirmData}
          onConfirm={() => onDecide(true)}
          onCancel={() => onDecide(false)}
        />
      )}
    </ConfirmContext.Provider>
  );
};

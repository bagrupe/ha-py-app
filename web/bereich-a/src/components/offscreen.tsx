import {DismissableLayer} from '@radix-ui/react-dismissable-layer';
import {
  createContext,
  type CSSProperties,
  type Dispatch,
  type FC,
  type ReactNode,
  type SetStateAction,
  useContext,
  useState,
} from 'react';
import {useLockBodyScroll} from 'react-use';
import {twMerge} from 'tailwind-merge';

/**
 * Eigenschaften für den MobileMenuWrapper, der ein Offscreen-Menü verwaltet.
 * @param children Inhalt, der im sichtbaren Bereich angezeigt wird.
 * @param offScreen Inhalt des Offscreen-Menüs.
 * @param offScreenWidth Breite des Offscreen-Menüs in Pixel.
 * @param defaultVisible Gibt an, ob das Offscreen-Menü standardmäßig sichtbar ist.
 */
export interface MobileMenuWrapperProps {
  children?: ReactNode;
  offScreen: ReactNode;
  offScreenWidth: number;
  defaultVisible?: boolean;
}

/**
 * Typ für den Kontextwert, der eine Funktion zum Setzen der Sichtbarkeit des Offscreen-Menüs darstellt.
 */
type OffScreenContextValue = Dispatch<SetStateAction<boolean>>;

/**
 * Kontext zur Verwaltung der Sichtbarkeit des Offscreen-Menüs.
 */
const OffScreenContext = createContext<OffScreenContextValue | null>(null);

/**
 * Komponente, die einen Bereich mit einem ausblendbaren Offscreen-Menü umschließt.
 * @param children Sichtbarer Hauptinhalt.
 * @param offScreen Inhalt des Offscreen-Menüs.
 * @param offScreenWidth Breite des Offscreen-Menüs.
 * @param defaultVisible Startzustand der Sichtbarkeit des Menüs.
 * @returns JSX-Element mit Offscreen-Menü und Kontextprovider.
 */
export const OffScreenWrapper: FC<MobileMenuWrapperProps> = ({
  children,
  offScreen,
  offScreenWidth,
  defaultVisible = false,
}) => {
  const [visible, setVisible] = useState(defaultVisible);
  const style: CSSProperties | undefined = visible
    ? {marginLeft: `-${offScreenWidth}px`}
    : undefined;
  useLockBodyScroll(visible);

  return (
    <OffScreenContext.Provider value={setVisible}>
      <div className='relative w-full transition-all' style={style}>
        {children}
        <div
          className={twMerge(
            'fixed inset-0 z-40 transition-all',
            visible
              ? 'pointer-events-auto bg-black/30'
              : 'pointer-events-none bg-transparent',
          )}
        />
      </div>
      <DismissableLayer
        onDismiss={visible ? () => setVisible(false) : undefined}
      >
        <div
          className={twMerge(
            'fixed right-0 top-0 z-40 h-screen border-l border-white/50 shadow-lg transition-all',
            visible ? 'visible' : 'invisible',
          )}
          style={{
            width: offScreenWidth,
            right: visible ? 0 : -offScreenWidth,
          }}
        >
          {offScreen}
        </div>
      </DismissableLayer>
    </OffScreenContext.Provider>
  );
};

/**
 * Hook zum Zugriff auf die Funktion zum Setzen der Sichtbarkeit des Offscreen-Menüs.
 * @throws Fehler, wenn der Kontext nicht vorhanden ist.
 * @returns Funktion zum Ändern der Sichtbarkeit.
 */
export const useOffScreen = () => {
  const setVisible = useContext(OffScreenContext);
  if (!setVisible) {
    throw new Error('Missing OffScreenContext');
  }

  return setVisible;
};

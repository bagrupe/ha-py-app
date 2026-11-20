import {AnimatePresence, motion} from 'framer-motion';
import {memo, type FC, type PropsWithChildren} from 'react';

/**
 * Eigenschaften für die `Sidebar`-Komponente.
 *
 * @param isOpen - Gibt an, ob die Sidebar geöffnet oder geschlossen ist.
 * @param children - Inhalte, die innerhalb der Sidebar gerendert werden.
 */
export type SidebarProps = PropsWithChildren<{isOpen: boolean}>;

/**
 * Sidebar-Komponente mit animiertem Öffnen und Schließen.
 *
 * @param props - Eigenschaften für die Steuerung und Darstellung der Sidebar.
 *
 * Nutzt `framer-motion` für sanfte Animationen bei der Breite der Sidebar, basierend auf dem Offen-/Geschlossen-Status.
 */
export const Sidebar: FC<SidebarProps> = memo(({isOpen, children}) => (
  <AnimatePresence>
    {isOpen && (
      <motion.div
        className='flex h-full flex-col overflow-hidden border-l'
        initial={{width: '0'}}
        animate={{width: '480px'}}
        exit={{width: '0'}}
      >
        {children}
      </motion.div>
    )}
  </AnimatePresence>
));
Sidebar.displayName = 'Sidebar';

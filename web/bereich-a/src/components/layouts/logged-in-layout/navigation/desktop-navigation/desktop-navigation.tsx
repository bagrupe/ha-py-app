import {type FC, type PropsWithChildren} from 'react';
import {useLocation} from 'react-router';
import {twMerge} from 'tailwind-merge';
import {FunktionsberechtigungInOrganisationseinheit} from '../../../../../__generated__/graphql.ts';
import {useKommune} from '../../../../../lib/context/kommune/kommune.tsx';
import {IfFunktionsberechtigung} from '../../../../if-funktionsberechtigung.tsx';
import {Link} from '../../../../link/link.tsx';
import {NavMenu} from '../../../../user-menu/menu-items.tsx';

/**
 * Eigenschaften für die Desktop-Navigationsleiste.
 *
 * @param ausfuehrungenNeuCount - Anzahl der neuen Anträge.
 * @param ausfuehrungenInBearbeitungCount - Anzahl der Anträge in Bearbeitung.
 * @param ausfuehrungenAbgeschlossenCount - Anzahl der abgeschlossenen Anträge.
 */
export type NavigationProps = {
  ausfuehrungenNeuCount?: number;
  ausfuehrungenInBearbeitungCount?: number;
  ausfuehrungenAbgeschlossenCount?: number;
};

/**
 * Desktop-Navigationsleiste für die Verwaltung von Anträgen und Benutzung von Menüs.
 *
 * @param props - Eigenschaften wie Antragszählwerte und Styling.
 *
 * Zeigt ein Logo, mehrere Navigationslinks mit Zähler und ein Benutzer-Menü an.
 */
export const DesktopNavigation: FC<NavigationProps> = ({
  ausfuehrungenNeuCount,
  ausfuehrungenInBearbeitungCount,
  ausfuehrungenAbgeschlossenCount,
}) => {
  const {logoUrl} = useKommune();

  return (
    <div className='hidden h-20 bg-white shadow xl:block print:hidden'>
      <nav className='container flex size-full items-start justify-between gap-8 font-medium text-gray-600'>
        {logoUrl && (
          <img
            src={logoUrl}
            alt='Logo'
            className='max-h-full w-32 flex-1 self-center object-contain object-left py-4'
          />
        )}
        <div className='flex size-full items-center gap-4'>
          <IfFunktionsberechtigung
            funktionsberechtigung={
              FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege
            }
          >
            <div className='flex items-center gap-1 rounded-full bg-gray-100 p-1'>
              <NavItemWithCount
                to='/antraege/neu'
                count={ausfuehrungenNeuCount}
              >
                Neue Anträge
              </NavItemWithCount>
              <NavItemWithCount
                to='/antraege/in-bearbeitung'
                count={ausfuehrungenInBearbeitungCount}
              >
                Anträge in Bearbeitung
              </NavItemWithCount>
              <NavItemWithCount
                to='/antraege/abgeschlossen'
                count={ausfuehrungenAbgeschlossenCount}
              >
                Abgeschlossen
              </NavItemWithCount>
            </div>
          </IfFunktionsberechtigung>
          <NavMenu />
        </div>
      </nav>
    </div>
  );
};

/**
 * Navigationspunkt mit Zähler, der die aktive Route visuell hervorhebt.
 *
 * @param to - Zielroute des Links.
 * @param count - Optional: Zählerwert, der neben dem Link angezeigt wird.
 * @param children - Kind-Elemente, typischerweise der Linkname.
 *
 * Hebt den Link hervor, wenn die aktuelle Route mit der Zielroute übereinstimmt.
 */
const NavItemWithCount: FC<PropsWithChildren<{to: string; count?: number}>> = ({
  to,
  count,
  children,
}) => {
  const isActive = useLocation().pathname === to;

  return (
    <Link
      to={to}
      className={twMerge(
        'flex items-center gap-2 rounded-full px-4 py-2 text-sm font-semibold transition-colors',
        isActive
          ? 'bg-primary text-white shadow-sm'
          : 'text-gray-600 hover:bg-white hover:text-gray-900',
      )}
    >
      {children}
      {!!count && (
        <span
          className={twMerge(
            'inline-flex h-6 min-w-6 items-center justify-center rounded-full px-1.5 text-xs font-bold',
            isActive ? 'bg-white text-primary' : 'bg-white text-gray-500',
          )}
        >
          {count}
        </span>
      )}
    </Link>
  );
};

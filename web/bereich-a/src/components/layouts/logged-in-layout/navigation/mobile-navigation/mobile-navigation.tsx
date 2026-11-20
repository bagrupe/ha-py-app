import {type FC, Fragment, type PropsWithChildren} from 'react';
import {MdLogout} from 'react-icons/md';
import {Link, useLocation} from 'react-router';
import {twMerge} from 'tailwind-merge';
import {FunktionsberechtigungInOrganisationseinheit} from '../../../../../__generated__/graphql.ts';
import {useAuth} from '../../../../../lib/context/auth/auth';
import {IfFunktionsberechtigung} from '../../../../if-funktionsberechtigung.tsx';
import {Link as NavLink} from '../../../../link/link';
import {mainMenuItems, UserMenu} from '../../../../user-menu/menu-items';
import {type NavigationProps} from '../desktop-navigation/desktop-navigation';

/**
 * Mobile Navigationskomponente. Zeigt Navigationspunkte, Benutzerinfos und Logout-Optionen für kleinere Bildschirme.
 *
 * @param ausfuehrungenNeuCount - Anzahl der neuen Anträge.
 * @param ausfuehrungenInBearbeitungCount - Anzahl der Anträge in Bearbeitung.
 * @param ausfuehrungenAbgeschlossenCount - Anzahl der abgeschlossenen Anträge.
 */
export const MobileNavigation: FC<NavigationProps> = ({
  ausfuehrungenNeuCount,
  ausfuehrungenInBearbeitungCount,
  ausfuehrungenAbgeschlossenCount,
}) => {
  const {logout} = useAuth();

  return (
    <div className='relative size-full overflow-y-scroll bg-white text-lg'>
      <div className='flex flex-col items-start'>
        <UserMenu className='px-6 py-4' />
        <IfFunktionsberechtigung
          funktionsberechtigung={
            FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege
          }
        >
          <hr className='w-full' />
          <MobileNavItem to='/antraege/neu' count={ausfuehrungenNeuCount}>
            Neue Anträge
          </MobileNavItem>
          <hr className='w-full' />
          <MobileNavItem
            to='/antraege/in-bearbeitung'
            count={ausfuehrungenInBearbeitungCount}
          >
            Anträge in Bearbeitung
          </MobileNavItem>
          <hr className='w-full' />
          <MobileNavItem
            to='/antraege/abgeschlossen'
            count={ausfuehrungenAbgeschlossenCount}
          >
            Abgeschlossene Anträge
          </MobileNavItem>
        </IfFunktionsberechtigung>
        <hr className='w-full' />
        {mainMenuItems.map(({label, href, external, funktionsberechtigung}) => (
          <Fragment key={label}>
            <IfFunktionsberechtigung
              funktionsberechtigung={funktionsberechtigung}
            >
              <MobileNavItem to={href} external={external}>
                {label}
              </MobileNavItem>
              <hr className='w-full' />
            </IfFunktionsberechtigung>
          </Fragment>
        ))}
        <MobileNavItem
          onClick={logout}
          icon={<MdLogout className='ml-2 inline-block size-6' />}
        >
          Abmelden
        </MobileNavItem>
      </div>
    </div>
  );
};

/**
 * Gemeinsame Eigenschaften für individuelle Navigationspunkte in der mobilen Navigation.
 *
 * @param count - Optional: Zählerwert für den Navigationspunkt.
 * @param icon - Optionales Icon oder Element, das neben dem Navigationspunkt angezeigt wird.
 * @param external - Gibt an, ob der Link extern ist und die Seite neu geladen werden soll.
 */
type CommonNavItemProps = {
  count?: number;
  icon?: React.ReactNode;
  external?: boolean;
};

/**
 * Eigenschaften für einen Navigationspunkt, der auf einen Ziel-Link verweist.
 *
 * @param to - Der Ziel-Pfad für den Navigationspunkt.
 */
type NavItemLinkProps = {
  to: string;
} & CommonNavItemProps;

/**
 * Eigenschaften für einen Navigationspunkt, der eine Aktion (z. B. Logout) ausführt.
 *
 * @param onClick - Funktion, die ausgeführt wird, wenn der Navigationspunkt angeklickt wird.
 */
type NavItemButtonProps = {
  onClick: () => void;
} & CommonNavItemProps;

/**
 * Einzelner Navigationspunkt in der mobilen Navigation, der entweder zu einem Link führt oder eine Aktion ausführt.
 *
 * @param props - Eigenschaften des Navigationspunkts, einschließlich Link- oder Button-spezifischer Eigenschaften.
 *
 * @returns Link oder Button, der den Navigationspunkt darstellt, mit aktivem Zustand oder Zähleroption.
 */
export const MobileNavItem: FC<
  PropsWithChildren<NavItemLinkProps | NavItemButtonProps>
> = (props) => {
  const {pathname} = useLocation();
  const isActive = !props.external && 'to' in props && props.to === pathname;

  const {count, children, icon} = props;

  const NavItemContent = (
    <div className='flex items-center'>
      {isActive && <div className='-ml-4 mr-3 h-6 w-1 rounded-xl bg-primary' />}
      {children}
      {!!count && (
        <div
          className={twMerge(
            'ml-2 inline-flex size-6 items-center justify-center rounded-full text-xs',
            isActive
              ? 'bg-primary-light text-primary'
              : 'bg-gray-100 text-gray-400',
          )}
        >
          {count}
        </div>
      )}
      {icon}
    </div>
  );

  return 'onClick' in props ? (
    <button className='px-6 py-4 font-bold' onClick={props.onClick}>
      {NavItemContent}
    </button>
  ) : props.external ? (
    <Link
      to={props.to}
      reloadDocument={props.external}
      className='h-auto px-6 py-4 font-bold'
    >
      {NavItemContent}
    </Link>
  ) : (
    <NavLink to={props.to} className='h-auto px-6 py-4'>
      {NavItemContent}
    </NavLink>
  );
};

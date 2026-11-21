import {
  useMemo,
  type FC,
  type ReactNode,
  type RefAttributes,
  forwardRef,
  type ElementRef,
} from 'react';
import {
  MdAccountCircle,
  MdAccountTree,
  MdArchive,
  MdArrowDropDown,
  MdDashboardCustomize,
  MdDeleteOutline,
  MdHomeWork,
  MdLogout,
  MdMenu,
  MdOutlineEditNote,
  MdReportProblem,
  MdSettings,
} from 'react-icons/md';
import {RiShieldKeyholeLine} from 'react-icons/ri';
import {Link, type LinkProps} from 'react-router';
import {twMerge} from 'tailwind-merge';
import {hasFunktionsberechtigungInAnyOrganisationseinheit} from 'src/lib/funktionsberechtigung.ts';
import {
  FunktionsberechtigungInOrganisationseinheit,
  GlobaleFunktionsberechtigung,
} from '../../__generated__/graphql.ts';
import {useAuth} from '../../lib/context/auth/auth.tsx';
import {DropdownMenu} from '../ui/dropdown-menu/dropdown-menu.tsx';

/**
 * Hauptmenüeinträge mit Label, Ziel-URL, Icon, optionalem externen Link und erforderlicher Funktionsberechtigung.
 */
export const mainMenuItems: {
  label: string;
  href: string;
  icon: ReactNode;
  external?: boolean;
  funktionsberechtigung?:
    | GlobaleFunktionsberechtigung
    | FunktionsberechtigungInOrganisationseinheit;
}[] = [
  {
    label: 'Nutzendenverwaltung',
    href: '/nutzendenverwaltung',
    icon: <MdAccountCircle />,
    funktionsberechtigung:
      FunktionsberechtigungInOrganisationseinheit.BackofficeNutzendenverwaltung,
  },
  {
    label: 'Lagen',
    href: '/lage',
    icon: <MdReportProblem />,
    funktionsberechtigung: GlobaleFunktionsberechtigung.LageHelfer,
  },
  {
    label: 'Archiv',
    href: '/archiv',
    icon: <MdArchive />,
    funktionsberechtigung: GlobaleFunktionsberechtigung.ArchivEinsicht,
  },
  {
    label: 'Papierkorb',
    href: '/papierkorb',
    icon: <MdDeleteOutline />,
    funktionsberechtigung: GlobaleFunktionsberechtigung.AntragLoeschung,
  },
  {
    label: 'Aufbewahrung verwalten',
    href: '/einstellungen/aufbewahrung',
    icon: <MdSettings />,
    funktionsberechtigung: GlobaleFunktionsberechtigung.AufbewahrungVerwaltung,
  },
  {
    label: 'Inhaltspflege',
    href: '/cms/admin',
    icon: <MdDashboardCustomize />,
    external: true,
    funktionsberechtigung:
      FunktionsberechtigungInOrganisationseinheit.Inhaltspflege,
  },
  {
    label: 'Prozessverwaltung',
    href: '/prozessverwaltung',
    icon: <MdOutlineEditNote />,
    funktionsberechtigung: GlobaleFunktionsberechtigung.Prozessverwaltung,
  },
  {
    label: 'Mängelmelder-Kategorien',
    href: '/prozessverwaltung/kategoriebaum',
    icon: <MdAccountTree />,
    funktionsberechtigung:
      FunktionsberechtigungInOrganisationseinheit.MaengelmelderZustaendigkeitsverwaltung,
  },
];

/**
 * Navigationsmenü-Komponente, die das Benutzer-Menü, verfügbare Hauptmenüeinträge und Logout-Button anzeigt.
 * Filtert Menüeinträge basierend auf den Berechtigungen des angemeldeten Nutzers.
 * @returns JSX.Element mit der Navigationsleiste
 */
export const NavMenu = () => {
  const {logout, user} = useAuth();

  const links = useMemo(
    () =>
      mainMenuItems.filter((link) =>
        hasFunktionsberechtigungInAnyOrganisationseinheit(
          user,
          link.funktionsberechtigung,
        ),
      ),
    [user],
  );

  return (
    <div className='ml-auto flex items-center gap-1 justify-self-end'>
      <UserMenu />
      {links.length > 0 && (
        <div className='relative flex h-full items-center'>
          <DropdownMenu>
            <DropdownMenu.Trigger>
              <span className='flex size-10 items-center justify-center rounded-full text-gray-500 transition-colors hover:cursor-pointer hover:bg-gray-100 hover:text-gray-900'>
                <MdMenu className='size-6' />
              </span>
            </DropdownMenu.Trigger>
            <DropdownMenu.Portal>
              <DropdownMenu.Content>
                {links.map(({label, href, external, icon}) => (
                  <DropdownMenu.Item key={label} asChild>
                    <MenuItem to={href} external={external}>
                      <span>{icon}</span>
                      <span>{label}</span>
                    </MenuItem>
                  </DropdownMenu.Item>
                ))}
                <DropdownMenu.Arrow />
              </DropdownMenu.Content>
            </DropdownMenu.Portal>
          </DropdownMenu>
        </div>
      )}
      <button
        type='button'
        className='flex items-center gap-2 rounded-full px-4 py-2 font-medium text-primary transition-colors hover:bg-primary/10'
        onClick={() => logout()}
      >
        <MdLogout className='size-6' />
        Abmelden
      </button>
    </div>
  );
};

/**
 * Benutzer-Menü-Komponente mit Anzeige von Nutzername, Organisationseinheiten und Passwort-Zurücksetzen-Link.
 * @param props.mobile Optional, ob das Menü für mobile Ansicht angepasst werden soll
 * @param props.className Optionale CSS-Klassen für das Trigger-Element
 * @returns JSX.Element mit dem Dropdown-Menü für den Nutzer
 */
export const UserMenu: FC<{mobile?: boolean; className?: string}> = ({
  className,
}) => {
  const {user} = useAuth();

  const vorname = user?.vorname;
  const nachname = user?.nachname;

  const organisationseinheiten =
    user && 'organisationseinheiten' in user ? user.organisationseinheiten : [];

  const organisationseinheitTextShort =
    organisationseinheiten.length === 1
      ? organisationseinheiten[0].meta.name
      : `${organisationseinheiten.length} Organisationseinheiten`;

  return (
    <DropdownMenu>
      <DropdownMenu.Trigger>
        <div
          className={twMerge(
            'flex items-center gap-2 rounded-full py-1.5 pl-1.5 pr-3 transition-colors hover:cursor-pointer hover:bg-gray-100',
            className,
          )}
        >
          <MdAccountCircle className='my-auto size-10 text-primary' />
          <div className='flex flex-col text-left'>
            {vorname && nachname && (
              <p className='font-bold'>{`${vorname.at(0)}. ${nachname}`}</p>
            )}
            <div className='text-xs text-gray-500'>
              {organisationseinheitTextShort}
            </div>
          </div>
          <MdArrowDropDown className='text-gray-400' />
        </div>
      </DropdownMenu.Trigger>
      <DropdownMenu.Portal>
        <DropdownMenu.Content>
          {organisationseinheiten.length > 1 && (
            <div className='mb-2 flex items-start gap-2 border-b border-gray-100 px-5 pb-2 text-gray-400'>
              <MdHomeWork className='mt-1' />
              <div className='whitespace-pre-wrap'>
                {organisationseinheiten.map((o) => o.meta.name).join('\n')}
              </div>
            </div>
          )}
          <DropdownMenu.Item asChild>
            <Link
              to='/profile/reset-password'
              className='flex items-center gap-2'
            >
              <RiShieldKeyholeLine />
              Passwort zurücksetzen
            </Link>
          </DropdownMenu.Item>
          <DropdownMenu.Arrow />
        </DropdownMenu.Content>
      </DropdownMenu.Portal>
    </DropdownMenu>
  );
};

/**
 * Menüeintrag-Komponente, die einen Link mit optionalem externen Verhalten rendert.
 * @param props.to Ziel-URL des Links
 * @param props.external Gibt an, ob der Link extern ist und ein Neuladen der Seite erzwingen soll
 * @param props.children Inhalt des Menüeintrags
 * @param ref Referenz auf das Link-Element
 * @returns JSX.Element mit dem Link als Menüeintrag
 */
const MenuItem = forwardRef<
  ElementRef<typeof Link>,
  LinkProps & RefAttributes<HTMLAnchorElement> & {external?: boolean}
>(({to, external, children, ...props}, ref) => (
  <Link
    {...props}
    ref={ref}
    to={to}
    className='group relative flex cursor-pointer select-none items-center gap-2 rounded-[3px] px-5 py-2 leading-none text-gray-600 outline-none hover:bg-primary/15 data-[disabled]:pointer-events-none data-[disabled]:opacity-50'
    reloadDocument={external}
  >
    {children}
  </Link>
));

MenuItem.displayName = 'MenuItem';

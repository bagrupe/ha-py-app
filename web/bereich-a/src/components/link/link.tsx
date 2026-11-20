import {type FC, type PropsWithChildren} from 'react';
import {NavLink} from 'react-router';
import {twMerge} from 'tailwind-merge';

/**
 * Eigenschaften für die `Link`-Komponente.
 *
 * @param to - Zielroute des Links.
 * @param className - Zusätzliche CSS-Klassen zum Anpassen des Link-Stylings.
 * @param children - Inhalt des Links, z. B. Text oder Kinderkomponenten.
 */
export type LinkProps = PropsWithChildren<{
  to: string;
  className?: string;
}>;

/**
 * Erweiterte Link-Komponente, die den aktiven Zustand visuell hervorhebt.
 *
 * @param props - Eigenschaften für die Darstellung des Links.
 *
 * Nutzt `NavLink` von `react-router-dom` und fügt eine Stilregel für aktive Links hinzu.
 */
export const Link: FC<LinkProps> = ({to, children, className}) => (
  <NavLink
    to={to}
    className={({isActive}) =>
      twMerge(
        'flex h-16 items-center pt-1 font-bold',
        isActive && `text-primary`,
        className,
      )
    }
  >
    {children}
  </NavLink>
);

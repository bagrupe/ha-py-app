import range from 'lodash/range';
import {type FC, type ReactNode} from 'react';
import {NavLink} from 'react-router';
import {twMerge} from 'tailwind-merge';

/**
 * Äußerer Rahmen einer responsiven Liste (Tabelle ab `lg`, gestapelte Karten darunter).
 */
export const ResponsiveListContainer: FC<{
  className?: string;
  children: ReactNode;
}> = ({className, children}) => (
  <div
    className={twMerge(
      'overflow-hidden rounded-xl border border-gray-300 bg-white',
      className,
    )}
  >
    {children}
  </div>
);

/**
 * Kopfzeile einer responsiven Liste – nur ab `lg` sichtbar, folgt `gridCols`.
 */
export const ResponsiveListHeader: FC<{
  gridCols: string;
  className?: string;
  children: ReactNode;
}> = ({gridCols, className, children}) => (
  <div
    className={twMerge(
      'hidden items-center gap-4 border-b border-gray-300 bg-gray-100 px-4 py-3 text-xs font-bold uppercase tracking-wide text-gray-700 lg:grid',
      gridCols,
      className,
    )}
  >
    {children}
  </div>
);

/**
 * Eine Zeile einer responsiven Liste: Zebra-Streifen + `gridCols`-Raster ab `lg`.
 * Mit `to` wird die gesamte Zeile ein klickbarer `NavLink` (z.B. Anträge); ohne `to`
 * ist es ein einfacher Container, damit Zeilen mit eigenen Buttons/Dialogen (z.B.
 * Nutzendenverwaltung, Prozessverwaltung) nicht in einen Link eingeschlossen werden.
 */
export const ResponsiveListRow: FC<{
  even: boolean;
  gridCols: string;
  to?: string;
  className?: string;
  children: ReactNode;
}> = ({even, gridCols, to, className, children}) => {
  const rowClassName = twMerge(
    'group grid gap-2 border-t border-gray-200 px-4 py-3 transition-colors hover:bg-primary/10 lg:items-center lg:gap-4',
    even ? 'bg-gray-100' : 'bg-white',
    gridCols,
    className,
  );

  if (to) {
    return (
      <NavLink
        to={to}
        className={twMerge(
          'focus:outline-none focus-visible:bg-primary/10',
          rowClassName,
        )}
      >
        {children}
      </NavLink>
    );
  }

  return <div className={rowClassName}>{children}</div>;
};

/**
 * Ein Feld einer Zeile: zeigt auf schmalen Screens ein Label, ab `lg` nur den Wert.
 */
export const ResponsiveField: FC<{
  label: string;
  children: ReactNode;
  className?: string;
}> = ({label, children, className}) => (
  <div className={twMerge('min-w-0', className)}>
    <div className='mb-0.5 text-xs font-semibold uppercase tracking-wide text-gray-500 lg:hidden'>
      {label}
    </div>
    <div className='break-words text-gray-900'>{children}</div>
  </div>
);

/**
 * Liefert die Indizes der zu rendernden Zeilen-Slots: solange geladen wird, bleibt die
 * Anzahl auf der gewählten Seitengröße stehen (stabile Skeleton-Höhe), danach die Anzahl
 * der tatsächlich vorhandenen Einträge.
 */
export const responsiveListSlots = (
  loading: boolean,
  seitengroesse: number,
  actualLength: number,
): number[] => range(loading ? seitengroesse : actualLength);

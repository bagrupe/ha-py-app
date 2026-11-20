import {type FC, type ReactNode} from 'react';
import {twMerge} from 'tailwind-merge';

/**
 * Einheitlicher äußerer Rahmen für Bereich-A-Übersichtsseiten (Anträge, Nutzendenverwaltung,
 * Prozessverwaltung, Einstellungen, Archiv).
 */
export const PageShell: FC<{className?: string; children: ReactNode}> = ({
  className,
  children,
}) => (
  <div className={twMerge('container flex flex-col gap-4 py-8', className)}>
    {children}
  </div>
);

/**
 * Einheitlicher Seitenkopf: Titel + optionale Beschreibung links, optionale Aktionen
 * (Buttons) rechts.
 */
export const PageHeader: FC<{
  title: string;
  description?: ReactNode;
  actions?: ReactNode;
  className?: string;
}> = ({title, description, actions, className}) => (
  <div
    className={twMerge(
      'flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between',
      className,
    )}
  >
    <hgroup className={twMerge('min-w-0', actions ? 'max-w-2xl' : undefined)}>
      <h1 className='text-2xl font-bold'>{title}</h1>
      {description && <p className='text-gray-600'>{description}</p>}
    </hgroup>
    {actions && (
      <div className='flex shrink-0 flex-wrap content-center gap-4'>
        {actions}
      </div>
    )}
  </div>
);

import {type PropsWithChildren} from 'react';
import {twMerge} from 'tailwind-merge';

/**
 * Eigenschaften für die Komponente FormCard.
 * Enthält optional eine Überschrift und zusätzliche CSS-Klassen.
 */
export type FormCardProps = PropsWithChildren<{
  heading?: string | null;
  className?: string;
}>;

/**
 * Komponente zur Darstellung einer Formular-Karte mit optionaler Überschrift.
 * Umschließt den Inhalt in einem gestylten Container mit Abstand und Hintergrund.
 * @param heading Überschrift der Karte, optional
 * @param children Inhalt der Karte
 * @param className Zusätzliche CSS-Klassen für den Container
 */
export const FormCard = ({heading, children, className}: FormCardProps) => (
  <div className={twMerge('space-y-4 rounded-md bg-gray-100 p-4', className)}>
    {heading && (
      <div className='flex items-center gap-4 font-bold'>
        <h2>{heading}</h2>
        <hr className='ml-auto h-px grow' />
      </div>
    )}
    {children}
  </div>
);

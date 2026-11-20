import {type PropsWithChildren} from 'react';
import {twMerge} from 'tailwind-merge';

/**
 * Typ für die Eigenschaften der Card-Komponente.
 * Ermöglicht das optionale Übergeben zusätzlicher CSS-Klassen.
 */
export type CardProps = {
  className?: string;
};

/**
 * Komponente zur Darstellung einer stilisierten Karte mit Rahmen und Innenabstand.
 * @param children Die einzuschließenden Kind-Elemente
 * @param className Optionale zusätzliche CSS-Klassen zur Anpassung des Stils
 */
export const Card = ({children, className}: PropsWithChildren<CardProps>) => (
  <div className={twMerge('rounded border p-2', className)}> {children}</div>
);

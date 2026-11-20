import {twMerge} from 'tailwind-merge';

/**
 * Komponente zur Darstellung eines animierten Platzhalters (Skeleton) für Ladezustände.
 * @param className Optionale zusätzliche CSS-Klassen zur Anpassung des Stils.
 */
export const Skeleton = ({className}: {className?: string}) => (
  <div
    className={twMerge('h-4 animate-pulse rounded bg-gray-300', className)}
  />
);

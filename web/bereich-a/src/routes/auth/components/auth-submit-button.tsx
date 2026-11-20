import {forwardRef} from 'react';
import {twMerge} from 'tailwind-merge';
import {Button, type ButtonProps} from '../../../components/ui/button';

/**
 * Primärer Aktions-Button für die Auth-Seiten (Anmelden, Passwort zurücksetzen,
 * Registrieren, ...). Einheitlich gefüllt statt nur umrandet, mit dezentem Schatten und
 * leichtem Anheben beim Hover, damit er sich von der Glas-Karte im Hintergrund abhebt.
 */
export const AuthSubmitButton = forwardRef<HTMLButtonElement, ButtonProps>(
  ({className, ...props}, ref) => (
    <Button
      ref={ref}
      variant='solid'
      className={twMerge(
        'mt-4 w-full rounded-xl py-3 text-base font-semibold shadow-lg shadow-primary/30 transition-all duration-200 hover:-translate-y-0.5 hover:shadow-xl hover:shadow-primary/40 active:translate-y-0',
        className,
      )}
      {...props}
    />
  ),
);
AuthSubmitButton.displayName = 'AuthSubmitButton';

import {type FC} from 'react';
import SVG from 'react-inlinesvg';

/**
 * Eigenschaften für die `IconWithCallbackButton`-Komponente.
 *
 * @param onClick - Callback-Funktion, die bei einem Klick auf den Button ausgelöst wird.
 * @param iconSrc - Pfad oder URL zur SVG-Datei, die als Icon angezeigt wird.
 * @param disabled - Deaktivierungsstatus des Buttons.
 */
export const IconWithCallbackButton: FC<{
  onClick: () => void;
  iconSrc: string;
  disabled?: boolean;
}> = ({onClick, iconSrc, disabled}) => (
  <button
    className='material-symbols-outlined flex gap-2 text-primary disabled:opacity-50'
    onClick={onClick}
    disabled={disabled}
  >
    <SVG src={iconSrc} className='fill-primary' />
  </button>
);

import {
  type ComponentPropsWithoutRef,
  type FC,
  type ReactNode,
  useId,
} from 'react';
import {twMerge} from 'tailwind-merge';

/**
 * Eigenschaften für die `FloatingLabelOutline`-Komponente, ein Container für Eingabefelder mit schwebendem Label und Fehleranzeige.
 *
 * @param label - Beschriftung des Feldes, das bei Benutzerfokus oder Eingabe schwebt.
 * @param error - Fehlertext oder boolean, um den Fehlerzustand anzuzeigen. Fehlertext wird unterhalb des Felds angezeigt.
 * @param shrinkLabel - Gibt an, ob das Label standardmäßig geschrumpft dargestellt werden soll.
 * @param fieldsetClass - Zusätzliche CSS-Klassen für das Fieldset.
 * @param startAdornment - Optionaler Inhalt, der links vom Eingabefeld angezeigt wird (z. B. ein Icon).
 * @param endAdornment - Optionaler Inhalt, der rechts vom Eingabefeld angezeigt wird (z. B. ein Icon).
 * @param children - Funktion, die das Eingabefeld rendert und die generierte `id` als Argument erhält.
 * @param className - Zusätzliche CSS-Klassen für den Container.
 */
export type FloatingLabelOutlineProps = Omit<
  ComponentPropsWithoutRef<'div'>,
  'children'
> & {
  label?: string;
  error?: string | true;
  shrinkLabel?: boolean;
  fieldsetClass?: string;
  startAdornment?: ReactNode;
  endAdornment?: ReactNode;
  children: (id: string) => ReactNode;
};

/**
 * Container-Komponente für Eingabefelder mit schwebendem Label, Fehleranzeige und optionalem Start- und Endinhalt.
 *
 * @param props - Eigenschaften wie Label, Fehlerzustand und Dekorationselemente für den Container.
 *
 * Unterstützt Felder mit schwebenden Labels, die sich basierend auf dem Benutzerfokus oder der Eingabe animieren.
 * Zeigt zusätzlich Fehlertext und Start-/End-Inhalte, wie Icons, an.
 */
export const FloatingLabelOutline: FC<FloatingLabelOutlineProps> = ({
  label,
  error,
  className,
  fieldsetClass,
  startAdornment,
  endAdornment,
  children,
  shrinkLabel,
  ...rest
}) => {
  const id = useId();

  return (
    <div
      className={twMerge(
        'group/float-label relative isolate my-2 flex cursor-text rounded bg-white',
        error && '!mb-8',
        className,
      )}
      {...rest}
    >
      {startAdornment && (
        <div className='flex min-w-[40px] shrink-0 items-center justify-center overflow-hidden rounded-l'>
          {typeof startAdornment === 'string' ? (
            <div className='pl-3 pr-2'>{startAdornment}</div>
          ) : (
            startAdornment
          )}
        </div>
      )}

      {children(id)}
      {endAdornment && (
        <div className='ml-auto flex min-w-[40px] shrink-0 items-center justify-center overflow-hidden rounded-r'>
          {typeof endAdornment === 'string' ? (
            <div className='pl-2 pr-3'>{endAdornment}</div>
          ) : (
            endAdornment
          )}
        </div>
      )}

      {!startAdornment && label && (
        <label
          className={twMerge(
            'pointer-events-none absolute left-0 top-0 z-10 max-w-[calc(114%-32px)] origin-top-left -translate-y-2 translate-x-3.5 scale-[0.875] select-none truncate text-gray-700 transition-all',
            shrinkLabel === false &&
              'max-w-[calc(100%-26px)] translate-y-2 scale-100',
            shrinkLabel === undefined &&
              'group-focus-within/float-label:!max-w-[calc(114%-32px)] group-focus-within/float-label:!-translate-y-2 group-focus-within/float-label:!scale-[0.875] group-focus-within/float-label:text-primary peer-placeholder-shown:max-w-[calc(100%-26px)] peer-placeholder-shown:translate-y-2 peer-placeholder-shown:scale-100',
            error && '!text-red-600',
          )}
          htmlFor={id}
        >
          {label}
        </label>
      )}

      <fieldset
        className={twMerge(
          'absolute inset-0 -top-2.5 -z-10 box-content min-w-0 rounded border border-gray-400 px-2 text-sm group-focus-within/float-label:border-2 group-focus-within/float-label:border-primary peer-disabled:bg-gray-50',
          error && '!border-red-600',
          !startAdornment && 'peer-placeholder-shown:[&>legend]:max-w-0',
          fieldsetClass,
        )}
      >
        <legend
          className={twMerge(
            'max-w-full overflow-hidden transition-[max-width] duration-100',
            !startAdornment && 'text-transparent',
            !!startAdornment && 'group-focus-within/float-label:text-primary',
            shrinkLabel === false && 'max-w-0',
            shrinkLabel === undefined &&
              'group-focus-within/float-label:!max-w-full',
            !label && 'w-0',
          )}
        >
          <span className='relative -left-0.5 -top-1.5 whitespace-nowrap px-2 text-sm'>
            {label}
          </span>
        </legend>
      </fieldset>

      {typeof error === 'string' && (
        <span className='absolute left-0 top-10 rounded-lg p-2 text-sm text-red-600'>
          {error}
        </span>
      )}
    </div>
  );
};

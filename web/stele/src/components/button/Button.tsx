import {type ComponentPropsWithoutRef, forwardRef, type ReactNode} from 'react';
import {tv, type VariantProps} from 'tailwind-variants';

/**
 * Definiert die Designvarianten des Buttons.
 *
 * @param base - Grundlegende Stile für alle Buttons.
 * @param variants - Konfigurierbare Varianten wie `variant` (Art des Buttons).
 * @param defaultVariants - Standardvarianten, die verwendet werden, wenn keine angegeben sind.
 */
export const buttonVariants = tv({
  base: 'relative rounded px-4 py-2 outline-none focus-visible:ring-2 focus-visible:ring-primary/50 enabled:hover:shadow active:text-primary active:shadow-none',
  variants: {
    variant: {
      outlined:
        'border border-primary bg-white text-primary enabled:hover:bg-primary/20',
      'outlined-secondary':
        'border border-gray-400 bg-transparent text-gray-600 enabled:hover:bg-gray-200',
      solid: 'bg-primary text-white',
      toggle:
        'border border-primary data-[pressed]:border-transparent bg-white data-[pressed]:bg-primary text-primary data-[pressed]:text-white rounded-none py-0 h-full whitespace-nowrap',
      text: 'text-primary font-bold enabled:hover:shadow-none',
      'text-secondary':
        'text-gray-900 enabled:hover:shadow-none active:text-gray-700',
      destructive: 'bg-red-500 font-semibold text-white active:text-red-200',
    },
    disabled: {
      true: 'cursor-default opacity-50',
    },
  },
  defaultVariants: {
    variant: 'outlined',
  },
});

/**
 * Typ für die Designvarianten des Buttons.
 */
type ButtonVariants = VariantProps<typeof buttonVariants>;

/**
 * Eigenschaften für die `Button`-Komponente.
 *
 * @param variant - Stilvariante des Buttons (z. B. `outlined`, `solid`, etc.).
 * @param endAdornment - Zusätzliche Inhalte (z. B. Icon) am Ende des Buttons.
 * @param rest - Zusätzliche Eigenschaften, die an das Button-Element weitergegeben werden.
 */
export type ButtonProps = ComponentPropsWithoutRef<'button'> &
  ButtonVariants & {submittingState?: boolean; endAdornment?: ReactNode};

/**
 * Reusable Button-Komponente mit Unterstützung für mehrere Designvarianten und Ladezustand.
 *
 * @param props - Eigenschaften wie Stilvarianten, Deaktivierung, Ladezustand und optionale Enddekoration.
 *
 * Unterstützt das Anzeigen eines visuellen Ladezustands (Spinner), basierend auf `react-hook-form` oder explizit über `submittingState`.
 */
export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({variant, className, children, endAdornment, ...rest}, ref) => (
    <button
      {...rest}
      ref={ref}
      className={buttonVariants({
        variant,
        className,
      })}
    >
      <div className='flex items-center justify-center'>
        {children}
        {endAdornment && (
          <div className='ml-2 size-6 [&>*]:size-full'>{endAdornment}</div>
        )}
      </div>
    </button>
  ),
);
Button.displayName = 'Button';

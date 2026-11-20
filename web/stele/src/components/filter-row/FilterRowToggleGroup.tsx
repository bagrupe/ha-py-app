import {Toggle} from '@base-ui/react/toggle';
import {ToggleGroup} from '@base-ui/react/toggle-group';
import {
  dayLabel,
  longDateFormatter,
  toDayTokenIso,
} from '../../utils/timeUtils';
import {Button} from '../button/Button';

/** ISO 8601 datetime string from `Date.prototype.toISOString()`. */
export type FilterRowValue = string;

interface FilterRowToggleGroupProps {
  value?: FilterRowValue;
  defaultValue?: FilterRowValue;
  className?: string;
  onValueChange?: (value: FilterRowValue) => void;
}

/**
 * FilterRowToggleGroup component for the filter row.
 * Contains two buttons, for today and tomorrow.
 *
 * @param value The selected value. Use if controlling the component from outside.
 * @param defaultValue The default value. Use if not controlling the component from outside.
 * @param className The class name to apply to the root of the component.
 * @param onValueChange The callback to call when the value changes.
 *
 * @returns A toggle group with two buttons for today and tomorrow.
 */
export default function FilterRowToggleGroup({
  value,
  defaultValue,
  className,
  onValueChange,
}: FilterRowToggleGroupProps) {
  const today = new Date();
  const tomorrow = new Date();
  tomorrow.setDate(today.getDate() + 1);
  const todayValue = toDayTokenIso(today);
  const tomorrowValue = toDayTokenIso(tomorrow);
  const resolvedDefault = defaultValue ?? todayValue;

  return (
    <ToggleGroup
      value={value !== undefined ? [value] : undefined}
      defaultValue={value === undefined ? [resolvedDefault] : undefined}
      className={['flex h-11 w-full min-w-0 flex-row', className]
        .filter(Boolean)
        .join(' ')}
      onValueChange={(newSelection) => {
        const selected = newSelection[0] as FilterRowValue | undefined;
        // If a callback is provided, call it with the selected value
        if (selected) onValueChange?.(selected);
      }}
    >
      <Toggle
        aria-label='Align left'
        value={todayValue}
        className='flex min-w-0 flex-1 select-none items-center justify-center '
        render={
          <Button variant='toggle' className='min-w-0 rounded-l-md'>
            <strong>{dayLabel(today, 0)}</strong>,{' '}
            {longDateFormatter.format(today)}
          </Button>
        }
      />
      <Toggle
        aria-label='Align center'
        value={tomorrowValue}
        className='flex min-w-0 flex-1 select-none items-center justify-center '
        render={
          <Button variant='toggle' className='-ml-px min-w-0 rounded-r-md'>
            <strong>{dayLabel(tomorrow, 1)}</strong>,{' '}
            {longDateFormatter.format(tomorrow)}
          </Button>
        }
      />
    </ToggleGroup>
  );
}

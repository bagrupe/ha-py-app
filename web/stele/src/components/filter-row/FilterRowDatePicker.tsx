import 'react-datepicker/dist/react-datepicker.css';
import './react-datepicker-overrides.css';
import {de} from 'date-fns/locale';
import {forwardRef, type ReactNode} from 'react';
import DatePicker, {registerLocale} from 'react-datepicker';
import {dayTokenToDate, toDayTokenIso} from '../../utils/timeUtils';
import FilterRowBaseField from './FilterRowBaseField';
import {type FilterRowValue} from './FilterRowToggleGroup';

registerLocale('de', de);

export type FilterRowDatePickerProps = {
  id?: string;
  title?: string;
  triggerIcon?: ReactNode;
  value?: FilterRowValue;
  defaultValue?: FilterRowValue;
  onValueChange?: (value: FilterRowValue) => void;
};

const triggerButtonClassName =
  'flex size-full min-h-0 min-w-0 flex-1 cursor-pointer items-center border-0 bg-transparent p-0 text-left text-base font-normal leading-normal text-gray-900 outline-none focus:outline-none';

type TriggerButtonProps = {
  id?: string;
  value?: string;
  onClick?: () => void;
};

const TriggerButton = forwardRef<HTMLButtonElement, TriggerButtonProps>(
  function TriggerButton({id, value, onClick}, ref) {
    return (
      <button
        ref={ref}
        id={id}
        type='button'
        onClick={onClick}
        className={triggerButtonClassName}
      >
        {value ?? ''}
      </button>
    );
  },
);

const FilterRowDatePicker = ({
  id,
  title,
  triggerIcon,
  value,
  defaultValue,
  onValueChange,
}: FilterRowDatePickerProps) => {
  const selected = dayTokenToDate(value ?? defaultValue ?? '');

  return (
    <FilterRowBaseField title={title} triggerIcon={triggerIcon}>
      <DatePicker
        selected={selected}
        onChange={(date: Date | null) =>
          onValueChange?.(date ? toDayTokenIso(date) : '')
        }
        minDate={new Date()}
        locale='de'
        dateFormat='dd.MM.yyyy'
        popperPlacement='bottom-start'
        customInput={<TriggerButton id={id} />}
      />
    </FilterRowBaseField>
  );
};

export default FilterRowDatePicker;

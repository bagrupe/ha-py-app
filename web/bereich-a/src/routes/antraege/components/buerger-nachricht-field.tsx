import {type FormBuilder, type RegisterOptions} from '@atmina/formbuilder';
import {type FC} from 'react';
import {getFieldError} from 'src/components/form/fields/common';
import {InputFormField} from 'src/components/form/fields/input-field';

type BuergerNachrichtFieldProps = {
  on: FormBuilder<string>;
  maxLength: number;
  optional?: boolean;
  disabled?: boolean;
  autoFocus?: boolean;
  rules?: RegisterOptions<string>;
};

export const BuergerNachrichtField: FC<BuergerNachrichtFieldProps> = ({
  on,
  maxLength,
  optional,
  disabled,
  autoFocus,
  rules,
}) => {
  const length = on.$useWatch()?.length ?? 0;
  const error = getFieldError(on);
  const label = `Nachricht an die antragstellende Person${
    optional ? ' (optional)' : rules?.required ? ' *' : ''
  }`;

  return (
    <div className='flex flex-col gap-1'>
      <InputFormField
        multiLine
        autoFocus={autoFocus}
        disabled={disabled}
        maxLength={maxLength}
        on={on}
        rules={rules}
        label={label}
        error={error ? true : undefined}
        className='!mb-2'
        inputClass='h-40 min-h-32 max-h-80 resize-y'
      />
      <div className='flex justify-between gap-4 text-sm'>
        <span role='alert' className='text-red-600'>
          {typeof error === 'string' ? error : ''}
        </span>
        <span
          className={length >= maxLength ? 'text-red-600' : 'text-gray-500'}
        >
          {length} / {maxLength}
        </span>
      </div>
    </div>
  );
};

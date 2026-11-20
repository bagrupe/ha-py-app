'use client'

import { clsx } from 'clsx'
import { format, parse, parseISO, startOfDay } from 'date-fns'
import { FieldError, FieldLabel, useField } from '@payloadcms/ui'
import type { DateFieldClientComponent } from 'payload'
import React, { type ChangeEventHandler } from 'react'

export const CustomDateField: DateFieldClientComponent = ({ field, path }) => {
  const { value = [], setValue, showError, errorMessage = '' } = useField<string>({ path })
  const dateAdmin = (
    field.admin as { date?: { displayFormat?: string; pickerAppearance?: string } }
  )?.date
  const displayFormat = dateAdmin?.displayFormat ?? 'yyyy-MM-dd'
  const handleChange: ChangeEventHandler<HTMLInputElement> = ({ currentTarget }) => {
    if (currentTarget.value === '') {
      setValue('')
      return
    }
    if (isNaN(new Date(currentTarget.value).getTime())) {
      return
    }

    setValue(parse(currentTarget.value, displayFormat, startOfDay(new Date())).toISOString())
  }

  return (
    <div className={clsx('field-type text group max-w-3xl', showError && 'error')}>
      <FieldError message={errorMessage} showError={showError} path={path} />
      <FieldLabel label={field.label} required={field.required} path={path} />
      <input
        className={clsx(
          'border-none !font-mono !text-xl',
          (!value || value.length === 0) && '!text-elevation-300',
        )}
        type={dateAdmin?.pickerAppearance === 'dayOnly' ? 'date' : 'datetime-local'}
        required={field.required}
        value={typeof value === 'string' && value ? format(parseISO(value), displayFormat) : ''}
        onChange={handleChange}
      />
      {field.admin?.description && typeof field.admin.description === 'string' && (
        <p className="description mt-2 text-elevation-300">{field.admin.description.toString()}</p>
      )}
    </div>
  )
}

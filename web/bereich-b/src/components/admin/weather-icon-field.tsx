'use client'

import { clsx } from 'clsx'
import { FieldError, FieldLabel, useField } from '@payloadcms/ui'
import React, { type ChangeEventHandler } from 'react'
import type { TextFieldClientComponent } from 'payload'

export const WeatherIconField: TextFieldClientComponent = ({ field, path }) => {
  const fieldPath = path ?? field.name
  const {
    value = '',
    setValue,
    showError,
    errorMessage = '',
  } = useField<string>({ path: fieldPath })
  const handleChange: ChangeEventHandler<HTMLInputElement> = ({ target }) => {
    setValue(target.value, true)
  }

  return (
    <div className={clsx('field-type text group', showError && 'error')}>
      <FieldError message={errorMessage} showError={showError} />
      <FieldLabel label={field.label} required={field.required} path={fieldPath} />
      <div className="input-wrapper -mt-8 flex items-center">
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img
          src={`https://openweathermap.org/img/wn/${value}@2x.png`}
          alt={`Weather icon ${value}`}
          className="h-[100px]"
        />
        <input
          type="text"
          value={value}
          onChange={handleChange}
          disabled={field.admin?.readOnly ?? false}
        />
      </div>
    </div>
  )
}

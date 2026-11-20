'use client'

import { clsx } from 'clsx'
import { FieldError, FieldLabel, useField } from '@payloadcms/ui'
import React, { type ChangeEventHandler } from 'react'
import type { TextFieldClientComponent } from 'payload'

export const ColorField: TextFieldClientComponent = ({ field, path }) => {
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
      <input
        type="color"
        value={value}
        onChange={handleChange}
        disabled={field.admin?.readOnly ?? false}
      />
      <div className="mt-2 !font-mono">{value ?? 'Keine Auswahl'}</div>
    </div>
  )
}

'use client'

import { clsx } from 'clsx'
import { FieldError, FieldLabel, useField, useFormFields } from '@payloadcms/ui'
import React, { type ChangeEventHandler } from 'react'
import type { TextFieldClientComponent } from 'payload'

import { slugify } from '../../utils/slugify'

export const SlugField: TextFieldClientComponent = ({ field, path }) => {
  const fieldPath = path ?? field.name
  // Get some sensible fallback values
  const fallback = useFormFields(([fields]) => fields.title?.value ?? fields.name?.value)
  const placeholder = typeof fallback === 'string' ? slugify(fallback) : ''

  const {
    value = '',
    setValue,
    showError,
    errorMessage = '',
  } = useField<string>({ path: fieldPath })
  const handleChange: ChangeEventHandler<HTMLInputElement> = ({ target }) => {
    setValue(slugify(target.value, true))
  }

  return (
    <div className={clsx('field-type text group', showError && 'error')}>
      <FieldError message={errorMessage} showError={showError} />
      <FieldLabel label={field.label} required={field.required} path={fieldPath} />
      <input
        placeholder={placeholder}
        className="!font-mono"
        value={value}
        onChange={handleChange}
      />
      <div className="mt-2 text-right !text-sm">{value.length} Zeichen</div>
    </div>
  )
}

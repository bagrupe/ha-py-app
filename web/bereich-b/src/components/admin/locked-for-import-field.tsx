'use client'

import { clsx } from 'clsx'
import { FieldError, FieldLabel, useField } from '@payloadcms/ui'
import type { CheckboxFieldClientComponent } from 'payload'
import React from 'react'
import { BsFillLockFill, BsFillUnlockFill } from 'react-icons/bs'

export const LockedForImportField: CheckboxFieldClientComponent = ({ field, path }) => {
  const { value, setValue, showError, errorMessage } = useField<boolean>({ path })

  return (
    <div className={clsx('field-type checkbox group', showError && 'error')}>
      <div className="[&>*]:justify-end">
        <FieldLabel label={field.label} required={field.required} path={path} />
      </div>
      <FieldError message={errorMessage} showError={showError} path={path} />
      <div className="mt-2 flex justify-end">
        <button type="button" onClick={() => setValue(!value)} className="hover:cursor-pointer">
          {value ? (
            // TODO: verify icon size matches original Tailwind `size-12` (3rem/48px)
            <BsFillLockFill size={48} />
          ) : (
            <BsFillUnlockFill size={48} />
          )}
        </button>
      </div>
      {field.admin?.description && typeof field.admin.description === 'string' && (
        <p
          className="description mt-2 text-elevation-300"
          style={{
            textAlign: 'end',
          }}
        >
          {field.admin.description.toString()}
        </p>
      )}
    </div>
  )
}

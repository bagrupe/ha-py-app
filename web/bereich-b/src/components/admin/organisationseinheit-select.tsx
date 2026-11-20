'use client'

// Für die Verwendung außerhalb von Collections.

import { SelectInput } from '@payloadcms/ui'
import type { Option } from '@payloadcms/ui/elements/ReactSelect'
import React from 'react'
import { type Funktionsberechtigung } from '../../lib/funktionsberechtigungen'
import { useOrganisationseinheiten } from '../../lib/organisationseinheiten/use-organisationseinheiten'

export const OrganisationseinheitSelect = ({
  label,
  description,
  value,
  onChange,
  funktionsberechtigung,
}: {
  value: string
  onChange: (id: string) => void
  funktionsberechtigung: Funktionsberechtigung
  label?: string
  description?: string
}) => {
  const { data = [] } = useOrganisationseinheiten(funktionsberechtigung)

  return (
    <SelectInput
      label={label}
      description={description}
      name=""
      path=""
      options={data.map((oe) => ({ value: oe.id, label: oe.name }))}
      value={value}
      onChange={(option: Option | Option[]) => {
        const first = Array.isArray(option) ? option[0] : option
        const val = typeof first === 'string' ? first : String(first?.value ?? '')
        onChange(val)
      }}
      isClearable={false}
    />
  )
}

'use client'

import { useQuery } from '@tanstack/react-query'
import { useAuth } from '@payloadcms/ui'
import { type Benutzer, type Untereinheit } from '../../payload-types'
import { getId } from '../../utils/get-id'
import { type Funktionsberechtigung } from '../funktionsberechtigungen'

export const useOrganisationseinheiten = (funktionsberechtigung: Funktionsberechtigung) => {
  const benutzer = useAuth().user as unknown as Benutzer

  return useQuery({
    queryKey: ['organisationseinheiten', funktionsberechtigung],
    queryFn: ({ signal }) =>
      fetch('/cms/api/untereinheit', { signal })
        .then((res) => res.json())
        .then((data) => {
          const { docs } = data as { docs: Untereinheit[] }
          return docs.filter((oe) => {
            if (benutzer.isSuperAdmin) {
              return true
            }
            return (benutzer.organisationseinheiten ?? []).some(
              (boe) =>
                getId(boe.organisationseinheit) === oe.id &&
                ((boe.funktionsberechtigungen ?? []) as string[]).includes(funktionsberechtigung),
            )
          })
        }),
  })
}

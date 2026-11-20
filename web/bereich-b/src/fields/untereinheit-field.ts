import {
  type CollectionConfig,
  type GlobalConfig,
  type PayloadRequest,
  type RelationshipField,
  type Where,
} from 'payload'
import type { Benutzer } from '../payload-types'
import { hasAnyFunktionsberechtigung, Funktionsberechtigung } from '../lib/funktionsberechtigungen'
import { getId } from '../utils/get-id'
import { isSuperAdmin } from '../utils/is-super-admin'

export const untereinheitField = ({
  required = false,
}: {
  required?: boolean
} = {}): RelationshipField => {
  const custom = { funktionsberechtigungen: [Funktionsberechtigung.Inhaltspflege] }

  return {
    name: 'untereinheit',
    label: 'Untereinheit',
    type: 'relationship',
    defaultValue: ({ user }: { user: Benutzer; req: PayloadRequest }) => {
      if (isSuperAdmin(user) || !user) return undefined
      return getId(
        user.organisationseinheiten?.filter((oe) =>
          hasAnyFunktionsberechtigung(oe.funktionsberechtigungen, custom.funktionsberechtigungen),
        )[0]?.organisationseinheit,
      )
    },
    relationTo: 'untereinheit',
    filterOptions: ({ user }) => {
      if (!user) return {}

      if ('organisationseinheiten' in user) {
        const benutzer = user as unknown as Benutzer

        if (benutzer.isSuperAdmin) return {} as Where

        const organisationseinheiten = benutzer.organisationseinheiten ?? []
        const validOrganisationseinheiten = organisationseinheiten
          .filter((oe) =>
            isSuperAdmin(benutzer)
              ? true
              : typeof oe === 'object' &&
                hasAnyFunktionsberechtigung(
                  oe.funktionsberechtigungen,
                  custom.funktionsberechtigungen,
                ),
          )
          .map(({ organisationseinheit }) => getId(organisationseinheit))

        return { id: { in: validOrganisationseinheiten } }
      }

      // Wenn wir keinen validen Benutzer haben, soll der nichts sehen können.
      return { id: { equals: '' } }
    },
    required,
    hooks: {
      beforeValidate: [
        ({ req, value, operation }) => {
          if (!req.user || (operation !== 'create' && operation !== 'update')) return value
          // Das Feld kann zwar optional (also `required: false`) sein, tatsächlich sollten OE-Nutzer jedoch hier eine
          // ihrer eigenen OEs angeben.
          if (isSuperAdmin(req.user)) return value
          if (!value) {
            throw new Error('Bitte wählen Sie eine Organisationseinheit für diese Entität aus.')
          }
          if (
            !((req.user as Benutzer).organisationseinheiten ?? []).some(
              (oe) => getId(oe.organisationseinheit) === value,
            )
          ) {
            throw new Error('Bitte wählen Sie eine Organisationseinheit für diese Entität aus.')
          }
          return value
        },
      ],
    },
    custom,
  }
}

export const hasUntereinheitField = (collectionConfig: CollectionConfig | GlobalConfig) =>
  collectionConfig.fields.some(
    (field) => field.type === 'relationship' && field.name === 'untereinheit',
  ) ?? false

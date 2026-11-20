import type { CollectionConfig } from 'payload'
import { accessRules } from '../access'
import { bereichAId } from '../fields/bereichAId'
import { kommuneField } from '../fields/kommune'
import { Funktionsberechtigung } from '../lib/funktionsberechtigungen'
import { isSuperAdmin } from '../utils/is-super-admin'

export const Benutzer: CollectionConfig = {
  slug: 'benutzer',
  auth: {
    useAPIKey: true,
    useSessions: false,
  },
  disableDuplicate: true,
  admin: {
    useAsTitle: 'email',
    hidden: ({ user }) => !isSuperAdmin(user),
  },
  labels: {
    singular: 'Benutzer',
    plural: 'Benutzer',
  },
  custom: {
    funktionsberechtigungen: [Funktionsberechtigung.BackofficeNutzendenverwaltung],
  },
  access: {
    create: accessRules.superAdmin,
    read: accessRules.authenticated,
    update: accessRules.superAdmin,
    delete: accessRules.superAdmin,
    unlock: accessRules.superAdmin,
  },
  fields: [
    // since by default the apiKey field can be read by all logged in users we need to override this field here to be able to change the access rules
    {
      name: 'apiKey',
      type: 'text',
      label: 'API-Key',
      access: {
        read: ({ req: { user }, doc }) => user && doc && user.id === doc.id,
      },
      admin: {
        hidden: true,
      },
    },
    bereichAId(),
    {
      name: 'vorname',
      type: 'text',
      admin: {
        readOnly: true,
      },
    },
    {
      name: 'nachname',
      type: 'text',
      admin: {
        readOnly: true,
      },
    },
    {
      label: 'Super Administrator',
      name: 'isSuperAdmin',
      type: 'checkbox',
      admin: {
        readOnly: true,
      },
    },
    {
      name: 'email',
      required: true,
      type: 'email',
      admin: {
        readOnly: true,
      },
    },
    {
      name: 'organisationseinheiten',
      label: 'Zugehörige Organisationseinheiten',
      type: 'array',
      admin: {
        readOnly: true,
        initCollapsed: true,
      },
      fields: [
        {
          name: 'organisationseinheit',
          label: 'Organisationseinheit',
          type: 'relationship',
          relationTo: 'untereinheit',
          admin: {
            readOnly: true,
          },
        },
        {
          name: 'funktionsberechtigungen',
          type: 'json',
          admin: {
            readOnly: true,
          },
        },
      ],
    },
    kommuneField({ required: false }),
  ],
}

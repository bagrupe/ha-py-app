import type { CollectionConfig } from 'payload'
import { accessRules } from '../../access'
import { kommuneField } from '../../fields/kommune'
import { Funktionsberechtigung } from '../../lib/funktionsberechtigungen'
import { isSuperAdmin } from '../../utils/is-super-admin'

export const VeranstaltungskalenderKategorie: CollectionConfig = {
  slug: 'veranstaltungskalender-kategorie',
  admin: {
    useAsTitle: 'label',
    group: 'Veranstaltungen',
    hidden: ({ user }) => !isSuperAdmin(user),
  },
  labels: {
    singular: 'Veranstaltungskategorie',
    plural: 'Veranstaltungskategorien',
  },
  custom: {
    funktionsberechtigungen: [Funktionsberechtigung.InhaltspflegeVeranstaltungen],
  },
  access: {
    read: () => true,
    create: accessRules.superAdmin,
    update: accessRules.superAdmin,
    delete: accessRules.superAdmin,
  },
  fields: [
    { name: 'label', label: 'Label', type: 'text', required: true },
    kommuneField(),
    {
      name: 'filterkategorie',
      label: 'Filterkategorie',
      type: 'checkbox',
      defaultValue: false,
      admin: {
        components: {
          Cell: '@/components/admin/boolean-ja-nein-cell#BooleanJaNeinCell',
        },
      },
    },
  ],
}

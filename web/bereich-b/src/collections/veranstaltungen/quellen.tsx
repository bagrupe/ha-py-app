import type { CollectionConfig } from 'payload'
import { accessRules } from '../../access'
import { kommuneField } from '../../fields/kommune'
import { localOrExternalImage } from '../../fields/local-or-external-image'
import { Funktionsberechtigung } from '../../lib/funktionsberechtigungen'

export const VeranstaltungskalenderQuelle: CollectionConfig = {
  slug: 'veranstaltungskalender-quelle',
  admin: {
    useAsTitle: 'name',
    group: 'Veranstaltungen',
  },
  custom: {
    funktionsberechtigungen: [Funktionsberechtigung.InhaltspflegeVeranstaltungen],
  },
  access: {
    create: accessRules.superAdmin,
    update: accessRules.superAdmin,
    delete: accessRules.superAdmin,
    read: () => true,
  },
  graphQL: {
    singularName: 'VeranstaltungskalenderQuelle',
    pluralName: 'VeranstaltungskalenderQuellen',
  },
  labels: {
    singular: 'Veranstaltungsquelle',
    plural: 'Veranstaltungsquellen',
  },
  fields: [
    {
      name: 'name',
      label: 'Name',
      type: 'text',
    },
    localOrExternalImage({ name: 'logo', label: 'Logo' }, 'veranstaltungsmedien'),
    kommuneField(),
  ],
}

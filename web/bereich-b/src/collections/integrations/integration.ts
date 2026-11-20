import { type CollectionConfig } from 'payload'
import { kommuneField } from '../../fields/kommune'
import { untereinheitField } from '../../fields/untereinheit-field'
import { Funktionsberechtigung } from '../../lib/funktionsberechtigungen'
import { iKISSAccessFields, iKISSKonfiguration } from './ikiss'
import { nolisFields, nolisKonfiguration } from './nolis'
import { rssKonfiguration } from './rss'

export type IntegrationTypes = 'IKISS' | 'IKISS_VERANSTALTUNGEN' | 'NOLIS' | 'RSS'
export const Integration: CollectionConfig = {
  slug: 'integration',
  labels: { singular: 'Integration', plural: 'Integrationen' },
  admin: {
    useAsTitle: 'integrationtype',
  },
  custom: {
    funktionsberechtigungen: [Funktionsberechtigung.InhaltspflegeIntegrationen],
  },
  fields: [
    {
      name: 'integrationtype',
      label: 'Integrations Typ',
      type: 'select',
      options: ['NOLIS', 'IKISS', 'IKISS_VERANSTALTUNGEN', 'RSS'] as IntegrationTypes[],
      required: true,
    },
    {
      name: 'url',
      type: 'text',
      required: true,
      hooks: {
        beforeValidate: [
          ({ value }) => (typeof value === 'string' ? value.replace(/\/$/, '') : value),
        ],
      },
    },
    {
      name: 'zugangsdaten',
      type: 'group',
      fields: [...iKISSAccessFields, ...nolisFields],
    },
    {
      name: 'konfiguration',
      type: 'group',
      fields: [iKISSKonfiguration, ...rssKonfiguration, ...nolisKonfiguration],
    },
    kommuneField(),
    untereinheitField(),
    {
      name: 'status',
      type: 'group',
      fields: [
        {
          name: 'last_import_date',
          label: 'Letzter Import',
          type: 'date',
          admin: {
            readOnly: true,
            date: {
              pickerAppearance: 'dayAndTime',
            },
          },
        },
        {
          name: 'erfolg',
          label: 'Status des letzten Imports',
          type: 'text',
          admin: {
            readOnly: true,
          },
        },
        {
          name: 'import_log',
          label: 'Logs des letzten Import',
          type: 'textarea',
          admin: {
            readOnly: true,
          },
        },
      ],
    },
  ],
}

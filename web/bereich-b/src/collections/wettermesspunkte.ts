import { type CollectionConfig } from 'payload'
import { kommuneField } from '../fields/kommune'
import { weatherIconField } from '../fields/weather-icon-field'
import { Funktionsberechtigung } from '../lib/funktionsberechtigungen'

export const Wettermesspunkte: CollectionConfig = {
  slug: 'wettermesspunkte',
  labels: { singular: 'Wettermesspunkt', plural: 'Wettermesspunkte' },
  access: {
    read: () => true,
  },
  admin: {
    useAsTitle: 'locationName',
  },
  custom: {
    funktionsberechtigungen: [Funktionsberechtigung.InhaltspflegeWettermesspunkte],
  },
  fields: [
    {
      name: 'locationName',
      type: 'text',
      label: 'Ort',
      required: true,
    },
    {
      name: 'location',
      type: 'point',
      label: 'Koordinaten',
      required: true,
    },
    {
      name: 'weather',
      type: 'array',
      label: 'Wetterlage',
      required: true,
      fields: [
        {
          name: 'date',
          type: 'date',
          required: true,
          admin: {
            date: {
              displayFormat: 'dd.MM.yyyy',
            },
          },
        },
        weatherIconField({ name: 'icon', required: true }),
        {
          type: 'row',
          fields: [
            {
              name: 'maxTemp',
              type: 'number',
              required: true,
            },
            {
              name: 'minTemp',
              type: 'number',
              required: true,
            },
          ],
        },
      ],
      admin: {
        initCollapsed: true,
        components: {
          RowLabel: '@/components/admin/wettermesspunkt-row-label#WettermesspunktRowLabel',
        },
      },
    },
    kommuneField(),
  ],
}

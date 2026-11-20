import { type CollectionConfig } from 'payload'
import { kommuneField } from '../fields/kommune'
import { untereinheitField } from '../fields/untereinheit-field'
import { Funktionsberechtigung } from '../lib/funktionsberechtigungen'

export const Geoflaechen: CollectionConfig = {
  slug: 'geo-flaechen',
  labels: {
    singular: 'Geofläche',
    plural: 'Geoflächen',
  },
  custom: {
    funktionsberechtigungen: [Funktionsberechtigung.InhaltspflegeGeoflaechen],
  },
  admin: {
    useAsTitle: 'name',
    defaultColumns: ['name', 'kommune'],
  },
  fields: [
    {
      name: 'name',
      type: 'text',
      required: true,
      unique: true,
    },
    {
      name: 'Geometry',
      type: 'json',
      required: true,
    },
    kommuneField({ required: true }),
    untereinheitField(),
  ],
}

import { type CollectionConfig } from 'payload'
import { isSuperAdmin } from '../utils/is-super-admin'

export const OsmGrenzen: CollectionConfig = {
  slug: 'osm-grenzen',
  labels: { singular: 'OSM-Grenze', plural: 'OSM-Grenzen' },
  graphQL: false,
  admin: {
    useAsTitle: 'regionalschluessel',
    defaultColumns: ['regionalschluessel', 'abgerufenAm'],
    hidden: ({ user }) => !isSuperAdmin(user),
  },
  access: {
    read: () => false,
    create: () => false,
    update: () => false,
    delete: () => false,
  },
  fields: [
    {
      name: 'regionalschluessel',
      type: 'text',
      required: true,
      unique: true,
      admin: { readOnly: true },
    },
    { name: 'rect', type: 'json', required: true, admin: { readOnly: true } },
    { name: 'geojson', type: 'json', required: true, admin: { readOnly: true } },
    { name: 'abgerufenAm', type: 'date', required: true, admin: { readOnly: true } },
    { name: 'quellHash', type: 'text', admin: { readOnly: true } },
  ],
}

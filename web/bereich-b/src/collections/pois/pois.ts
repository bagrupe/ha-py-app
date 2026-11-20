import crypto from 'crypto'
import { type CollectionConfig } from 'payload'
import { ImageBlock } from '../../blocks/image-block'
import { RichTextBlock } from '../../blocks/rich-text-block'
import { kommuneField } from '../../fields/kommune'
import { localOrExternalImage } from '../../fields/local-or-external-image'
import { positionFieldWithLocation } from '../../fields/position-field-with-location'
import { untereinheitField } from '../../fields/untereinheit-field'
import { lockedForImportField } from '../../fields/veranstaltungen-locked-for-import'
import { Funktionsberechtigung } from '../../lib/funktionsberechtigungen'
import { lockImportOnManualUpdate } from '../../utils/lock-import'
import { publicPoiRead } from '../public-read-rules'
import { poiUpload } from './poi-upload'

export const Pois: CollectionConfig = {
  slug: 'poi',
  forceSelect: {
    contents: true,
  },
  labels: { singular: 'POI', plural: 'POIs' },
  admin: {
    useAsTitle: 'title',
    group: 'POIs',
    components: {
      beforeListTable: ['@/components/admin/upload-geojson-button#UploadGeojsonComponent'],
    },
  },
  custom: {
    funktionsberechtigungen: [Funktionsberechtigung.InhaltspflegePois],
  },
  access: {
    read: publicPoiRead,
  },
  endpoints: [
    {
      path: '/upload',
      method: 'post',
      handler: poiUpload,
    },
  ],
  fields: [
    lockedForImportField({
      name: 'lockedForImport',
      label: 'Sperre für Import',
      admin: {
        description:
          'Wird automatisch gesetzt, wenn die Veranstaltung manuell angepasst wurde. Kann manuell entfernt werden, um die Veranstaltung wieder zu importieren (und damit zu überschreiben).',
      },
    }),
    {
      name: 'title',
      type: 'text',
      label: 'Titel',
      required: true,
    },
    {
      name: 'category',
      label: 'Kategorie',
      type: 'relationship',
      relationTo: 'poi-categories',
      required: true,
    },
    {
      name: 'objectId',
      label: 'Objekt Id',
      type: 'text',
      unique: true,
      admin: {
        hidden: true,
      },
      hooks: {
        beforeValidate: [
          ({ value, operation }) => {
            if (operation === 'create' && !value) {
              return crypto.randomUUID()
            }
            return value
          },
        ],
      },
    },
    {
      type: 'checkbox',
      name: 'visible',
      label: 'Sichtbar',
      defaultValue: true,
    },
    localOrExternalImage({ name: 'image', label: 'Bild' }, 'medien'),
    ...positionFieldWithLocation(),
    {
      name: 'contents',
      label: 'Inhalte',
      labels: { singular: 'Block', plural: 'Blöcke' },
      type: 'blocks',
      blocks: [RichTextBlock, ImageBlock('medien')],
    },
    {
      name: 'additionalInformation',
      type: 'array',
      label: 'Weitere Informationen',
      labels: { singular: 'Information', plural: 'Informationen' },
      fields: [
        {
          name: 'heading',
          label: 'Überschrift',
          type: 'text',
          required: true,
        },
        {
          name: 'text',
          label: 'Text',
          type: 'textarea',
          required: true,
        },
        {
          name: 'kind',
          label: 'Art',
          type: 'select',
          required: true,
          defaultValue: 'other',
          options: [
            { value: 'other', label: 'Sonstige' },
            { value: 'email', label: 'Email' },
            { value: 'website', label: 'Webseite' },
            { value: 'phone', label: 'Telefon' },
          ],
        },
      ],
    },
    kommuneField(),
    untereinheitField(),
  ],
  hooks: {
    beforeChange: [
      async ({ data, req, originalDoc }) => lockImportOnManualUpdate(data, req, originalDoc),
    ],
  },
}

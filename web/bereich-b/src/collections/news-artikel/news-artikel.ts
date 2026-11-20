import { type CollectionConfig } from 'payload'
import { type NewsArtikel as NewsArtikelDoc } from '../../payload-types'
import { accessRules } from '../../access'
import { ImageBlock } from '../../blocks/image-block'
import { RichTextBlock } from '../../blocks/rich-text-block'
import { generatedString } from '../../fields/generated-value'
import { kommuneField } from '../../fields/kommune'
import { untereinheitField } from '../../fields/untereinheit-field'
import { Funktionsberechtigung } from '../../lib/funktionsberechtigungen'
import { firstRichTextBlockPlaintext } from '../../lib/lexical-to-plaintext'
import { publicNewsArtikelRead } from '../public-read-rules'

export const NewsArtikel: CollectionConfig = {
  slug: 'news-artikel',
  forceSelect: {
    inhalte: true,
  },
  admin: {
    useAsTitle: 'titel',
  },
  labels: { singular: 'News-Artikel', plural: 'News-Artikel' },
  custom: {
    funktionsberechtigungen: [Funktionsberechtigung.InhaltspflegeNewsArtikel],
  },
  access: {
    read: publicNewsArtikelRead,
    readVersions: accessRules.versionsWithFunktionsberechtigung(
      Funktionsberechtigung.InhaltspflegeNewsArtikel,
    ),
  },
  versions: {
    drafts: true,
    maxPerDoc: 20,
  },
  fields: [
    { name: 'importId', label: 'Import ID', type: 'text', required: true },
    { name: 'titel', label: 'Titel', type: 'text', required: true },
    { name: 'teaser', label: 'Teaser', type: 'textarea' },
    {
      name: 'originalUrl',
      label: 'Originalartikel-URL',
      type: 'text',
      admin: {
        readOnly: true,
        description: 'Link zum Artikel in der ursprünglichen Quelle',
      },
    },
    {
      type: 'array',
      name: 'titelbilder',
      label: 'Titelbild',
      labels: { singular: 'Titelbild', plural: 'Titelbilder' },
      fields: [
        {
          name: 'bild',
          label: 'Bild',
          type: 'upload',
          relationTo: 'veranstaltungsmedien',
        },
        {
          name: 'bildunterschrift',
          label: 'Bildunterschrift',
          type: 'textarea',
        },
      ],
    },
    {
      name: 'datum',
      type: 'date',
      label: 'Datum',
      admin: {
        description: 'Der Artikel ist erst ab diesem Datum sichtbar.',
        position: 'sidebar',
        date: {
          pickerAppearance: 'dayAndTime',
          timeFormat: 'HH:mm',
          displayFormat: 'dd.MM.yyyy HH:mm',
        },
      },
    },
    {
      name: 'ordinal',
      type: 'number',
      label: 'Priorität',
      min: 0,
      max: 10,
      admin: {
        description:
          'Um einen Artikel als Top-Thema zu kennzeichnen, geben sie ihm eine Priorität von 10.',
      },
      validate: async (val: number | null | undefined) => {
        if (val != null && (val < 0 || val > 10)) {
          return 'Die Priorität kann nur zwischen 0 und 10 liegen.'
        }
        return true
      },
    },
    {
      type: 'checkbox',
      name: 'visible',
      label: 'Sichtbar',
      defaultValue: true,
    },
    {
      name: 'inhalte',
      label: 'Inhalte',
      labels: { singular: 'Block', plural: 'Blöcke' },
      type: 'blocks',
      blocks: [RichTextBlock, ImageBlock('veranstaltungsmedien')],
    },
    generatedString<NewsArtikelDoc>({
      name: 'bodyPlaintext',
      value: ({ inhalte }) => firstRichTextBlockPlaintext(inhalte),
    }),
    untereinheitField(),
    kommuneField(),
    {
      name: 'integration',
      type: 'relationship',
      relationTo: 'integration',
      admin: {
        readOnly: true,
        description: 'Aus dieser Integration wurde der News-Artikel importiert',
      },
    },
    {
      name: 'notified',
      type: 'checkbox',
      defaultValue: false,
      admin: {
        condition: () => process.env.NODE_ENV !== 'production',
      },
    },
  ],
}

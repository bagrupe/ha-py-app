import { type CollectionConfig } from 'payload'
import { ImageBlock } from '../../blocks/image-block'
import { RichTextBlock } from '../../blocks/rich-text-block'
import { adresseField } from '../../fields/adresse-field'
import { kommuneField } from '../../fields/kommune'
import { localOrExternalImage } from '../../fields/local-or-external-image'
import { untereinheitField } from '../../fields/untereinheit-field'
import { lockedForImportField } from '../../fields/veranstaltungen-locked-for-import'
import { Funktionsberechtigung } from '../../lib/funktionsberechtigungen'
import { lockImportOnManualUpdate } from '../../utils/lock-import'
import { publicVisibleRead } from '../public-read-rules'

export const Veranstaltungskalender: CollectionConfig = {
  slug: 'veranstaltungskalender',
  forceSelect: {
    inhalte: true,
  },
  admin: {
    useAsTitle: 'titel',
    group: 'Veranstaltungen',
  },
  labels: { singular: 'Veranstaltung', plural: 'Veranstaltungen' },
  custom: {
    funktionsberechtigungen: [Funktionsberechtigung.InhaltspflegeVeranstaltungen],
  },
  access: {
    read: publicVisibleRead,
  },
  fields: [
    lockedForImportField({
      name: 'lockedForImport',
      label: 'Sperre für Import',
      admin: {
        description:
          'Wird automatisch gesetzt, wenn die Veranstaltung manuell angepasst wurde. Kann manuell entfernt werden, um die Veranstaltung wieder zu importieren (und damit zu überschreiben).',
      },
    }),
    { name: 'id', label: 'ID', type: 'text', required: true },
    { name: 'upstreamUpdateDate', type: 'text', hidden: true },
    { name: 'titel', label: 'Titel', type: 'text', required: true },
    { name: 'teaser', label: 'Teaser', type: 'textarea' },
    { name: 'subtitle', label: 'Untertitel', type: 'text' },
    {
      type: 'checkbox',
      name: 'visible',
      label: 'Sichtbar',
      defaultValue: true,
    },
    {
      name: 'category',
      label: 'Kategorie',
      type: 'relationship',
      relationTo: 'veranstaltungskalender-kategorie',
      hasMany: true,
    },
    {
      name: 'source',
      label: 'Quelle',
      type: 'relationship',
      relationTo: 'veranstaltungskalender-quelle',
      hasMany: true,
    },
    localOrExternalImage({ name: 'titelbild', label: 'Titelbild' }, 'veranstaltungsmedien'),
    {
      type: 'group',
      name: 'timeAndLocation',
      label: 'Zeit und Ort',
      fields: [
        { name: 'coordinates', label: 'Koordinaten', type: 'point' },
        { name: 'locationName', label: 'Ort', type: 'text' },
        { name: 'address', label: 'Adresse', type: 'text' },
        {
          type: 'row',
          fields: [
            {
              name: 'dates',
              label: 'Alle Termine',
              labels: { singular: 'Termin', plural: 'Termine' },
              type: 'array',
              fields: [
                {
                  type: 'row',
                  fields: [
                    {
                      name: 'start',
                      label: 'Start',
                      type: 'date',
                      required: true,
                      admin: {
                        date: {
                          pickerAppearance: 'dayAndTime',
                          timeFormat: 'HH:mm',
                          displayFormat: 'dd.MM.yyyy HH:mm',
                        },
                        placeholder: 'Datum und Uhrzeit auswählen',
                      },
                    },
                    {
                      name: 'end',
                      label: 'Ende',
                      type: 'date',
                      required: true,
                      admin: {
                        date: {
                          pickerAppearance: 'dayAndTime',
                          timeFormat: 'HH:mm',
                          displayFormat: 'dd.MM.yyyy HH:mm',
                        },
                        placeholder: 'Datum und Uhrzeit auswählen',
                      },
                    },
                  ],
                },
              ],
              admin: {
                components: {
                  RowLabel: '@/components/admin/date-range-row-label#DateRangeRowLabel',
                },
                initCollapsed: true,
              },
            },
          ],
        },
      ],
    },
    // Import: Die Adresse "organizer"
    adresseField({ name: 'veranstalterAdresse', label: 'Veranstalter' }),
    // Import: `media_objects` -> `booking` und als Fallback für Feratel / Bad Pyrmont im Text-Element
    // "PRICE_INFO" die einzige enthaltene URL, falls vorhanden
    { name: 'buchungsUrl', label: 'Link zum Ticketanbieter', type: 'text' },
    { name: 'ticketUrl', label: 'Link zum Ticketkauf', type: 'text' },
    // Import: `media_objects` -> `venuewebsite` und als Fallback die Eigenschaft "web"
    { name: 'anbieterUrl', label: 'Link zum Anbieter', type: 'text' },
    {
      name: 'inhalte',
      label: 'Inhalte',
      labels: { singular: 'Block', plural: 'Blöcke' },
      type: 'blocks',
      blocks: [RichTextBlock, ImageBlock('veranstaltungsmedien')],
    },
    kommuneField(),
    untereinheitField(),
  ],
  hooks: {
    beforeChange: [
      async ({ data, req, originalDoc }) => ({
        ...(await lockImportOnManualUpdate(data, req, originalDoc)),
        ...(req.user && { upstreamUpdateDate: null }),
      }),
    ],
  },
}

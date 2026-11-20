import type { CollectionConfig } from 'payload'
import { accessRules, fieldAccessRules } from '../access'
import { colorField } from '../fields/color-field'
import { fontField } from '../fields/font-field'
import { generatedString } from '../fields/generated-value'
import { DEFAULT_KARTENLIZENZEN } from '../lib/default-kartenlizenzen'
import { lexicalToHtml } from '../lib/lexical-to-html'
import { isSuperAdmin } from '../utils/is-super-admin'

// Note: Kommune acts as the tenant ("Mandant") for access control purposes.
// Tenancy-enabled collections must include the `kommune()` field.

export const Kommunen: CollectionConfig = {
  slug: 'kommunen',
  forceSelect: {
    lizenzen: {
      kartenlizenzen: true,
    },
  },
  access: {
    read: () => true,
    create: accessRules.superAdmin,
    update: accessRules.superAdmin,
    delete: accessRules.superAdmin,
  },
  labels: { singular: 'Kommune', plural: 'Kommunen' },
  typescript: { interface: 'Kommune' },
  admin: {
    useAsTitle: 'name',
    hidden: ({ user }) => !isSuperAdmin(user),
    defaultColumns: ['name', 'id', 'bereichAId', 'regionalschluessel'],
  },
  fields: [
    {
      name: 'name',
      type: 'text',
      required: true,
    },
    {
      name: 'bereichAId',
      type: 'text',
      required: true,
      access: {
        update: fieldAccessRules.forbidden,
      },
      index: true,
    },
    {
      name: 'regionalschluessel',
      label: 'Amtlicher Regionalschlüssel',
      type: 'text',
      required: true,
      access: {
        update: fieldAccessRules.forbidden,
      },
      index: true,
    },
    {
      type: 'point',
      name: 'defaultPosition',
      label: 'Standard-Position',
      required: true,
      admin: {
        description:
          'Die Standard-Position wird genutzt um die Karte zu zentrieren, wenn der Nutzer seine Position nicht frei gibt.',
      },
    },
    {
      type: 'tabs',
      tabs: [
        {
          name: 'design',
          label: 'Design',
          fields: [
            {
              access: {
                read: () => true,
              },
              type: 'upload',
              name: 'logo',
              label: 'Logo',
              relationTo: 'medien',
            },
            {
              access: {
                read: () => true,
              },
              type: 'upload',
              name: 'mangelIcon',
              label: 'Mängelmelder Icon',
              relationTo: 'medien',
            },
            {
              access: {
                read: () => true,
              },
              type: 'upload',
              name: 'ideenIcon',
              label: 'Ideenmelder Icon',
              relationTo: 'medien',
            },
            {
              access: {
                read: () => true,
              },
              type: 'upload',
              name: 'fallbackImage',
              label: 'Fallback-Bild',
              relationTo: 'medien',
              admin: {
                description:
                  'Standard-Bild, das als Platzhalter verwendet wird, wenn kein spezifisches Bild vorhanden ist.',
              },
            },
            {
              type: 'group',
              name: 'colors',
              label: 'Farben',
              interfaceName: 'KommuneDesignColors',
              fields: [
                colorField({
                  name: 'primary',
                  label: 'Primärfarbe',
                  defaultValue: '#15579D',
                }),
                colorField({
                  name: 'primaryLight',
                  label: 'Primärfarbe (hell)',
                  defaultValue: '#C1DCF6',
                }),
              ],
            },
            {
              type: 'group',
              name: 'fonts',
              label: 'Schriftarten',
              fields: [
                fontField({
                  name: 'headings',
                  label: 'Überschriften',
                  defaultValue: 'noto-sans',
                }),
                fontField({
                  name: 'body',
                  label: 'Text',
                  defaultValue: 'noto-sans',
                }),
              ],
              interfaceName: 'KommuneDesignFonts',
            },
          ],
          interfaceName: 'KommuneDesign',
        },
        {
          name: 'lizenzen',
          label: 'Lizenzen',
          fields: [
            {
              type: 'richText',
              name: 'kartenlizenzen',
              label: 'Kartenlizenzen',
              required: true,
              defaultValue: DEFAULT_KARTENLIZENZEN,
              admin: {
                description:
                  'Geben Sie hier alle relevanten Lizenzen für die Darstellung der Karte an.',
              },
            },
            generatedString<{ id: string }, { kartenlizenzen?: unknown }>({
              name: 'kartenlizenzenHtml',
              value: (_doc, sibling) => lexicalToHtml(sibling.kartenlizenzen),
            }),
          ],
        },
        {
          name: 'analytics',
          label: 'Analytics',
          fields: [
            {
              type: 'text',
              name: 'url',
              label: 'Matomo-Url',
              admin: {
                description:
                  'Die URL zu Ihrer Matomo Instanz z. B. https://www.example.com/matomo.php',
              },
            },
            {
              type: 'text',
              name: 'siteId',
              label: 'Seiten-ID',
              admin: {
                description: 'Tragen Sie hier die Seiten-ID ein',
              },
            },
          ],
        },
        {
          name: 'legal',
          label: 'Rechtstexte',
          fields: [
            {
              type: 'text',
              name: 'impressum',
              label: 'Impressum',
            },
            {
              type: 'text',
              name: 'privacy',
              label: 'Datenschutz',
            },
          ],
        },
        {
          name: 'maengelmelder',
          label: 'Mängelmelder',
          fields: [
            {
              type: 'number',
              name: 'maengelZeitfensterStunden',
              label: 'Geschlossene Mängel ausblenden nach (Stunden)',
              defaultValue: 72,
              min: 0,
              admin: {
                description:
                  'Abgeschlossene Mängel werden nach dieser Anzahl Stunden in der App nicht mehr angezeigt. Standard: 72 Stunden.',
              },
            },
          ],
        },
        {
          name: 'ideenmelder',
          label: 'Ideenmelder',
          fields: [
            {
              type: 'number',
              name: 'ideenZeitfensterStunden',
              label: 'Geschlossene Ideen ausblenden nach (Stunden)',
              defaultValue: 72,
              min: 0,
              admin: {
                description:
                  'Umgesetzte Ideen werden nach dieser Anzahl Stunden in der App nicht mehr angezeigt. Standard: 72 Stunden.',
              },
            },
          ],
        },
      ],
    },
  ],
  graphQL: {
    singularName: 'BereichBKommune',
    pluralName: 'BereichBKommunen',
  },
}

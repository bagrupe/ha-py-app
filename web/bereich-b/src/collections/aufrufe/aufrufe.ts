import { type CollectionConfig, type PayloadRequest, type Where } from 'payload'
import { accessRules } from '../../access'
import {
  type Aufrufe as AufrufDoc,
  type Aufrufemedien,
  type Kommune,
  type Medien,
} from '../../payload-types'
import { generatedString } from '../../fields/generated-value'
import { kommuneField } from '../../fields/kommune'
import { localOrExternalImage } from '../../fields/local-or-external-image'
import { richTextField } from '../../fields/rich-text-field'
import { untereinheitField } from '../../fields/untereinheit-field'
import { Funktionsberechtigung } from '../../lib/funktionsberechtigungen'
import { lexicalToPlaintext } from '../../lib/lexical-to-plaintext'
import { buildQrResponse, type QrCodeData } from '../../lib/qr-code'

let warnedMissingServerUrl = false

const dayOnlyDate = {
  pickerAppearance: 'dayOnly' as const,
  displayFormat: 'dd.MM.yyyy',
}

const dateWithinOrMissing = (
  field: 'startDatum' | 'endDatum',
  operator: 'less_than_equal' | 'greater_than_equal',
  now: string,
): Where => ({
  or: [{ [field]: { [operator]: now } }, { [field]: { exists: false } }],
})

export const Aufrufe: CollectionConfig = {
  slug: 'aufrufe',
  forceSelect: {
    beschreibung: true,
    bild: true,
    qrCode: true,
    kommune: true,
  },
  admin: {
    useAsTitle: 'titel',
    defaultColumns: ['titel', 'aufrufende', 'startDatum', 'endDatum'],
    group: 'Inhalte',
  },
  labels: { singular: 'Aufruf', plural: 'Aufrufe' },
  custom: {
    funktionsberechtigungen: [Funktionsberechtigung.InhaltspflegeAufrufe],
  },
  access: {
    read: accessRules.publicRead(() => {
      const now = new Date().toISOString()
      return {
        and: [
          dateWithinOrMissing('startDatum', 'less_than_equal', now),
          dateWithinOrMissing('endDatum', 'greater_than_equal', now),
        ],
      } satisfies Where
    }),
  },
  fields: [
    { name: 'titel', label: 'Titel', type: 'text', required: true },
    { name: 'teaser', label: 'Teaser', type: 'textarea' },
    richTextField({
      name: 'beschreibung',
      label: 'Beschreibung',
      required: true,
    }),
    generatedString<AufrufDoc>({
      name: 'beschreibungText',
      value: ({ beschreibung }) => lexicalToPlaintext(beschreibung),
    }),
    {
      name: 'aufrufende',
      label: 'Aufrufende',
      type: 'text',
      required: true,
    },
    {
      type: 'row',
      fields: [
        {
          name: 'startDatum',
          label: 'Startdatum',
          type: 'date',
          admin: { date: dayOnlyDate },
        },
        {
          name: 'endDatum',
          label: 'Enddatum',
          type: 'date',
          admin: { date: dayOnlyDate },
          validate: (value, { siblingData }) => {
            const start = (siblingData as { startDatum?: string | Date })?.startDatum
            if (value && start && new Date(value) < new Date(start)) {
              return 'Enddatum darf nicht vor dem Startdatum liegen.'
            }
            return true
          },
        },
      ],
    },
    localOrExternalImage({ name: 'bild', label: 'Bild' }, 'aufrufemedien'),
    {
      type: 'group',
      name: 'qrCode',
      label: 'QR-Code',
      fields: [
        {
          name: 'type',
          label: 'Typ',
          type: 'select',
          defaultValue: 'none',
          options: [
            { label: 'Kein QR-Code', value: 'none' },
            { label: 'URL', value: 'url' },
            { label: 'Kontaktinformationen', value: 'contact' },
            { label: 'Koordinate', value: 'coordinates' },
          ],
        },
        {
          name: 'url',
          label: 'URL',
          type: 'text',
          admin: {
            condition: (_, siblingData) => siblingData?.type === 'url',
          },
        },
        {
          type: 'group',
          name: 'contact',
          label: 'Kontaktinformationen',
          admin: {
            condition: (_, siblingData) => siblingData?.type === 'contact',
          },
          fields: [
            { name: 'name', label: 'Name', type: 'text' },
            { name: 'phone', label: 'Telefon', type: 'text' },
            { name: 'email', label: 'E-Mail', type: 'text' },
            { name: 'address', label: 'Adresse', type: 'text' },
          ],
        },
        {
          name: 'coordinates',
          label: 'Koordinate',
          type: 'point',
          admin: {
            condition: (_, siblingData) => siblingData?.type === 'coordinates',
          },
        },
        {
          name: 'preview',
          type: 'ui',
          admin: {
            components: {
              Field: '@/components/admin/qr-code-preview#QrCodePreview',
            },
          },
        },
      ],
    },
    // Computed per-read via generatedString; a literal empty string is persisted
    // by beforeValidate, so filtering/sorting on this field is meaningless.
    generatedString<AufrufDoc>({
      name: 'fallbackBildUrl',
      nullable: true,
      value: async ({ bild, kommune }, _, req) => {
        if (bild?.external && bild.url) return bild.url
        if (!bild?.external && bild?.internal) {
          const medium =
            typeof bild.internal === 'object'
              ? (bild.internal as Aufrufemedien)
              : await req.payload
                  .findByID({
                    collection: 'aufrufemedien',
                    id: bild.internal,
                    depth: 0,
                  })
                  .catch(() => null)
          if (medium?.url) return medium.url
        }
        if (kommune) {
          const kommuneDoc =
            typeof kommune === 'object'
              ? (kommune as Kommune)
              : await req.payload
                  .findByID({
                    collection: 'kommunen',
                    id: kommune,
                    depth: 1,
                  })
                  .catch(() => null)
          const fallback = kommuneDoc?.design?.fallbackImage
          if (fallback) {
            const medium =
              typeof fallback === 'object'
                ? (fallback as Medien)
                : await req.payload
                    .findByID({
                      collection: 'medien',
                      id: fallback,
                      depth: 0,
                    })
                    .catch(() => null)
            if (medium?.url) return medium.url
          }
        }
        return null
      },
    }),
    generatedString<AufrufDoc>({
      name: 'qrCodeUrl',
      nullable: true,
      value: ({ id, qrCode }, _, req) => {
        if (!qrCode?.type || qrCode.type === 'none') return null
        const base = req.payload.config.serverURL
        if (!base) {
          if (!warnedMissingServerUrl) {
            req.payload.logger.warn(
              'qrCodeUrl: PAYLOAD_PUBLIC_SERVER_URL / config.serverURL is unset; returning null.',
            )
            warnedMissingServerUrl = true
          }
          return null
        }
        const apiRoute = req.payload.config.routes?.api ?? '/api'
        return `${base}${apiRoute}/aufrufe/${id}/qr.svg`
      },
    }),
    kommuneField({ required: true }),
    untereinheitField(),
  ],
  endpoints: [
    {
      path: '/:id/qr.svg',
      method: 'get',
      handler: async (req: PayloadRequest) => {
        const id = req.routeParams?.id as string
        let doc: AufrufDoc
        try {
          doc = await req.payload.findByID({
            collection: 'aufrufe',
            id,
            req,
            overrideAccess: false,
            depth: 0,
          })
        } catch (error) {
          const status = (error as { status?: number } | undefined)?.status
          if (status === 404 || status === 403) {
            return new Response('Not found', { status: 404 })
          }
          req.payload.logger.error({ err: error, id }, 'Failed to load Aufruf for QR SVG')
          return new Response('Internal error', { status: 500 })
        }

        const result = buildQrResponse((doc.qrCode ?? {}) as QrCodeData)
        if (!result) return new Response('Not found', { status: 404 })
        if (req.headers.get('if-none-match') === result.etag) {
          return new Response(null, { status: 304 })
        }

        let svg: string
        try {
          svg = await result.render()
        } catch {
          return new Response('QR-Code-Inhalt zu lang', { status: 422 })
        }

        return new Response(svg, {
          status: 200,
          headers: {
            'Content-Type': 'image/svg+xml; charset=utf-8',
            'Cache-Control': 'public, max-age=60, must-revalidate',
            ETag: result.etag,
          },
        })
      },
    },
  ],
}

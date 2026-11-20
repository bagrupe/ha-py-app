import { type Field } from 'payload'
import { validateIntegrationField } from './common'

export const nolisFields: Field[] = [
  {
    name: 'token',
    type: 'text',
    admin: {
      condition: (data) => data.integrationtype === 'NOLIS',
    },
    validate: validateIntegrationField,
  },
]

export const nolisKonfiguration: Field[] = [
  {
    name: 'artikelSeitenId',
    type: 'text',
    label: 'Artikel-Seiten-ID',
    admin: {
      description:
        'Zahl am Ende der Artikel-URL auf der NOLIS-Webseite (z. B. 33910 bei .../portal/meldungen/titel-900001094-33910.html). Ohne Angabe wird in der App kein Link zum Originalartikel angezeigt.',
      condition: (data) => data.integrationtype === 'NOLIS',
    },
    validate: (value: string | null | undefined) =>
      !value || /^\d+$/.test(value) ? true : 'Nur Ziffern erlaubt',
  },
]

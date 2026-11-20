import { type Field } from 'payload'
import { validateIntegrationField } from './common'

const usesIkissAccess = (data: Record<string, unknown>) =>
  data.integrationtype === 'IKISS' || data.integrationtype === 'IKISS_VERANSTALTUNGEN'

export const iKISSAccessFields: Field[] = [
  {
    name: 'benutzername',
    type: 'text',
    validate: validateIntegrationField,
    admin: {
      condition: usesIkissAccess,
    },
  },
  {
    name: 'passwort',
    type: 'text',
    validate: validateIntegrationField,
    admin: {
      condition: usesIkissAccess,
    },
  },
]
export const iKISSKonfiguration: Field = {
  name: 'kategorien',
  type: 'array',
  admin: {
    condition: (data) => data.integrationtype === 'IKISS',
    description:
      'Hier werden die zu importierenden Kategorien definiert. Dazu muss jede Kategorie-ID einzeln hinzugefügt werden, z.B. 2561.264.1. Für jede Kategorie kann eine Gewichtung angegeben werden. Bei einem Wert von 10 wird der erste Artikel dieser Kategorie auf der Startseite der App an erster Stelle angezeigt.',
  },
  fields: [
    { name: 'kategorie', type: 'text' },
    { name: 'gewichtung', type: 'number' },
  ],
}

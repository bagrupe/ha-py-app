import { type Condition } from 'payload'
import { type Field } from 'payload'

export const rssKondition: Condition = (data) => data.integrationtype === 'RSS'

export const rssKonfiguration: Field[] = [
  {
    name: 'content',
    type: 'text',
    label: 'Inhalt',
    admin: {
      description: 'Hier kann angegeben werden, unter welchem Tag der Inhalt zu finden ist.',
      condition: rssKondition,
    },
  },
]

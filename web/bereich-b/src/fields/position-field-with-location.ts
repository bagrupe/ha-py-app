import { type Field } from 'payload'
import { coordinatesToAddress } from '../utils/coordinates-to-address'

export const positionFieldWithLocation = (): Field[] => [
  {
    name: 'position',
    type: 'point',
    label: 'Position',
    hooks: {
      beforeChange: [
        async ({ data, siblingData, value }) => {
          if (!data) return

          if (!value) {
            siblingData.positionString = ''
            return
          }

          siblingData.positionString = await coordinatesToAddress(value)

          return value
        },
      ],
    },
    required: true,
  },
  {
    name: 'positionString',
    type: 'text',
    label: 'Adresse der Position',
    admin: {
      description:
        'Wird beim Speichern automatisch anhand der Position ermittelt, kann aber hier noch überschrieben werden.',
    },
  },
]

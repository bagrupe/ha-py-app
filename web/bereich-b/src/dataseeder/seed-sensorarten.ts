import { readFile } from 'node:fs/promises'

import { getPayload, type Payload } from 'payload'
import config from '@payload-config'
import { dataseederAsset } from './assets'
import { upsert } from './upsert'

type SeedSensorArt = {
  name: string
  einheit: string
  iconName: string
  rate?: boolean
}

const sensorArten: SeedSensorArt[] = [
  { name: 'Luftdruck', einheit: ' hPa', iconName: 'Luftdrucksensor' },
  { name: 'Temperatur', einheit: '°C', iconName: 'Temperatursensor' },
  {
    name: 'Luftfeuchtigkeit',
    einheit: '%',
    iconName: 'Luftfeuchtigkeitsensor',
  },
  {
    name: 'Regenintensität',
    einheit: ' mm/h',
    iconName: 'Regensensor',
    rate: true,
  },
]

export const seedSensorarten = async (payloadArg?: Payload) => {
  const payload = payloadArg ?? (await getPayload({ config }))
  const kommunen = await payload.find({
    collection: 'kommunen',
    overrideAccess: true,
  })

  for (const kommune of kommunen.docs ?? []) {
    for (const sensorArt of sensorArten) {
      const buffer = await readFile(dataseederAsset(`media/icons/${sensorArt.iconName}.svg`))

      const poiIcon = await upsert(
        {
          collection: 'poi-icons',
          key: ['kommune', 'filename'],
          data: {
            kommune: kommune.id,
            filename: `${kommune.name}-${sensorArt.iconName}.svg`,
          },
          overwriteExistingFiles: true,
          file: {
            data: buffer,
            name: `${kommune.name}-${sensorArt.iconName}.svg`,
            mimetype: 'image/svg+xml',
            size: buffer.byteLength,
          },
        },
        { payload },
      )

      await upsert(
        {
          collection: 'sensor-art',
          key: ['name', 'kommune'],
          data: {
            kommune: kommune.id,
            name: sensorArt.name,
            einheit: sensorArt.einheit,
            icon: poiIcon?.id,
            rate: sensorArt.rate ?? false,
          },
        },
        { payload },
      )
    }
  }
}

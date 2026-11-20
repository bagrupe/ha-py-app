import type { Payload } from 'payload'
import geo from './HaPy_Gemeindeflaechen.json'
import { getKommuneId } from './seed-kommunen'
import { upsert } from './upsert'

export const seedGeoflaeche = async (payload?: Payload) => {
  const kommunen = await Promise.all(
    [{ kommuneName: 'Landkreis Hameln-Pyrmont', titelbild: 'hameln.jpg' }].map(
      async ({ kommuneName }) => ({
        kommune: await getKommuneId(kommuneName, payload),
        kommuneName: kommuneName,
      }),
    ),
  )

  const hameln = geo.features.filter((feature) => feature.properties.OBJECTID == 6)[0]
  const salzhemmendorf = geo.features.filter((feature) => feature.properties.OBJECTID == 8)[0]
  for (const { kommune } of kommunen) {
    await upsert(
      {
        collection: 'geo-flaechen',
        key: 'name',
        data: {
          kommune,
          name: hameln.properties.Beschriftung,
          Geometry: hameln,
        },
      },
      { payload },
    )
    await upsert(
      {
        collection: 'geo-flaechen',
        key: 'name',
        data: {
          kommune,
          name: salzhemmendorf.properties.Beschriftung,
          Geometry: salzhemmendorf,
        },
      },
      { payload },
    )
  }
}

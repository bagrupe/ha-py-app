import type { Payload } from 'payload'
import { seedBenutzer } from './seed-benutzer'
import { seedGeoflaeche } from './seed-gemeindeflaechen'
import { seedIntegration } from './seed-integration'
import { seedKommunen } from './seed-kommunen'
import { seedPois } from './seed-pois'
import { seedSensorarten } from './seed-sensorarten'
import { seedWeather } from './seed-weather'

type Seeder = (payload?: Payload) => Promise<unknown>

export const SEEDERS = [
  ['kommunen', seedKommunen],
  ['pois', seedPois],
  ['benutzer', seedBenutzer],
  ['wettermesspunkte', seedWeather],
  ['geoflaechen', seedGeoflaeche],
  ['sensorart', seedSensorarten],
  ['integration', seedIntegration],
] as const satisfies readonly (readonly [string, Seeder])[]

export const runAllSeeders = async (payload?: Payload) => {
  for (const [name, seed] of SEEDERS) {
    console.info(`dataseeder: running ${name}`)
    await seed(payload)
  }
  console.info(`dataseeder: finished (${SEEDERS.length} seeders)`)
}

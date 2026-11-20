import { importIntegrations } from './import-integrations'
import { importSensoren } from './import-sensoren'
import { importVeranstaltungenCronJob } from './import-veranstaltungen/import-veranstaltungen'
import { importWeather } from './import-weather'
import { logCronMetricsConfig } from './metrics'

export const setupCronJobs = async () => {
  if (process.env.SKIP_IMPORTERS === 'true') {
    return
  }

  logCronMetricsConfig()

  await Promise.all([
    importIntegrations(),
    importVeranstaltungenCronJob(),
    importWeather(),
    importSensoren(),
  ])
}

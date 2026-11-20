import * as Sentry from '@sentry/nextjs'
import { scheduleWithMetrics } from './metrics'
import { runIntegrations } from '../collections/news-artikel/integrations/integration-runner'

export const importIntegrations = () => {
  const everyTenMinutes = '*/10 * * * *'
  scheduleWithMetrics(
    'import_integrations',
    everyTenMinutes,
    async (failures) => {
      try {
        await runIntegrations(failures)
      } catch (error) {
        console.error('Integration import failed', error)
        Sentry.captureException(error, { tags: { module: 'import-integrations' } })
        throw error
      }
    },
    { runOnInit: true },
  )
}

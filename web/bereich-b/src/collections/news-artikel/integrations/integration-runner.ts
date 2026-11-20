import { getPayload } from 'payload'
import config from '@payload-config'
import { type CronJobItemFailures } from '../../../cron-jobs/cron-job-item-failures'
import { type Integration } from '../../../payload-types'
import { UpsertStats } from '../../../dataseeder/upsert-stats'
import { updateIntegrationResult } from './common'
import { iKissImport } from './ikiss/ikiss-importer'
import { nolisImport } from './nolis/nolis-importer'
import { rssImport } from './rss/rss-importer'

const errorMessage = (integration: Integration, message?: string) =>
  `Error on integration: ${integration.integrationtype} for kommune: ${integration.kommune}. Message: ${message}`

const executeIntegration = async (
  integration: Integration,
  stats: UpsertStats,
  failures?: CronJobItemFailures,
) => {
  const payload = await getPayload({ config })
  try {
    switch (integration.integrationtype) {
      case 'RSS': {
        if (!integration.konfiguration) {
          throw errorMessage(integration, 'Required fieldset --configuration-- not set')
        }
        await rssImport(payload, integration, stats)
        break
      }
      case 'NOLIS': {
        const { zugangsdaten, ...rest } = integration
        const token = zugangsdaten?.token

        if (!token) {
          throw errorMessage(integration, 'Missing required token')
        }

        await nolisImport(
          payload,
          {
            token: token,
            type: 'meldungen',
            ...rest,
          },
          stats,
        )
        break
      }
      case 'IKISS': {
        const { zugangsdaten, ...rest } = integration
        const benutzername = zugangsdaten?.benutzername
        const passwort = zugangsdaten?.passwort

        if (!benutzername || !passwort) {
          throw errorMessage(integration, 'Missing benutzername or passwort')
        }

        await iKissImport(
          payload,
          {
            passwort,
            benutzername,
            ...rest,
          },
          stats,
        )
        break
      }
    }
  } catch (e) {
    failures?.recordFailure()
    await updateIntegrationResult(payload, integration.id, e)
  }
}

export const runIntegrations = async (failures?: CronJobItemFailures) => {
  const stats = new UpsertStats()
  const payload = await getPayload({ config })
  const integrations = await payload.find({
    collection: 'integration',
    depth: 0,
    pagination: false,
  })

  await Promise.all(integrations.docs.map((i) => executeIntegration(i, stats, failures)))
  stats.flush(payload.logger)
}

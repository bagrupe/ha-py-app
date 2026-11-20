import { tz } from '@date-fns/tz'
import * as Sentry from '@sentry/nextjs'
import { startOfDay, endOfDay, addDays, isAfter } from 'date-fns'
import groupBy from 'lodash/groupBy'
import { scheduleWithMetrics } from './metrics'
import { getPayload } from 'payload'
import config from '@payload-config'
import { type Wettermesspunkte } from '../payload-types'
import { upsert } from '../dataseeder/upsert'

const KOMMUNE_TZ = tz('Europe/Berlin')

type WeatherEntry = {
  main: {
    temp_min: number
    temp_max: number
  }
  weather: {
    icon: string
  }[]
  dt_txt: string
}

type WeatherMapResponse = {
  list: WeatherEntry[]
}

export const importWeather = () => {
  const everyHour = '0 * * * *'

  scheduleWithMetrics(
    'import_weather',
    everyHour,
    async (failures) => {
      try {
        console.info('Running import for weather-points')

        const payload = await getPayload({ config })
        const wettermesspunkte = await payload.find({
          collection: 'wettermesspunkte',
          pagination: false,
        })

        const inThreeDays = endOfDay(addDays(new Date(), 2), { in: KOMMUNE_TZ })

        for (const wettermesspunkt of wettermesspunkte.docs) {
          if (!wettermesspunkt.location) {
            console.error(`No location specified for ${wettermesspunkt.locationName}`)
            failures.recordFailure()
            continue
          }

          const appId = process.env.OPENWEATHER_API_KEY
          const url = `https://api.openweathermap.org/data/2.5/forecast?lon=${wettermesspunkt.location[1]}&lat=${wettermesspunkt.location[0]}&appid=${appId}&units=metric`

          const response = await fetch(url)

          if (!response.ok) {
            console.error(`Could not fetch weather data for ${wettermesspunkt.locationName}`)
            failures.recordFailure()
            continue
          }

          const data = (await response.json()) as WeatherMapResponse

          const dataByDay = groupBy(data.list, (a) =>
            startOfDay(new Date(a.dt_txt), { in: KOMMUNE_TZ }).toISOString(),
          )

          const weatherData: Wettermesspunkte['weather'] = []

          for (const [dayIso, weatherEntries] of Object.entries(dataByDay)) {
            if (isAfter(new Date(dayIso), inThreeDays)) continue

            const maxTemp = Math.max(...weatherEntries.map((a) => a.main.temp_max))
            const minTemp = Math.min(...weatherEntries.map((a) => a.main.temp_min))
            const icon = weatherEntries[0].weather[0].icon.replace(/n$/, 'd')

            weatherData.push({
              date: dayIso,
              icon,
              maxTemp,
              minTemp,
            })
          }

          await upsert({
            collection: 'wettermesspunkte',
            key: 'locationName',
            data: {
              ...wettermesspunkt,
              kommune:
                typeof wettermesspunkt.kommune === 'object' &&
                wettermesspunkt.kommune !== null &&
                'id' in wettermesspunkt.kommune
                  ? wettermesspunkt.kommune.id
                  : wettermesspunkt.kommune,
              weather: weatherData,
            },
          })
        }

        console.info('Finished import for weather-points')
      } catch (error) {
        console.error('Weather import failed', error)
        Sentry.captureException(error, { tags: { module: 'import-weather' } })
        throw error
      }
    },
    { runOnInit: true },
  )
}

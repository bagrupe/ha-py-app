import type { Payload } from 'payload'
import { getKommuneId } from './seed-kommunen'
import { upsert } from './upsert'

export const seedWeather = async (payload?: Payload) => {
  const kommune = await getKommuneId('Landkreis Hameln-Pyrmont', payload)

  await upsert(
    {
      collection: 'wettermesspunkte',
      key: 'locationName',
      data: {
        kommune,
        location: [52.199167, 9.465278],
        locationName: 'Bad Münder am Deister',
        weather: [
          {
            date: new Date().toString(),
            icon: '02n',
            maxTemp: 28.0,
            minTemp: 18.0,
          },
          {
            date: getNextDays(1).toString(),
            icon: '04n',
            maxTemp: 18.0,
            minTemp: 14.0,
          },
          {
            date: getNextDays(2).toString(),
            icon: '10n',
            maxTemp: 22.0,
            minTemp: 16.0,
          },
        ],
      },
    },
    { payload },
  )
  await upsert(
    {
      collection: 'wettermesspunkte',
      key: 'locationName',
      data: {
        kommune,
        location: [52.1082726, 9.362171],
        locationName: 'Hameln',
        weather: [
          {
            date: new Date().toString(),
            icon: '02n',
            maxTemp: 28.0,
            minTemp: 18.0,
          },
          {
            date: getNextDays(1).toString(),
            icon: '04n',
            maxTemp: 18.0,
            minTemp: 14.0,
          },
          {
            date: getNextDays(2).toString(),
            icon: '10n',
            maxTemp: 22.0,
            minTemp: 16.0,
          },
        ],
      },
    },
    { payload },
  )
  await upsert(
    {
      collection: 'wettermesspunkte',
      key: 'locationName',
      data: {
        kommune,
        location: [51.981307, 9.27113],
        locationName: 'Bad Pyrmont',
        weather: [
          {
            date: new Date().toString(),
            icon: '02n',
            maxTemp: 28.0,
            minTemp: 18.0,
          },
          {
            date: getNextDays(1).toString(),
            icon: '04n',
            maxTemp: 18.0,
            minTemp: 14.0,
          },
          {
            date: getNextDays(2).toString(),
            icon: '10n',
            maxTemp: 22.0,
            minTemp: 16.0,
          },
        ],
      },
    },
    { payload },
  )
  await upsert(
    {
      collection: 'wettermesspunkte',
      key: 'locationName',
      data: {
        kommune,
        location: [52.0772061, 9.555911],
        locationName: 'Salzhemmendorf',
        weather: [
          {
            date: new Date().toString(),
            icon: '02n',
            maxTemp: 28.0,
            minTemp: 18.0,
          },
          {
            date: getNextDays(1).toString(),
            icon: '04n',
            maxTemp: 18.0,
            minTemp: 14.0,
          },
          {
            date: getNextDays(2).toString(),
            icon: '10n',
            maxTemp: 22.0,
            minTemp: 16.0,
          },
        ],
      },
    },
    { payload },
  )
}

const getNextDays = (daysToAdd = 1, currentDate = new Date()) => {
  const nextDate = new Date(currentDate)
  nextDate.setDate(currentDate.getDate() + daysToAdd)
  return nextDate
}

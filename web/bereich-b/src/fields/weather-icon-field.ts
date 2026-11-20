import { type TextField } from 'payload'

export const weatherIconField = (options: Omit<TextField, 'type'>): TextField => {
  const { admin, ...rest } = options
  return {
    type: 'text',
    ...rest,
    admin: {
      ...admin,
      components: {
        ...admin?.components,
        Field: '@/components/admin/weather-icon-field#WeatherIconField',
      },
    },
  } as TextField
}

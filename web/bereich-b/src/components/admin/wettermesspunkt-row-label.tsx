'use client'

import { useRowLabel } from '@payloadcms/ui'

export const WettermesspunktRowLabel = () => {
  const { data } = useRowLabel<{ date?: string }>()

  return (
    <span>
      {data.date
        ? new Date(data.date).toLocaleDateString('de-DE', {
            dateStyle: 'medium',
          })
        : 'Ohne Datum'}
    </span>
  )
}

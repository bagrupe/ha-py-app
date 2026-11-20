'use client'

import { useRowLabel } from '@payloadcms/ui'

export const DateRangeRowLabel = () => {
  const { data } = useRowLabel<{ start?: string; end?: string }>()

  const formatDate = (iso: string) =>
    new Date(iso).toLocaleString('de-DE', {
      dateStyle: 'medium',
      timeStyle: 'short',
    })

  if (!data.start || !data.end) return <span>Neuer Termin</span>

  return (
    <span>
      {formatDate(data.start)} Uhr bis {formatDate(data.end)} Uhr
    </span>
  )
}

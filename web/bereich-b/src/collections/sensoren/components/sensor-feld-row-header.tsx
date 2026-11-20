'use client'

import { useConfig } from '@payloadcms/ui'
import React, { type FC, useEffect, useState } from 'react'
import type { SensorArt, Sensoren as SensorenType } from '../../../payload-types'
import { loadSensorArten } from './sensor-art-loader'

type SensorFeld = NonNullable<SensorenType['felder']>[number]
type SensorFeldRowHeaderProps = {
  data: SensorFeld
}

export const SensorFeldRowHeader: FC<SensorFeldRowHeaderProps> = ({ data }) => {
  const config = useConfig() as unknown as { serverURL?: string; routes?: { api?: string } }
  const apiRoute = config.routes?.api || '/cms/api'
  const apiUrl = config.serverURL ? `${config.serverURL}${apiRoute}` : apiRoute

  const [sensorArten, setSensorArten] = useState<SensorArt[]>([])

  useEffect(() => {
    let mounted = true

    loadSensorArten(apiUrl)
      .then((arten) => {
        if (mounted) setSensorArten(arten)
      })
      .catch(() => {
        // The admin relationship field reports its own request errors. Keep the row label usable.
      })

    return () => {
      mounted = false
    }
  }, [apiUrl])

  const populatedArt = typeof data.werteart === 'object' ? data.werteart : undefined
  const werteartId = populatedArt?.id ?? data.werteart
  const art = sensorArten.find((a) => a.id === werteartId) ?? populatedArt

  return (
    <span>
      {data.name} (Aktuell: {data.currentValue}
      {art?.einheit ?? ''})
    </span>
  )
}

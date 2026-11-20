'use client'

import React from 'react'
import { useRowLabel } from '@payloadcms/ui'
import { type Sensoren as SensorenType } from '../../payload-types'
import { SensorFeldRowHeader } from '../../collections/sensoren/components/sensor-feld-row-header'

type SensorFeld = NonNullable<SensorenType['felder']>[number]

export const SensorFeldRowLabel = () => {
  const { data } = useRowLabel<SensorFeld>()
  return React.createElement(SensorFeldRowHeader as React.FC<{ data: SensorFeld }>, { data })
}

import { getPayload, type Payload } from 'payload'

import config from '@payload-config'
import { DEFAULT_KARTENLIZENZEN } from '../lib/default-kartenlizenzen'
import { upsert } from './upsert'

export type LageHelferKommuneEnv = {
  LAGEHELFER_KOMMUNE_ID?: string
  LAGEHELFER_KOMMUNE_NAME?: string
  LAGEHELFER_REGIONALSCHLUESSEL?: string
  LAGEHELFER_DEFAULT_POSITION?: string
}

const parseDefaultPosition = (raw: string | undefined): [number, number] | undefined => {
  if (!raw?.trim()) {
    return undefined
  }

  const parts = raw.split(',').map((p) => p.trim())
  if (parts.length !== 2) {
    return undefined
  }

  const lat = Number(parts[0])
  const lon = Number(parts[1])
  if (!Number.isFinite(lat) || !Number.isFinite(lon)) {
    return undefined
  }

  return [lat, lon]
}

/** Liefert die KRL-Kommune aus den Umgebungsvariablen oder wirft bei fehlender ID. */
export const resolveLageHelferKommuneFromEnv = (
  env?: LageHelferKommuneEnv,
): {
  bereichAId: string
  name: string
  regionalschluessel: string
  defaultPosition: [number, number]
} => {
  const resolved: LageHelferKommuneEnv = env ?? {
    LAGEHELFER_KOMMUNE_ID: process.env['LAGEHELFER_KOMMUNE_ID'],
    LAGEHELFER_KOMMUNE_NAME: process.env['LAGEHELFER_KOMMUNE_NAME'],
    LAGEHELFER_REGIONALSCHLUESSEL: process.env['LAGEHELFER_REGIONALSCHLUESSEL'],
    LAGEHELFER_DEFAULT_POSITION: process.env['LAGEHELFER_DEFAULT_POSITION'],
  }
  const bereichAId = resolved.LAGEHELFER_KOMMUNE_ID?.trim()
  if (!bereichAId) {
    throw new Error('LAGEHELFER_KOMMUNE_ID is not set')
  }

  const name = resolved.LAGEHELFER_KOMMUNE_NAME?.trim()
  if (!name) {
    throw new Error('LAGEHELFER_KOMMUNE_NAME is not set')
  }

  const regionalschluessel = resolved.LAGEHELFER_REGIONALSCHLUESSEL?.trim() || '03252'
  const defaultPosition = parseDefaultPosition(resolved.LAGEHELFER_DEFAULT_POSITION) ?? [
    51.9786, 9.4264,
  ]

  return { bereichAId, name, regionalschluessel, defaultPosition }
}

/** Legt die KRL-Kommune (Mandant des LageHelfers) in der Inhaltspflege an. */
export const seedLageHelfer = async (payloadArg?: Payload) => {
  const payload = payloadArg ?? (await getPayload({ config }))
  const { bereichAId, name, regionalschluessel, defaultPosition } =
    resolveLageHelferKommuneFromEnv()

  await upsert(
    {
      collection: 'kommunen',
      key: 'bereichAId',
      data: {
        name,
        bereichAId,
        regionalschluessel,
        design: {
          colors: { primary: '#C8102E', primaryLight: '#F5C6CD' },
          fonts: { headings: 'Mulish', body: 'Mulish' },
        },
        analytics: {},
        lizenzen: { kartenlizenzen: DEFAULT_KARTENLIZENZEN },
        legal: {},
        maengelmelder: {},
        defaultPosition,
      },
    },
    { payload },
  )
}

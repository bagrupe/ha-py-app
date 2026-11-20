import { type FieldHook, type FieldHookArgs, ValidationError } from 'payload'
import { type CollectionConfig, type PayloadRequest } from 'payload'
import { type SensorArt, type Sensoren as SensorenType } from '../../payload-types'
import { accessRules, fieldAccessRules } from '../../access'
import { generatedBoolean, generatedNumber, generatedString } from '../../fields/generated-value'
import { kommuneField } from '../../fields/kommune'
import { Funktionsberechtigung } from '../../lib/funktionsberechtigungen'
import {
  getSensorAlarmLevelLoader,
  getSensorCurrentValueLoader,
  getSensorGrenzwerteLoader,
  getSensorHistorieLoader,
  getSensorLastMeasurementLoader,
} from './dataloader'

type SensorFeld = NonNullable<SensorenType['felder']>[number]

export type PegelGefahrenstufe = 'GRUEN' | 'GELB' | 'ORANGE' | 'ROT'

export const deriveShownInApp = ({
  data,
  originalDoc,
}: FieldHookArgs<SensorenType, boolean>): boolean => {
  if (!data || !Object.hasOwn(data, 'felder')) {
    return originalDoc?.shownInApp ?? false
  }

  return data.felder?.some((feld: SensorFeld) => feld.werteart) ?? false
}

const feldnamenOf = (felder: SensorFeld[] | null | undefined) =>
  (felder ?? [])
    .map((feld) => feld.name)
    .sort()
    .join('\n')

// Only the import (no user) may add or remove felder; editors can reorder and set the werteart.
export const rejectFelderSetChangesByEditors: FieldHook<SensorenType, SensorFeld[] | undefined> = ({
  value,
  previousValue,
  req,
}) => {
  if (!req.user || value === undefined) return value

  if (feldnamenOf(value) !== feldnamenOf(previousValue)) {
    throw new ValidationError({
      errors: [
        {
          path: 'felder',
          message: 'Felder können nur sortiert, nicht hinzugefügt oder entfernt werden.',
        },
      ],
    })
  }

  return value
}

// getSensorCurrentValueLoader liefert '' (nicht undefined/null) wenn kein Messwert gefunden
// wurde. Number('') === 0 in JS, ein bloßer Number.isNaN-Check würde einen fehlenden Messwert
// also fälschlich als 0 (und damit "GRUEN"/sicher) durchgehen lassen.
export const parseMesswert = (rawValue: string): number | null => {
  if (rawValue === '') return null
  const value = Number(rawValue)
  return Number.isNaN(value) ? null : value
}

export const pegelGefahrenstufeVonWert = (
  value: number,
  grenzwerte: { info1: number; info2: number; info3: number },
): PegelGefahrenstufe => {
  if (value <= grenzwerte.info1) return 'GRUEN'
  if (value <= grenzwerte.info2) return 'GELB'
  if (value <= grenzwerte.info3) return 'ORANGE'
  return 'ROT'
}

const PEGEL_HYSTERESE_CM = 9

const pegelGefahrenstufeWerte: readonly PegelGefahrenstufe[] = ['GRUEN', 'GELB', 'ORANGE', 'ROT']

const isPegelGefahrenstufe = (value: string | null | undefined): value is PegelGefahrenstufe =>
  pegelGefahrenstufeWerte.includes(value as PegelGefahrenstufe)

const stufenRang: Record<PegelGefahrenstufe, number> = { GRUEN: 0, GELB: 1, ORANGE: 2, ROT: 3 }

// Schwellenwert, ab dem die jeweilige Stufe beginnt (= Bezugspunkt für die Hysterese beim
// Herunterstufen, siehe pegelGefahrenstufeMitHysterese). GRUEN hat keine Untergrenze, da es
// bereits die niedrigste Stufe ist.
const untereGrenzeVonStufe = (
  stufe: PegelGefahrenstufe,
  grenzwerte: { info1: number; info2: number; info3: number },
): number | null => {
  switch (stufe) {
    case 'GRUEN':
      return null
    case 'GELB':
      return grenzwerte.info1
    case 'ORANGE':
      return grenzwerte.info2
    case 'ROT':
      return grenzwerte.info3
  }
}

// Verhindert häufiges Hin- und Herspringen der Informationsstufe (und damit der
// Push-Benachrichtigungen), wenn der Messwert nahe an einem Schwellenwert schwankt: eine
// Hochstufung (Wert steigt) greift sofort, eine Rückstufung (Wert sinkt) erst, wenn der
// Wert um PEGEL_HYSTERESE_CM unter den Schwellenwert der zuletzt bekannten Stufe gefallen
// ist. Ohne letzte bekannte Stufe (erste Beobachtung) wird die Rohstufe unverändert übernommen.
export const pegelGefahrenstufeMitHysterese = (
  rohStufe: PegelGefahrenstufe,
  letzteStufe: PegelGefahrenstufe | null,
  value: number,
  grenzwerte: { info1: number; info2: number; info3: number },
): PegelGefahrenstufe => {
  if (letzteStufe === null || stufenRang[rohStufe] >= stufenRang[letzteStufe]) return rohStufe

  const untereGrenze = untereGrenzeVonStufe(letzteStufe, grenzwerte)
  if (untereGrenze === null) return letzteStufe

  return value <= untereGrenze - PEGEL_HYSTERESE_CM ? rohStufe : letzteStufe
}

// Manche Sensoren sind in gold_all_in_one (noch) nicht kalibriert und liefern
// info_1..info_4 als 0/0/0/0 oder anderweitig nicht streng aufsteigend. Ohne
// diese Prüfung würde jeder Messwert > 0 fälschlich als "ROT/kritisch" gelten
// (und potenziell eine Push-Benachrichtigung auslösen).
export const sindGrenzwerteGueltig = (grenzwerte: {
  info1: number
  info2: number
  info3: number
  info4: number
}): boolean =>
  grenzwerte.info1 > 0 &&
  grenzwerte.info2 > grenzwerte.info1 &&
  grenzwerte.info3 > grenzwerte.info2 &&
  grenzwerte.info4 > grenzwerte.info3

export const Sensoren: CollectionConfig = {
  slug: 'sensoren',
  forceSelect: {
    name: true,
    letzteBenachrichtigteGefahrenstufe: true,
    felder: {
      name: true,
      werteart: true,
    },
  },
  labels: {
    singular: 'Sensor',
    plural: 'Sensoren',
  },
  admin: {
    useAsTitle: 'titel',
    group: 'Sensoren',
  },
  custom: {
    funktionsberechtigungen: [Funktionsberechtigung.InhaltspflegeSensoren],
  },
  access: {
    read: () => true,
    create: accessRules.forbidden,
    delete: accessRules.forbidden,
  },
  fields: [
    {
      type: 'ui',
      name: '_positionWarning',
      admin: {
        disableListColumn: true,
        condition: ({ positionCorrected }) => !positionCorrected,
        components: {
          Field: '@/components/admin/sensor-position-warning#SensorPositionWarning',
        },
      },
    },
    { name: 'icon', type: 'upload', relationTo: 'poi-icons' },
    {
      name: 'name',
      type: 'text',
      admin: {
        readOnly: true,
        description: 'Dies ist der Name aus dem Datensatz',
      },
      unique: true,
      required: true,
    },
    {
      name: 'titel',
      type: 'text',
      admin: {
        description: 'Unter diesem Titel wird der Sensor in der App angezeigt.',
      },
    },
    {
      name: 'shownInApp',
      type: 'checkbox',
      hooks: {
        beforeValidate: [deriveShownInApp],
      },
      admin: {
        hidden: true,
      },
    },
    {
      name: '_positionAnchor',
      type: 'ui',
      admin: {
        disableListColumn: true,
        components: {
          Field: '@/components/admin/sensor-position-anchor#SensorPositionAnchor',
        },
      },
    },
    {
      name: 'position',
      type: 'point',
      label: 'Position',
      required: true,
      hooks: {
        beforeValidate: [
          ({
            operation,
            data,
            value,
            originalDoc,
          }: FieldHookArgs<SensorenType, [number, number]>) => {
            const previousValue = originalDoc!.position

            if (
              operation !== 'update' ||
              !value ||
              (value &&
                previousValue &&
                value[0] === previousValue[0] &&
                value[1] === previousValue[1])
            ) {
              return
            }

            if (operation === 'update') {
              data!.positionCorrected = true
            }
          },
        ],
      },
    },
    { name: 'positionCorrected', type: 'checkbox', admin: { hidden: true } },
    generatedString<SensorenType>({
      name: 'letzteMessungZeitpunkt',
      nullable: true,
      value: async ({ name }, _, req) => {
        const dataloader = getSensorLastMeasurementLoader(req)

        if (req.payloadAPI === 'local') {
          return null
        }

        return (await dataloader.load(name))?.toISOString() ?? null
      },
    }),
    generatedNumber<SensorenType>({
      name: 'grenzwertInfo1',
      nullable: true,
      value: async ({ name }, _, req) => {
        if (req.payloadAPI === 'local') return null
        return (await getSensorGrenzwerteLoader(req).load(name))?.info1 ?? null
      },
    }),
    generatedNumber<SensorenType>({
      name: 'grenzwertInfo2',
      nullable: true,
      value: async ({ name }, _, req) => {
        if (req.payloadAPI === 'local') return null
        return (await getSensorGrenzwerteLoader(req).load(name))?.info2 ?? null
      },
    }),
    generatedNumber<SensorenType>({
      name: 'grenzwertInfo3',
      nullable: true,
      value: async ({ name }, _, req) => {
        if (req.payloadAPI === 'local') return null
        return (await getSensorGrenzwerteLoader(req).load(name))?.info3 ?? null
      },
    }),
    generatedNumber<SensorenType>({
      name: 'grenzwertInfo4',
      nullable: true,
      value: async ({ name }, _, req) => {
        if (req.payloadAPI === 'local') return null
        return (await getSensorGrenzwerteLoader(req).load(name))?.info4 ?? null
      },
    }),
    // glaetteAlarmLevel: Aktuelle Informationsstufe (SAFE/ADVISORY/WARNING/CRITICAL) für
    // Glätte-Sensoren. Kommt bereits fertig kategorisiert von der externen Quelle, daher
    // anders als bei Pegelstand keine Hysterese anwendbar (kein numerischer Rohwert/Schwellenwert
    // in unserer Kontrolle).
    generatedString<SensorenType>({
      name: 'glaetteAlarmLevel',
      nullable: true,
      value: async ({ name }, _, req) => {
        if (req.payloadAPI === 'local') return null
        return await getSensorAlarmLevelLoader(req).load(name)
      },
    }),
    // pegelGefahrenstufe: Berechnete Informationsstufe (GRUEN/GELB/ORANGE/ROT) für
    // Pegelstand-Sensoren, inkl. Hysterese beim Herunterstufen (siehe
    // pegelGefahrenstufeMitHysterese) relativ zur zuletzt per Push gemeldeten Stufe. Dieser
    // Wert wird sowohl für die App-Anzeige (Tacho) als auch für die Push-Auslösung genutzt,
    // damit beide immer konsistent sind.
    generatedString<SensorenType>({
      name: 'pegelGefahrenstufe',
      nullable: true,
      value: async ({ name, letzteBenachrichtigteGefahrenstufe }, _, req) => {
        if (req.payloadAPI === 'local') return null

        const grenzwerte = await getSensorGrenzwerteLoader(req).load(name)
        if (!grenzwerte || !sindGrenzwerteGueltig(grenzwerte)) return null

        const rawValue = await getSensorCurrentValueLoader(req).load([name, 'water_level_last'])
        const value = parseMesswert(rawValue)
        if (value === null) return null

        const rohStufe = pegelGefahrenstufeVonWert(value, grenzwerte)
        const letzteStufe = isPegelGefahrenstufe(letzteBenachrichtigteGefahrenstufe)
          ? letzteBenachrichtigteGefahrenstufe
          : null

        return pegelGefahrenstufeMitHysterese(rohStufe, letzteStufe, value, grenzwerte)
      },
    }),
    {
      name: 'letzteBenachrichtigteGefahrenstufe',
      type: 'text',
      admin: {
        hidden: true,
        description:
          'Zuletzt per Push gemeldete Gefahrenstufe (Watermark für den Grenzwert-Push-Job). Wird nur vom internen Service-Account geschrieben.',
      },
      access: {
        create: fieldAccessRules.superAdmin,
        update: fieldAccessRules.superAdmin,
      },
    },
    {
      name: 'ausstehendeGefahrenstufe',
      type: 'text',
      admin: {
        hidden: true,
        description:
          'Im letzten Job-Lauf beobachtete Gefahrenstufe, die noch nicht bestätigt wurde. Verhindert Push-Benachrichtigungen durch kurze Ausreißer (z.B. eine einzelne Welle), da eine neue Stufe erst nach zwei aufeinanderfolgenden Läufen mit demselben Wert gemeldet wird. Wird nur vom internen Service-Account geschrieben.',
      },
      access: {
        create: fieldAccessRules.superAdmin,
        update: fieldAccessRules.superAdmin,
      },
    },
    {
      name: 'felder',
      type: 'array',
      hooks: {
        beforeChange: [rejectFelderSetChangesByEditors],
      },
      admin: {
        components: {
          Field: '@/components/admin/sortable-sensor-felder-field#SortableSensorFelderField',
          RowLabel: '@/components/admin/sensor-feld-row-label#SensorFeldRowLabel',
        },
      },
      fields: [
        { name: 'name', type: 'text', required: true, admin: { hidden: true } },
        {
          name: 'werteart',
          type: 'relationship',
          relationTo: 'sensor-art',
        },
        generatedString<SensorenType, SensorFeld>({
          name: 'currentValue',
          value: async ({ name: sensorName }, { name: feldName }, req) => {
            if (req.payloadAPI === 'local' && !req.user) {
              return ''
            }

            const dataloader = getSensorCurrentValueLoader(req)

            return await dataloader.load([sensorName, feldName])
          },
        }),
        generatedString<SensorenType>({
          name: 'sensorname',
          value: ({ name }) => name,
        }),
        generatedBoolean<SensorenType, SensorFeld>({
          name: 'hasHistorie',
          value: (_, { werteart }) => !!werteart,
        }),
      ],
    },
    kommuneField(),
  ],
  endpoints: [
    {
      path: '/:sensorname/historie',
      method: 'get',
      handler: async (req: PayloadRequest) => {
        const sensorname = req.routeParams?.sensorname as string
        const url = new URL(req.url!)
        const feldnamenParam = url.searchParams.get('feldnamen')

        if (!feldnamenParam) {
          return Response.json({ error: 'Missing feldnamen' }, { status: 400 })
        }

        const feldnamen = feldnamenParam.split(',')

        if (feldnamen.length === 0) {
          return Response.json([], { status: 200 })
        }

        const sensor = (
          await req.payload.find({
            collection: 'sensoren',
            where: { name: { equals: sensorname } },
          })
        ).docs[0]

        if (!sensor) {
          return Response.json({ error: 'Not found' }, { status: 404 })
        }

        const valideFeldnamen = sensor.felder?.filter((f) => f.werteart).map((f) => f.name) ?? []

        const requestHasInvalidFeldnamen = feldnamen.some((n) => !valideFeldnamen.includes(n))
        if (requestHasInvalidFeldnamen) {
          return Response.json({ error: 'Invalid feld name' }, { status: 400 })
        }

        const timeframe = url.searchParams.get('timeframe') as string
        if (!timeframe || !['24h', '7d'].includes(timeframe)) {
          return Response.json({ error: 'Bad timeframe' }, { status: 400 })
        }

        const dataloader = getSensorHistorieLoader(req, timeframe)
        const loadedHistorien = await dataloader.loadMany(
          feldnamen.map((n) => {
            const feld = sensor.felder?.find((f) => f.name === n)
            const rate = (feld?.werteart as SensorArt | undefined)?.rate ?? false
            return [sensorname, n, rate]
          }),
        )

        const historien = Object.fromEntries(loadedHistorien.map((h, i) => [feldnamen[i], h]))

        return Response.json(historien, { status: 200 })
      },
    },
  ],
}

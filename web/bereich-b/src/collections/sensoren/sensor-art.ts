import { type CollectionConfig, type GroupField } from 'payload'
import { type SensorArt as SensorArtType } from '../../payload-types'
import { accessRules } from '../../access'
import { generatedString } from '../../fields/generated-value'
import { kommuneField } from '../../fields/kommune'
import { Funktionsberechtigung } from '../../lib/funktionsberechtigungen'
import { isSuperAdmin } from '../../utils/is-super-admin'

const warnstufeTextField = ({ name, label }: { name: string; label: string }): GroupField => ({
  name,
  label,
  type: 'group',
  interfaceName: 'SensorArtWarnstufeText',
  admin: {
    description:
      'Wird in der App angezeigt, wenn ein Sensor dieser Art diese Gefahrenstufe meldet.',
  },
  fields: [
    { name: 'kurzlabel', type: 'text', label: 'Kurzlabel (z.B. "Sicher", "Warnung")' },
    { name: 'titel', type: 'text', label: 'Titel (z.B. "Hochwassergefahr")' },
    { name: 'beschreibung', type: 'textarea', label: 'Beschreibung' },
  ],
})

export const formatSensorArtTitle = ({
  name,
  einheit,
}: Pick<SensorArtType, 'name' | 'einheit'>): string => {
  const normalizedName = name?.trim() ?? ''
  const normalizedUnit = einheit?.trim() ?? ''

  return normalizedUnit ? `${normalizedName} (${normalizedUnit})` : normalizedName
}

export const SensorArt: CollectionConfig = {
  slug: 'sensor-art',
  forceSelect: {
    name: true,
    einheit: true,
  },
  labels: {
    singular: 'Sensorart',
    plural: 'Sensorarten',
  },
  custom: {
    funktionsberechtigungen: [Funktionsberechtigung.InhaltspflegeSensoren],
  },
  access: {
    read: () => true,
    create: accessRules.superAdmin,
    update: accessRules.superAdmin,
    delete: accessRules.superAdmin,
  },
  admin: {
    useAsTitle: 'title',
    group: 'Sensoren',
    hidden: ({ user }) => !isSuperAdmin(user),
  },
  fields: [
    {
      name: 'name',
      type: 'text',
      required: true,
    },
    {
      name: 'einheit',
      type: 'text',
      admin: {
        description: 'Leer lassen für Sensorarten ohne numerischen Messwert (z.B. Glätte).',
      },
    },
    {
      name: 'rate',
      label: 'Rate',
      type: 'checkbox',
      admin: {
        description: 'Einheit enthält eine Zeitspanne, z.B. mm/h',
      },
      defaultValue: false,
      required: true,
    },
    {
      name: 'icon',
      type: 'upload',
      relationTo: 'poi-icons',
    },
    generatedString<SensorArtType>({
      name: 'title',
      value: formatSensorArtTitle,
    }),
    warnstufeTextField({ name: 'warnstufeText1', label: 'Informationsstufe 1 (sicher/normal)' }),
    warnstufeTextField({ name: 'warnstufeText2', label: 'Informationsstufe 2 (erhöht)' }),
    warnstufeTextField({ name: 'warnstufeText3', label: 'Informationsstufe 3 (hoch)' }),
    warnstufeTextField({ name: 'warnstufeText4', label: 'Informationsstufe 4 (kritisch)' }),
    kommuneField(),
  ],
}

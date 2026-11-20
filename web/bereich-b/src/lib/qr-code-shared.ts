export type QrType = 'none' | 'url' | 'contact' | 'coordinates'

export type Contact = {
  name?: string
  phone?: string
  email?: string
  address?: string
}

export type Coordinates = [number, number]

export type QrCodeData = {
  type?: QrType
  url?: string
  contact?: Contact
  coordinates?: Coordinates | null
}

export const QR_SVG_OPTIONS = {
  type: 'svg' as const,
  errorCorrectionLevel: 'M' as const,
  margin: 1,
}

// MECARD encodes the same contact fields as a vCard in far fewer bytes, which
// keeps the QR a lower version (coarser grid) at a given display size. Per the
// MECARD spec, `\`, `;`, `:`, and `,` are the structural separators and must be
// backslash-escaped; CR/LF are collapsed so a crafted value cannot break out.
const escapeMeCardValue = (value: string): string =>
  value
    .replace(/\\/g, '\\\\')
    .replace(/[;:,]/g, '\\$&')
    .replace(/[\r\n]+/g, ' ')

export const encodeMeCard = (contact: Contact): string | null => {
  const fields: string[] = []
  if (contact.name) fields.push(`N:${escapeMeCardValue(contact.name)}`)
  if (contact.phone) fields.push(`TEL:${escapeMeCardValue(contact.phone)}`)
  if (contact.email) fields.push(`EMAIL:${escapeMeCardValue(contact.email)}`)
  if (contact.address) fields.push(`ADR:${escapeMeCardValue(contact.address)}`)
  return fields.length > 0 ? `MECARD:${fields.join(';')};;` : null
}

export const encodePayload = (qr: QrCodeData): string | null => {
  const type = qr.type ?? 'none'
  if (type === 'url') return qr.url?.trim() || null
  if (type === 'contact') return encodeMeCard(qr.contact ?? {})
  if (type === 'coordinates' && qr.coordinates) {
    const [lat, lng] = qr.coordinates
    return `geo:${lat},${lng}`
  }
  return null
}

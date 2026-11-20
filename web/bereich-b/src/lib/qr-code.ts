import QRCode from 'qrcode'
import { getSha1Hash } from '../utils/get-sha1-hash'
import { encodePayload, QR_SVG_OPTIONS, type QrCodeData } from './qr-code-shared'

export {
  encodePayload,
  encodeMeCard,
  QR_SVG_OPTIONS,
  type Contact,
  type Coordinates,
  type QrCodeData,
  type QrType,
} from './qr-code-shared'

export type QrResponse = {
  etag: string
  render: () => Promise<string>
}

export const buildQrResponse = (qr: QrCodeData): QrResponse | null => {
  const data = encodePayload(qr)
  if (!data) return null
  const etag = `"${getSha1Hash(Buffer.from(JSON.stringify({ options: QR_SVG_OPTIONS, data })))}"`
  return { etag, render: () => QRCode.toString(data, QR_SVG_OPTIONS) }
}

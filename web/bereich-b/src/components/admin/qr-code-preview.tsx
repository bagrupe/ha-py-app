'use client'

import { useFormFields } from '@payloadcms/ui'
import QRCode from 'qrcode'
import React, { memo, useEffect, useMemo, useState, type FC } from 'react'
import {
  encodePayload,
  QR_SVG_OPTIONS,
  type Coordinates,
  type QrType,
} from '../../lib/qr-code-shared'

const selectQrCodeValues = (fields: Record<string, { value?: unknown } | undefined>) => ({
  type: fields['qrCode.type']?.value as QrType | undefined,
  url: fields['qrCode.url']?.value as string | undefined,
  name: fields['qrCode.contact.name']?.value as string | undefined,
  phone: fields['qrCode.contact.phone']?.value as string | undefined,
  email: fields['qrCode.contact.email']?.value as string | undefined,
  address: fields['qrCode.contact.address']?.value as string | undefined,
  coordinates: fields['qrCode.coordinates']?.value as Coordinates | undefined,
})

export const QrCodePreview: FC = memo(() => {
  const { type, url, name, phone, email, address, coordinates } = useFormFields(([fields]) =>
    selectQrCodeValues(fields),
  )

  const payload = useMemo(
    () =>
      type && type !== 'none'
        ? encodePayload({
            type,
            url,
            contact: { name, phone, email, address },
            coordinates,
          })
        : null,
    [type, url, name, phone, email, address, coordinates],
  )

  const [svgEntry, setSvgEntry] = useState<{
    payload: string
    svg: string | null
  } | null>(null)

  useEffect(() => {
    if (!payload) return
    let cancelled = false
    QRCode.toString(payload, QR_SVG_OPTIONS)
      .then((result) => {
        if (!cancelled) setSvgEntry({ payload, svg: result })
      })
      .catch(() => {
        if (!cancelled) setSvgEntry({ payload, svg: null })
      })
    return () => {
      cancelled = true
    }
  }, [payload])

  const svg = svgEntry?.payload === payload ? svgEntry.svg : null

  if (!type || type === 'none') return null

  return (
    <div className="mt-4 rounded border border-elevation-100 bg-elevation-50 p-4">
      <div className="mb-3 font-semibold">Vorschau</div>
      {payload && svg ? (
        <>
          <div style={{ width: 180, height: 180 }} dangerouslySetInnerHTML={{ __html: svg }} />
          <pre className="mb-0 mt-3 whitespace-pre-wrap break-all rounded bg-elevation-100 p-2 text-xs">
            {payload}
          </pre>
        </>
      ) : (
        <div className="text-elevation-300">
          Vorschau erscheint, sobald die erforderlichen Felder ausgefüllt sind.
        </div>
      )}
    </div>
  )
})

QrCodePreview.displayName = 'QrCodePreview'

export default QrCodePreview

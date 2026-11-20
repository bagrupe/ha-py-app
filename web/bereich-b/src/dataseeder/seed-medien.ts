import crypto from 'node:crypto'
import { existsSync } from 'node:fs'
import fs from 'node:fs/promises'
import path from 'node:path'
import { getPayload, type Payload } from 'payload'

import config from '@payload-config'
import { dataseederAsset } from './assets'

export const seedMedien = async (
  dirPath: string = dataseederAsset('media'),
  uploadsPath: string = path.resolve(process.cwd(), 'uploads/media'),
  kommuneId: string,
  payloadArg?: Payload,
) => {
  const payload = payloadArg ?? (await getPayload({ config }))
  const dir = await fs.readdir(dirPath)
  for (const fileName of dir) {
    const filePath = path.join(dirPath, fileName)
    const stat = await fs.stat(filePath)
    if (stat.isFile()) {
      const hash = crypto.createHash('sha1')
      const buf = await fs.readFile(filePath)
      hash.update(buf)
      const sha1 = hash.digest().toString('hex')
      const existing = (
        await payload.find({
          collection: 'medien',
          where: {
            and: [{ filename: { equals: fileName } }, { kommune: { equals: kommuneId } }],
          },
          overrideAccess: true,
        })
      ).docs[0]

      if (existing) {
        // This may occur when the backing file is deleted but the DB entry still exists.
        const missingInUploads =
          existing.filename != null && !existsSync(path.join(uploadsPath, existing.filename))

        if (existing.sha1 !== sha1 || missingInUploads) {
          await payload.update({
            collection: 'medien',
            id: existing.id,
            filePath,
            data: { kommune: kommuneId },
            overwriteExistingFiles: true,
            overrideAccess: true,
          })
          console.info(`media: Updated ${fileName}`)
        }
      } else {
        await payload.create({
          collection: 'medien',
          filePath,
          data: { kommune: kommuneId },
          overwriteExistingFiles: true,
          overrideAccess: true,
        })
        console.info(`media: Created ${fileName}`)
      }
    } else if (stat.isDirectory()) {
      await seedMedien(filePath, uploadsPath, kommuneId, payload)
    }
  }
}

export const getMediaId = async (fileName: string, kommuneId: string, payloadArg?: Payload) => {
  const payload = payloadArg ?? (await getPayload({ config }))
  const { docs } = await payload.find({
    collection: 'medien',
    where: {
      and: [{ filename: { equals: fileName } }, { kommune: { equals: kommuneId } }],
    },
    overrideAccess: true,
  })

  if (docs.length === 0) {
    throw new Error(`Could not associate ${fileName} with any Id`)
  }

  return docs[0].id
}

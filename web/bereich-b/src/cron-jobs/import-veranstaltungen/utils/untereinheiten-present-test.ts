import { getPayload } from 'payload'
import config from '@payload-config'

export const hasUntereinheiten = async () => {
  const payload = await getPayload({ config })
  const result = await payload.find({ collection: 'untereinheit' })
  return result.totalDocs > 0
}

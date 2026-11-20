import crypto from 'node:crypto'

export const getSha1Hash = (buf: Buffer): string => {
  const hash = crypto.createHash('sha1')
  hash.update(buf)
  const digest = hash.digest()

  return digest.toString('hex')
}

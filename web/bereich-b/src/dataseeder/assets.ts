import path from 'node:path'

// cwd statt __dirname: im Server-Bundle zeigt __dirname auf .next/server/chunks, wo die Assets nicht liegen.
export const dataseederAsset = (...segments: string[]) =>
  path.resolve(process.cwd(), 'src/dataseeder', ...segments)

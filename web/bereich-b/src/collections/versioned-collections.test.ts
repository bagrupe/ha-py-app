import { readFileSync, readdirSync } from 'node:fs'
import { join } from 'node:path'
import { describe, expect, it } from 'vitest'

// Das Default-Access-Control-Plugin umschließt `readVersions` nicht. Eine versionierte
// Collection ohne eigene Regel fällt damit auf Payloads Standard zurück und gibt Entwürfe
// an jeden angemeldeten Nutzer heraus. Der Test liest die Quelldateien, damit eine neue
// versionierte Collection auffällt, ohne die komplette Payload-Config zu laden.
const collectionSources = (directory: string): string[] =>
  readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    const full = join(directory, entry.name)
    if (entry.isDirectory()) return collectionSources(full)
    return entry.name.endsWith('.ts') && !entry.name.endsWith('.test.ts') ? [full] : []
  })

const versionedFiles = collectionSources(__dirname).filter((file) =>
  /^\s*versions:\s*\{/m.test(readFileSync(file, 'utf8')),
)

describe('versioned collections', () => {
  it('still finds the known versioned collection', () => {
    expect(versionedFiles.some((file) => file.endsWith('news-artikel.ts'))).toBe(true)
  })

  it.each(versionedFiles)('%s declares an explicit readVersions rule', (file) => {
    expect(readFileSync(file, 'utf8')).toMatch(/readVersions:/)
  })
})

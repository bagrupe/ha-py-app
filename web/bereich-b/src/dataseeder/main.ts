// Kein dotenv-Import: fehlt im standalone-Image; dev lädt .env via --env-file-if-exists.
import { getPayload } from 'payload'
import config from '@payload-config'
import { SEEDERS } from './run-all'

export const main = async () => {
  const payload = await getPayload({ config })

  const args = process.argv.slice(2)
  let count = 0
  for (const [name, seed] of SEEDERS) {
    if (args.includes('all') || args.includes(name)) {
      count += 1
      await seed(payload)
    }
  }

  console.info(`Ran ${count} of ${SEEDERS.length} seeders`)

  if (count === 0) {
    console.info('Use `all` to run all seeders, or one of:', SEEDERS.map(([name]) => name).sort())
    process.exit(1)
  }
  process.exit()
}

void main()

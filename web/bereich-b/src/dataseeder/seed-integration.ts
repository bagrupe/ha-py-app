///////////////////////////////////////////////////////////////
// 🚧 TODO 🚧
// GET CREDENTIALS FOR FOLLOWING SYSTEM
// CURRENTLY DISABLED BECAUSE NO CREDENTIALS PROVIDED
///////////////////////////////////////////////////////////////

import type { Payload } from 'payload'
import { getKommuneId } from './seed-kommunen'
import { upsert } from './upsert'

// enum CategoryIds {
//   topThema = '2561.264.1',
//   aktuelles = '2561.154.1',
// }
export const seedIntegration = async (payload?: Payload) => {
  console.warn(
    `--- seedIntegration--- MISSING CREDENTIALS TO IMPORT FROM https://hm.ikiss.de AND https://service.hameln-pyrmont.de`,
  )
  // await upsert({
  //   key: ['integrationtype', 'kommune'],
  //   collection: 'integration',
  //   data: {
  //     integrationtype: 'IKISS',
  //     zugangsdaten: {
  //       benutzername: process.env.IKISS_HAPY_USERNAME || '',
  //       passwort: process.env.IKISS_HAPY_PASSWORD || '',
  //     },
  //     url: 'https://hm.ikiss.de',
  //     konfiguration: {
  //       kategorien: [
  //         {kategorie: CategoryIds.topThema, gewichtung: 10},
  //         {kategorie: CategoryIds.aktuelles, gewichtung: 0},
  //       ],
  //     },

  //     kommune: await getKommuneId('Landkreis Hameln-Pyrmont'),
  //   },
  // });
  // await upsert({
  //   key: ['integrationtype', 'kommune'],
  //   collection: 'integration',
  //   data: {
  //     integrationtype: 'NOLIS',
  //     zugangsdaten: {
  //       token: process.env.NOLIS_HAPY_TOKEN || '',
  //     },
  //     url: 'https://service.hameln-pyrmont.de',
  //     kommune: await getKommuneId('Landkreis Hameln-Pyrmont'),
  //   },
  // });
  const kommune = await getKommuneId('Landkreis Hameln-Pyrmont', payload)
  await upsert(
    {
      key: ['integrationtype', 'kommune'],
      collection: 'integration',
      data: {
        integrationtype: 'RSS',
        konfiguration: {
          content: 'content:encoded',
        },
        url: 'https://www.hameln.de/de/index.php?type=133',
        kommune,
      },
    },
    { payload },
  )
}

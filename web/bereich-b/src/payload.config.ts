import { mongooseAdapter } from '@payloadcms/db-mongodb'
import { de } from '@payloadcms/translations/languages/de'
import { migrations } from './migrations'
import { lexicalEditor } from '@payloadcms/richtext-lexical'
import * as Sentry from '@sentry/nextjs'
import path from 'path'
import { buildConfig } from 'payload'
import { fileURLToPath } from 'url'
import sharp from 'sharp'
import type { SharpDependency } from 'payload'

// Domain 1: Kommunen (tenant system)
import { Kommunen } from './collections/kommunen'
// Domain 2: Benutzer (authentication)
import { Benutzer } from './collections/benutzer'
// Domain 3: Untereinheit (organization units)
import { Untereinheit } from './collections/untereinheit'
// Domain 4: Medien (uploads)
import { Aufrufemedien, Medien, PoiIcons, Veranstaltungsmedien } from './collections/medien'
// Domain 5: News-Artikel
import { NewsArtikel } from './collections/news-artikel/news-artikel'
// Domain 5b: Aufrufe (Vereinsaufrufe)
import { Aufrufe } from './collections/aufrufe/aufrufe'
// Domain 6: Veranstaltungen (events)
import { Veranstaltungskalender } from './collections/veranstaltungen/veranstaltungskalender'
import { VeranstaltungskalenderKategorie } from './collections/veranstaltungen/kategorien'
import { VeranstaltungskalenderQuelle } from './collections/veranstaltungen/quellen'
// Domain 7: POIs
import { Pois } from './collections/pois/pois'
import { PoiCategories } from './collections/pois/poi-categories'
import { PoiSupercategories } from './collections/pois/poi-supercategories'
// Domain 8: Sensoren
import { Sensoren } from './collections/sensoren/sensoren'
import { SensorArt } from './collections/sensoren/sensor-art'
// Domain 9: Wettermesspunkte
import { Wettermesspunkte } from './collections/wettermesspunkte'
// Domain 10: Geoflaechen
import { Geoflaechen } from './collections/geoflaechen'
import { OsmGrenzen } from './collections/osm-grenzen'
// Domain 11: Integrationen
import { Integration } from './collections/integrations/integration'

// GraphQL resolvers
import { mergeResolvers } from './utils/merge-queries'
import { kommuneByBereichAIdQuery } from './graphql/queries/kommune-by-bereich-a-id'
import { geoflaechenByBereichAId } from './graphql/queries/geoflaechen-by-bereich-a-id'
import { isPointInGeoflaecheQuery } from './graphql/queries/is-point-in-geoflaeche'
import { unnotifiedNewsArtikel } from './graphql/queries/unnotified-news-artikel'
import { veranstaltungsTermineQuery } from './graphql/queries/veranstaltungs-termine'
import { setNewsArtikelNotified } from './graphql/mutations/set-news-artikel-notified'
import { setSensorGefahrenstufeNotified } from './graphql/mutations/set-sensor-gefahrenstufe-notified'

// Plugins
import { defaultAccessControl } from './plugins/default-access-control'
import { sentryPlugin } from './plugins/sentry'

const filename = fileURLToPath(import.meta.url)
const dirname = path.dirname(filename)

export const payloadCollections = [
  // Tenant & auth
  Kommunen,
  Benutzer,
  Untereinheit,
  // Media / uploads
  Medien,
  PoiIcons,
  Veranstaltungsmedien,
  Aufrufemedien,
  // Content
  NewsArtikel,
  Aufrufe,
  // Events
  Veranstaltungskalender,
  VeranstaltungskalenderKategorie,
  VeranstaltungskalenderQuelle,
  // POIs
  Pois,
  PoiCategories,
  PoiSupercategories,
  // Sensors
  Sensoren,
  SensorArt,
  // Weather & geo
  Wettermesspunkte,
  Geoflaechen,
  OsmGrenzen,
  // Integrations
  Integration,
]

export default buildConfig({
  serverURL: process.env.NEXT_PUBLIC_SERVER_URL,
  db: mongooseAdapter({ url: process.env.DATABASE_URL || '', prodMigrations: migrations }),
  editor: lexicalEditor(),
  sharp: sharp as unknown as SharpDependency,
  secret: process.env.PAYLOAD_SECRET || '',

  collections: payloadCollections,
  globals: [],

  // Route prefix to match v1's /cms/admin and /cms/api
  routes: {
    admin: '/cms/admin',
    api: '/cms/api',
  },

  admin: {
    user: Benutzer.slug,
    importMap: { baseDir: path.resolve(dirname) },
    meta: {
      icons: [{ rel: 'icon', url: '/hapy-logo.svg' }],
    },
    components: {
      graphics: {
        Icon: '@/components/branding/hapy-logo#HapyLogoIcon',
      },
      providers: ['@/components/query-client#QueryClientProvider'],
      afterNavLinks: ['@/components/admin/after-nav-links#NavLinks'],
      views: {
        login: {
          Component: '@/components/admin/login-redirect#LoginRedirect',
          path: '/login',
        },
      },
    },
  },

  i18n: {
    supportedLanguages: { de },
    fallbackLanguage: 'de',
  },

  localization: {
    locales: [
      { code: 'de', label: 'Deutsch' },
      { code: 'en', label: 'English' },
    ],
    defaultLocale: 'de',
    fallback: false,
  },

  typescript: {
    outputFile: path.resolve(dirname, 'payload-types.ts'),
  },

  graphQL: {
    schemaOutputFile: path.resolve(dirname, '../../../backend/API/BereichB.graphql'),
    queries: mergeResolvers({
      KommuneByBereichAId: kommuneByBereichAIdQuery,
      GeoflaechenByBereichAId: geoflaechenByBereichAId,
      IsPointInGeoflaeche: isPointInGeoflaecheQuery,
      UnnotifiedNewsArtikel: unnotifiedNewsArtikel,
      VeranstaltungsTermine: veranstaltungsTermineQuery,
    }),
    mutations: mergeResolvers({
      SetNewsArtikelNotified: setNewsArtikelNotified,
      SetSensorGefahrenstufeNotified: setSensorGefahrenstufeNotified,
    }),
  },

  onInit: async (payload) => {
    if (process.env.SKIP_PAYLOAD_ON_INIT === 'true') {
      payload.logger.warn(
        'SKIP_PAYLOAD_ON_INIT=true: startup migrations, index setup, seeding, and cron jobs are disabled.',
      )
      return
    }

    const { runStartupMigrations } = await import('./startup-migrations')
    await runStartupMigrations(payload)
    const { ensureIndexes } = await import('./ensure-indexes')
    await ensureIndexes(payload)
    const { seedBenutzer } = await import('./dataseeder/seed-benutzer')
    await seedBenutzer(payload)

    // Läuft im Server-Prozess: das standalone-Image hat keine node_modules/tsx für den Quellcode-Pfad.
    if (process.env.ENABLE_DATASEEDER === 'true') {
      try {
        const { runAllSeeders } = await import('./dataseeder/run-all')
        await runAllSeeders(payload)
      } catch (error) {
        payload.logger.error({ error: String(error) }, 'Data seeder failed — continuing startup')
        Sentry.captureException(error, { tags: { module: 'dataseeder' } })
      }
    }

    // Eigenes Opt-in, unabhängig von ENABLE_DATASEEDER: Staging soll nur den KRL-Mandanten erhalten.
    const { isLageHelferSeedEnabled } = await import('./dataseeder/is-lagehelfer-seed-enabled')
    if (isLageHelferSeedEnabled()) {
      try {
        const { seedLageHelfer } = await import('./dataseeder/seed-lagehelfer')
        await seedLageHelfer(payload)
      } catch (error) {
        payload.logger.error(
          { error: String(error) },
          'LageHelfer seeder failed — continuing startup',
        )
        Sentry.captureException(error, { tags: { module: 'dataseeder' } })
      }
    }

    const { setupCronJobs } = await import('./cron-jobs')
    await setupCronJobs()
  },

  telemetry: false,

  upload: {
    limits: { fileSize: 50_000_000 },
  },

  plugins: [
    sentryPlugin({
      Sentry,
      captureErrors: [500],
    }),
    defaultAccessControl,
  ],
})

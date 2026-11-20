import { withPayload } from '@payloadcms/next/withPayload'
import { withSentryConfig } from '@sentry/nextjs/config'

/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
  typescript: { ignoreBuildErrors: true },
  serverExternalPackages: [
    'overpass-ts',
    'node-fetch',
    'osmtogeojson',
    'node-cron',
    'mongoose',
    'require-in-the-middle',
    'import-in-the-middle',
  ],
  webpack: (webpackConfig) => {
    webpackConfig.resolve.extensionAlias = {
      '.cjs': ['.cts', '.cjs'],
      '.js': ['.ts', '.tsx', '.js', '.jsx'],
      '.mjs': ['.mts', '.mjs'],
    }

    return webpackConfig
  },
}

// Source-map upload only runs when SENTRY_AUTH is set (CI); without it withSentryConfig builds unchanged.
export default withSentryConfig(withPayload(nextConfig, { devBundleServerPackages: false }), {
  org: process.env.SENTRY_ORG,
  project: process.env.SENTRY_PROJECT,
  sentryUrl: process.env.SENTRY_URL || 'https://sentry.io',
  authToken: process.env.SENTRY_AUTH,
  release: {
    name: process.env.CI_COMMIT_REF_SLUG ?? 'none',
  },
  silent: true,
  telemetry: false,
  webpack: {
    treeshake: {
      removeDebugLogging: true,
    },
  },
})

import {sentryVitePlugin} from '@sentry/vite-plugin';
import react from '@vitejs/plugin-react-swc';
import {defineConfig} from 'vitest/config';
import {SENTRY_ORG, SENTRY_PROJECT, SENTRY_URL} from './src/sentry';

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    react(),
    sentryVitePlugin({
      disable: !process.env.SENTRY_AUTH,
      url: process.env.SENTRY_URL || SENTRY_URL,
      org: process.env.SENTRY_ORG || SENTRY_ORG,
      project: process.env.SENTRY_PROJECT || SENTRY_PROJECT,
      telemetry: false,
      release: {
        name: process.env.CI_COMMIT_REF_SLUG ?? 'none',
        create: true,
      },
      authToken: process.env.SENTRY_AUTH,
    }),
  ],
  build: {
    sourcemap: true,
  },
  server: {
    port: 3003,
    host: '0.0.0.0',
    proxy: {
      '/graphql': 'http://127.0.0.1:5000',
      '/api': 'http://127.0.0.1:5000',
    },
  },
  test: {
    env: {TZ: 'Europe/Berlin'},
  },
});

import {createRequire} from 'node:module';
import path from 'node:path';
import {sentryVitePlugin} from '@sentry/vite-plugin';
import react from '@vitejs/plugin-react-swc';
import {defineConfig} from 'vite';
import tsconfigPaths from 'vite-tsconfig-paths';
import {SENTRY_ORG, SENTRY_PROJECT, SENTRY_URL} from './src/lib/sentry.ts';

const require = createRequire(import.meta.url);
const bufferPolyfillPath = require.resolve('buffer/index.js');
const bufferShimId = 'virtual:buffer-shim';
const resolvedBufferShimId = `\0${bufferShimId}`;

// https://vitejs.dev/config/
export default defineConfig({
  define: {
    global: 'globalThis',
  },
  plugins: [
    {
      name: 'buffer-polyfill-shim',
      enforce: 'pre',
      resolveId(id) {
        if (id === 'buffer' || id === 'node:buffer')
          return resolvedBufferShimId;
      },
      load(id) {
        if (id !== resolvedBufferShimId) return null;
        return `
import { Buffer } from ${JSON.stringify(bufferPolyfillPath)};
export { Buffer };
export default { Buffer };
`;
      },
    },
    react(),
    tsconfigPaths(),
    sentryVitePlugin({
      disable: !process.env.SENTRY_AUTH,
      url: process.env.SENTRY_URL || SENTRY_URL,
      org: process.env.SENTRY_ORG || SENTRY_ORG,
      project: process.env.SENTRY_PROJECT || SENTRY_PROJECT,
      telemetry: false,
      release: {
        name: process.env.CI_COMMIT_REF_SLUG ?? 'none',
        create: true,
        setCommits: {
          commit: process.env.CI_COMMIT_SHA,
          repo: 'hannIT / KommunalApp',
        },
      },
      authToken: process.env.SENTRY_AUTH,
    }),
  ],
  resolve: {
    alias: {
      // @tisoap/react-flow-smart-edge imports @xyflow/react but pnpm strict
      // resolution maps it under a different name in the virtual store
      '@xyflow/react': path.resolve(__dirname, 'node_modules/@xyflow/react'),
    },
  },
  optimizeDeps: {
    entries: ['index.html'],
    esbuildOptions: {
      define: {
        global: 'globalThis',
      },
      plugins: [
        {
          name: 'optimize-buffer-polyfill',
          setup(build) {
            build.onResolve({filter: /^node:buffer$/}, () => ({
              path: bufferPolyfillPath,
            }));
            build.onResolve({filter: /^buffer$/}, () => ({
              path: bufferPolyfillPath,
            }));
          },
        },
      ],
    },
  },
  build: {
    sourcemap: true,
  },
  server: {
    port: 3000,
    host: '0.0.0.0',
    proxy: {
      '/graphql': 'http://127.0.0.1:5000',
      '/api': 'http://127.0.0.1:5000',
      '/cms': {
        target: 'http://127.0.0.1:3001',
        ws: true,
      },
      '/_next': {target: 'http://127.0.0.1:3001', ws: true},
      // Next 16 serves its dev endpoints outside /cms and /_next. Turbopack's HMR
      // socket lives at /turbopack-hmr (webpack's was under /_next). Unproxied they
      // hit Vite's SPA fallback and get bereich-a's index.html, the dev client's
      // connect() fails, and hydrate() never runs — the admin renders read-only.
      '/__nextjs': {target: 'http://127.0.0.1:3001', ws: true},
      // '/turbopack-hmr': {target: 'http://127.0.0.1:3001', ws: true},
    },
  },
});

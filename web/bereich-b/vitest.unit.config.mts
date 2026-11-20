import { defineConfig } from 'vitest/config'
import tsconfigPaths from 'vite-tsconfig-paths'

export default defineConfig({
  plugins: [tsconfigPaths()],
  test: {
    include: ['src/**/*.test.ts'],
    coverage: {
      provider: 'v8',
      include: ['src/**/*.{ts,tsx}'],
      exclude: [
        '**/*.test.ts',
        '**/__tests__/**',
        'src/payload-types.ts',
        'src/migrations/**',
        'src/**/*.d.ts',
      ],
      reporter: ['text', 'lcov'],
    },
  },
})

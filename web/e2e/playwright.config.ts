import path from 'node:path';
import {fileURLToPath} from 'node:url';
import {defineConfig, devices} from '@playwright/test';
import {config} from 'dotenv';
import compact from 'lodash/compact.js';

/**
 * Read environment variables from file.
 * https://github.com/motdotla/dotenv
 */
config();

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const TEST_CHROMIUM = process.env.CHROMIUM !== 'false';
const TEST_FIREFOX = process.env.FIREFOX !== 'false';
const TEST_WEBKIT = process.env.WEBKIT !== 'false';

export const STORAGE_STATE = path.join(__dirname, 'playwright/.auth/user.json');
export const SESSION_STORAGE_STATE = path.join(
  __dirname,
  'playwright/.auth/session-storage.json',
);

/**
 * See https://playwright.dev/docs/test-configuration.
 */
export default defineConfig({
  testDir: './tests',
  /* Run tests in files in parallel */
  fullyParallel: true,
  /* Fail the build on CI if you accidentally left test.only in the source code. */
  forbidOnly: !!process.env.CI,
  /* Retry on CI only */
  retries: process.env.CI ? 2 : 0,
  /* Opt out of parallel tests on CI. */
  workers: process.env.CI ? 1 : undefined,
  /* Reporter to use. See https://playwright.dev/docs/test-reporters */
  reporter: 'html',
  /* Shared settings for all the projects below. See https://playwright.dev/docs/api/class-testoptions. */
  use: {
    /* Base URL to use in actions like `await page.goto('/')`. */
    baseURL: process.env.FRONTEND_URL,

    /* Collect trace when retrying the failed test. See https://playwright.dev/docs/trace-viewer */
    trace: 'on-first-retry',
    video: process.env.CI ? 'retain-on-failure' : undefined,
  },

  /* Configure projects for major browsers */
  projects: compact([
    {
      name: 'setup',
      testMatch: /global\.setup\.ts/,
    },
    TEST_CHROMIUM && {
      name: 'chromium',
      use: {...devices['Desktop Chrome'], storageState: STORAGE_STATE},
      dependencies: ['setup'],
    },
    TEST_FIREFOX && {
      name: 'firefox',
      use: {...devices['Desktop Firefox'], storageState: STORAGE_STATE},
      dependencies: ['setup'],
    },
    TEST_WEBKIT && {
      name: 'webkit',
      use: {...devices['Desktop Safari'], storageState: STORAGE_STATE},
      dependencies: ['setup'],
    },
  ]),
});

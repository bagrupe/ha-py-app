import {readFileSync} from 'node:fs';
import {test as base, expect} from '@playwright/test';
import {SESSION_STORAGE_STATE} from '../playwright.config';

/**
 * Custom test fixture that restores sessionStorage from global setup.
 * bereich-a stores auth in sessionStorage (not cookies/localStorage),
 * so Playwright's built-in storageState doesn't cover it.
 */
export const test = base.extend({
  authenticatedPage: async ({page}, use) => {
    const sessionData = JSON.parse(
      readFileSync(SESSION_STORAGE_STATE, 'utf-8'),
    );

    // Use a blank page on the same origin to inject sessionStorage
    // before the app reads it
    await page.goto(`${process.env.BEREICH_A_URL}/auth/login`);

    await page.evaluate((data) => {
      const entries = JSON.parse(data);
      for (const [key, value] of Object.entries(entries)) {
        sessionStorage.setItem(key, value as string);
      }
    }, JSON.stringify(sessionData));

    await use(page);
  },
});

export {expect};

import {writeFileSync} from 'node:fs';
import {expect, test as setup} from '@playwright/test';
import {SESSION_STORAGE_STATE, STORAGE_STATE} from '../playwright.config';

setup('authenticate', async ({page}) => {
  await page.goto(`${process.env.BEREICH_A_URL}/auth/login`);
  await page.getByLabel('E-Mail').fill('sachbearbeiter-hapy@example.com');
  await page.getByLabel('Passwort').fill('123456');
  await page.getByRole('button', {name: 'Anmelden'}).click();
  await expect(page.getByRole('heading', {name: 'Neue Anträge'})).toBeVisible({
    timeout: 15000,
  });

  // Save cookies/localStorage via Playwright's storageState
  await page.context().storageState({path: STORAGE_STATE});

  // Save sessionStorage separately (Playwright doesn't persist it)
  const sessionStorage = await page.evaluate(() =>
    JSON.stringify(sessionStorage),
  );
  writeFileSync(SESSION_STORAGE_STATE, sessionStorage);
});

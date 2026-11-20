import {expect, type Page} from '@playwright/test';

export async function login(page: Page, email: string, password = '123456') {
  await page.goto(`${process.env.BEREICH_A_URL}/auth/login`);
  await page.getByLabel('E-Mail').fill(email);
  await page.getByLabel('Passwort').fill(password);
  await page.getByRole('button', {name: 'Anmelden'}).click();
  await expect(page.getByRole('heading', {name: 'Neue Anträge'})).toBeVisible({
    timeout: 15000,
  });
}

export async function logout(page: Page) {
  await page.getByRole('button', {name: /abmelden/i}).click();
  await expect(
    page.getByRole('heading', {name: 'Herzlich Willkommen!'}),
  ).toBeVisible({timeout: 5000});
}

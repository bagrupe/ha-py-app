import {test, expect} from '../fixtures';

/**
 * T-E2E-3: Media serving — images load correctly in bereich-a from CMS media endpoint
 */

test.describe('Media serving', () => {
  test('kommune logo loads on the login page', async ({page}) => {
    await page.goto(`${process.env.BEREICH_A_URL}/auth/login`);
    await expect(
      page.getByRole('heading', {name: 'Herzlich Willkommen!'}),
    ).toBeVisible();

    const logoImage = page.getByAltText('Logo der Kommune').first();
    await expect(logoImage).toBeVisible({timeout: 10000});

    const loaded = await logoImage.evaluate(
      (img: HTMLImageElement) => img.naturalWidth > 0,
    );
    expect(loaded).toBe(true);
  });

  test('media files are accessible after login', async ({
    authenticatedPage,
  }) => {
    await authenticatedPage.goto(`${process.env.BEREICH_A_URL}/antraege/neu`);
    await expect(
      authenticatedPage.getByRole('heading', {name: 'Neue Anträge'}),
    ).toBeVisible({timeout: 10000});

    const cmsImage = authenticatedPage.locator('img[src*="/cms/"]').first();
    await expect(cmsImage).toBeVisible({timeout: 10000});

    // Wait for the image to fully load (naturalWidth > 0)
    await expect(cmsImage).toHaveJSProperty('complete', true, {timeout: 10000});
    const loaded = await cmsImage.evaluate(
      (img: HTMLImageElement) => img.naturalWidth > 0,
    );
    expect(loaded).toBe(true);
  });
});

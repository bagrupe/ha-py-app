import {test, expect} from '../fixtures';
import {login, logout} from '../helpers';

/**
 * T-E2E-2: bereich-a ↔ bereich-b — frontend loads and displays CMS data
 */

test.describe('Frontend displays CMS data', () => {
  test('dashboard shows Neue Anträge', async ({authenticatedPage}) => {
    await authenticatedPage.goto(`${process.env.BEREICH_A_URL}/antraege/neu`);
    await expect(
      authenticatedPage.getByRole('heading', {name: 'Neue Anträge'}),
    ).toBeVisible({timeout: 10000});
  });

  test('Nutzendenverwaltung loads user list', async ({page}) => {
    // superadmin has BACKOFFICE_NUTZENDENVERWALTUNG permission
    await login(page, 'superadmin-hapy@example.com');
    await page.goto(`${process.env.BEREICH_A_URL}/nutzendenverwaltung`);
    await expect(
      page.getByRole('heading', {name: 'Nutzendenverwaltung', level: 1}),
    ).toBeVisible({timeout: 10000});
    await logout(page);
  });

  test('GraphQL API returns kommune data', async ({request}) => {
    const response = await request.post(
      `${process.env.BEREICH_A_URL}/graphql`,
      {
        data: {
          query: '{ kommunen { id name } }',
        },
      },
    );

    expect(response.ok()).toBe(true);
    const body = await response.json();
    expect(body.data.kommunen).toBeDefined();
    expect(body.data.kommunen.length).toBeGreaterThan(0);
  });
});

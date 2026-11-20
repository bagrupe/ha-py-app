import {test, expect} from '../fixtures';
import {login, logout} from '../helpers';

test('log in and log out', async ({page}) => {
  await login(page, 'sachbearbeiter-hapy@example.com');

  const heading = page.getByRole('heading', {name: 'Neue Anträge'});
  await expect(heading).toBeVisible();

  await logout(page);
});

# e2e

End-to-end tests with [Playwright](https://playwright.dev/docs/intro).

These tests run in GitLab CI on a transient app deployment (separate from QA).

## Local testing

1. Install dependencies: `pnpm install`
2. Set up environment variables: `cp .env.example .env`
3. Execute `pnpm run test`

If you want to see the browser while tests are running, add the `--headed` flag. You may want to deactivate all
browsers except for one in `.env` to avoid cluttering your screen with browsers.

## Code generation

You can let Playwright generate code for tests on the fly by executing

```shell
pnpm playwright codegen http://localhost:3000
```

This will launch a browser with the specified page. As you interact with the page, code fragments corresponding to your
actions will be generated.

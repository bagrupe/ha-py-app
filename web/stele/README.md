# Stele (Infostele)

Public-facing kiosk web app for digital info pillars (“Stele”). It shows municipal news, calls for action (“Aufrufe”), weather in the header, and optional POI map content. The UI is optimized for touch displays with an inactivity timer that resets the session.

## Tech stack

-   **React 18** + **TypeScript** + **Vite**
-   **Tailwind CSS** for styling
-   **urql** + **GraphQL** (schema in `schema.graphql`, codegen via `@kommunalapp/codegen`)
-   **React Router** for routing
-   **Storybook** for component development
-   **Vitest** for unit tests

GraphQL requests use a **same-origin** `/graphql` URL. In development, Vite proxies `/graphql` and `/api` to the backend. In production, the Stele **nginx** container proxies those paths to `STELE_BACKEND_ORIGIN`.

## Getting started

Stele is part of the `web/` pnpm workspace. Install dependencies from `web/` (see root [README](../../README.md#-web-applications-react--cms)).

1. Copy environment variables:

    ```bash
    cp .env.example .env
    ```

2. Set at least `VITE_KOMMUNE_ID` (and other flags as needed; see below).

3. Start the backend locally (default API port **5000** for the Vite proxy).

4. Start the dev server:

    ```bash
    # from web/
    pnpm --filter stele dev

    # or from web/stele/
    pnpm dev
    ```

    Dev server: [http://localhost:3003](http://localhost:3003)

## Environment variables

Build-time variables (`VITE_*`) are inlined by Vite. In CI, `DEPLOYMENT_ENV_FILE` is copied to `.env.production` before `pnpm turbo build`.

| Variable                                    | Description                                                                |
| ------------------------------------------- | -------------------------------------------------------------------------- |
| `VITE_KOMMUNE_ID`                           | Payload CMS kommune ID used for GraphQL filters                            |
| `VITE_UNTEREINHEITEN_IDS`                   | Optional comma-separated untereinheit IDs                                  |
| `VITE_AKTUELLES_NEWS_LIMIT`                 | Max news articles in carousel (default: 10)                                |
| `VITE_CAROUSEL_SLIDER_AUTOPLAY_DELAY_MS`    | Carousel autoplay delay (default: 10000)                                   |
| `VITE_ACTIVITY_TIMER_DURATION_SECS`         | Inactivity timeout before reload (default: 120)                            |
| `VITE_ACTIVITY_TIMER_WINDOW_THRESHOLD_SECS` | Seconds before timeout when the “still there?” modal appears (default: 10) |
| `VITE_AUFRUFE_QR_ENABLED`                   | Set to `true` to show QR codes on Aufruf slides                            |
| `VITE_SHOW_POI_MAP`                         | Set to `true` to enable the `/map` route and POI teaser on home            |

Runtime variable (Docker/nginx only):

| Variable               | Description                                                                                                                                        |
| ---------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| `STELE_BACKEND_ORIGIN` | Backend origin for proxying `/graphql` and `/api` (scheme + host + port, no path). Example: `http://backend:8080` on the deployment Docker network |

## Scripts

| Command                         | Description                 |
| ------------------------------- | --------------------------- |
| `pnpm dev`                      | Vite dev server (port 3003) |
| `pnpm build`                    | Production build to `dist/` |
| `pnpm preview`                  | Preview production build    |
| `pnpm graphql`                  | Regenerate GraphQL types    |
| `pnpm typecheck`                | TypeScript check            |
| `pnpm lint` / `pnpm lint:check` | ESLint                      |
| `pnpm test` / `pnpm test:ci`    | Vitest                      |
| `pnpm storybook`                | Storybook on port 6006      |

## Routes

| Path   | Description                                       |
| ------ | ------------------------------------------------- |
| `/`    | Home: news carousel, Aufrufe, optional map teaser |
| `/map` | POI map (only if `VITE_SHOW_POI_MAP=true`)        |

## Docker image

The production image is nginx serving the static `dist/` bundle and proxying API traffic:

```bash
pnpm build
docker build -f docker/Dockerfile .
```

`STELE_BACKEND_ORIGIN` must be set when the container starts (see `docker/docker-entrypoint.sh`).

CI builds and pushes `stele:stele-<version>` to the GitLab registry on `backend-*` release tags; deployment is handled with the unified stack in [`ci/components/stele.gitlab-ci.yml`](../../ci/components/stele.gitlab-ci.yml) and [`ci/deployment.gitlab-ci.yml`](../../ci/deployment.gitlab-ci.yml).

## Staging URL

When deployed, Stele is exposed at the hostname set as `STELE_DOMAIN` in `DEPLOYMENT_ENV_FILE` (via the main reverse proxy template `docker/nginx/reverse-proxy.conf.template`).

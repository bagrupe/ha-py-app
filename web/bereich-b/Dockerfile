# musl must match the CI build image (ci/pnpm.gitlab-ci.yml: node alpine) or sharp's binaries fail to load
FROM node:22.14.0-alpine

WORKDIR /app

ENV NODE_ENV=production

RUN apk add --no-cache tzdata su-exec
ENV TZ=Europe/Berlin

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# In a monorepo, pnpm symlinks in bereich-b/node_modules resolve to
# ../../node_modules/.pnpm/*, so we must preserve the full directory structure.
COPY --chown=nextjs:nodejs .next/standalone ./
COPY --chown=nextjs:nodejs .next/static ./bereich-b/.next/static
COPY --chown=nextjs:nodejs public ./bereich-b/public
# Only the seed assets — the seeder code is bundled into the server build (runs via onInit)
COPY --chown=nextjs:nodejs src/dataseeder ./bereich-b/src/dataseeder
COPY docker/docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh \
  && mkdir -p ./bereich-b/uploads/media \
  && chown -R nextjs:nodejs ./bereich-b/uploads

EXPOSE 3000

ENV PORT=3000

WORKDIR /app/bereich-b

ENTRYPOINT ["/docker-entrypoint.sh"]

# server.js is created by next build from the standalone output
CMD ["sh", "-c", "HOSTNAME=0.0.0.0 node server.js"]

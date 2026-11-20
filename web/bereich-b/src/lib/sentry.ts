import generatedGitInfo from '../generatedGitInfo.json'

export const sentryOptions = {
  dsn: process.env.SENTRY_DSN,
  enabled: Boolean(process.env.SENTRY_DSN) && process.env.NODE_ENV !== 'development',
  environment: generatedGitInfo.environment,
  release: generatedGitInfo.release,
  tracesSampleRate: 1.0,
}

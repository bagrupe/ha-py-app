import type { AfterErrorHook, Config, Plugin } from 'payload'

const SENTRY_ADMIN_PROVIDER =
  '@/components/admin/sentry-error-boundary#SentryErrorBoundary' as const

type SentryCaptureContext = {
  extra?: Record<string, unknown>
  user?: {
    collection?: string
    email?: string
    id?: number | string
    ip_address?: string
    username?: string
  }
}

export interface SentryClient {
  captureException: (error: unknown, context?: SentryCaptureContext) => string
}

type SentryPluginOptions = {
  captureErrors?: number[]
  Sentry: SentryClient
}

export const sentryPlugin = ({ captureErrors = [], Sentry }: SentryPluginOptions) => {
  const capturePayloadError: AfterErrorHook = async ({ collection, error, req }) => {
    const status = (error as Error & { status?: number }).status ?? 500
    if (status < 500 && !captureErrors.includes(status)) return

    const user = req.user as {
      collection?: string
      email?: string
      id?: number | string
      username?: string
    } | null

    Sentry.captureException(error, {
      extra: {
        errorCollectionSlug: collection?.slug,
      },
      ...(user && {
        user: {
          id: user.id,
          collection: user.collection,
          email: user.email,
          ip_address: req.headers.get('X-Forwarded-For') ?? undefined,
          username: user.username,
        },
      }),
    })
  }

  const plugin = (config: Config): Config => ({
    ...config,
    admin: {
      ...config.admin,
      components: {
        ...config.admin?.components,
        providers: [...(config.admin?.components?.providers ?? []), SENTRY_ADMIN_PROVIDER],
      },
    },
    hooks: {
      ...config.hooks,
      afterError: [...(config.hooks?.afterError ?? []), capturePayloadError],
    },
  })

  return plugin satisfies Plugin
}

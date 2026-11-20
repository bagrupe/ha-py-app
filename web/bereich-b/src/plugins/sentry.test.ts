import { beforeEach, describe, expect, it, vi } from 'vitest'
import type { AfterErrorHook, Config } from 'payload'
import { sentryPlugin, type SentryClient } from './sentry'

const captureException = vi.fn<SentryClient['captureException']>()

const makeConfig = (overrides: Partial<Config> = {}): Config =>
  ({
    collections: [],
    secret: 'test-secret',
    ...overrides,
  }) as Config

const makeAfterErrorArgs = (
  status: number,
  overrides: Record<string, unknown> = {},
): Parameters<AfterErrorHook>[0] =>
  ({
    collection: { slug: 'news-artikel' },
    context: {},
    error: Object.assign(new Error('Payload failed'), { status }),
    req: {
      headers: new Headers({ 'X-Forwarded-For': '192.0.2.1' }),
      user: {
        id: 'user-1',
        collection: 'benutzer',
        email: 'user@example.test',
        username: 'test-user',
      },
    },
    ...overrides,
  }) as unknown as Parameters<AfterErrorHook>[0]

const getInstalledHook = (config: Config): AfterErrorHook => {
  const result = sentryPlugin({ Sentry: { captureException } })(config)
  const hook = result.hooks?.afterError?.at(-1)
  if (!hook) throw new Error('Expected the Sentry afterError hook to be installed')
  return hook
}

describe('sentryPlugin', () => {
  beforeEach(() => {
    captureException.mockReset()
    captureException.mockReturnValue('event-id')
  })

  it('preserves existing hooks and admin providers', () => {
    const existingHook = vi.fn()
    const config = makeConfig({
      admin: { components: { providers: ['@/components/existing-provider#ExistingProvider'] } },
      hooks: { afterError: [existingHook] },
    })

    const result = sentryPlugin({ Sentry: { captureException } })(config)

    expect(result.hooks?.afterError?.[0]).toBe(existingHook)
    expect(result.admin?.components?.providers).toEqual([
      '@/components/existing-provider#ExistingProvider',
      '@/components/admin/sentry-error-boundary#SentryErrorBoundary',
    ])
  })

  it('captures server errors with Payload request context', async () => {
    const error = Object.assign(new Error('Payload failed'), { status: 500 })
    const hook = getInstalledHook(makeConfig())

    await hook(makeAfterErrorArgs(500, { error }))

    expect(captureException).toHaveBeenCalledWith(error, {
      extra: { errorCollectionSlug: 'news-artikel' },
      user: {
        id: 'user-1',
        collection: 'benutzer',
        email: 'user@example.test',
        ip_address: '192.0.2.1',
        username: 'test-user',
      },
    })
  })

  it('does not capture ordinary client errors', async () => {
    const hook = getInstalledHook(makeConfig())

    await hook(makeAfterErrorArgs(400))

    expect(captureException).not.toHaveBeenCalled()
  })

  it('captures explicitly configured client errors', async () => {
    const config = makeConfig()
    const result = sentryPlugin({ captureErrors: [403], Sentry: { captureException } })(config)
    const hook = result.hooks?.afterError?.at(-1)
    if (!hook) throw new Error('Expected the Sentry afterError hook to be installed')

    await hook(makeAfterErrorArgs(403))

    expect(captureException).toHaveBeenCalledOnce()
  })
})

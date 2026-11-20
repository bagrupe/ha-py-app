import { createElement } from 'react'
import { describe, expect, it, vi } from 'vitest'

const errorBoundary = vi.hoisted(() => vi.fn())

vi.mock('@sentry/nextjs', () => ({
  ErrorBoundary: errorBoundary,
}))

import { SentryErrorBoundary } from './sentry-error-boundary'

describe('SentryErrorBoundary', () => {
  it('delegates admin rendering to the Sentry error boundary', () => {
    const child = createElement('span', null, 'Payload admin')

    const result = SentryErrorBoundary({ children: child })

    expect(result.type).toBe(errorBoundary)
    expect(result.props.children).toBe(child)
  })
})

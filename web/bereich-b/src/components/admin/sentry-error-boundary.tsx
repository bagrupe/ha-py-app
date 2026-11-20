'use client'

import { ErrorBoundary } from '@sentry/nextjs'
import type { ReactNode } from 'react'

export const SentryErrorBoundary = ({ children }: { children: ReactNode }) => (
  <ErrorBoundary>{children}</ErrorBoundary>
)

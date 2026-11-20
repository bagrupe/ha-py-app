'use client'

import { QueryClient, QueryClientProvider as _QueryClientProvider } from '@tanstack/react-query'

const queryClient = new QueryClient()
type QueryClientProviderProps = Parameters<typeof _QueryClientProvider>[0]

export const QueryClientProvider = ({ children }: Pick<QueryClientProviderProps, 'children'>) => (
  <_QueryClientProvider client={queryClient}>{children}</_QueryClientProvider>
)

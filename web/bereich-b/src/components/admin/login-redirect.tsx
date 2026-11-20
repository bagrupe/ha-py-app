'use client'

import { useEffect } from 'react'

// Dummy component that redirects to Bereich A
export const LoginRedirect = () => {
  useEffect(() => {
    const url = new URL('/auth/login', window.location.origin)
    url.search = window.location.search
    url.searchParams.set('force', '')
    window.location.assign(url)
  }, [])
  return null
}

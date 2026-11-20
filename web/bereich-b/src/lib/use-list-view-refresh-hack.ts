'use client'

import { useRouter, usePathname, useSearchParams } from 'next/navigation'

export const useListViewRefreshHack = () => {
  const router = useRouter()
  const pathname = usePathname()
  const searchParams = useSearchParams()

  return () => {
    const params = new URLSearchParams(searchParams.toString())
    params.set('sort', '')
    router.push(`${pathname}?${params}`)
    setTimeout(() => {
      const params2 = new URLSearchParams(searchParams.toString())
      params2.set('sort', '-updatedAt')
      router.push(`${pathname}?${params2}`)
    }, 50)
  }
}

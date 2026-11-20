import { NextResponse, type NextRequest } from 'next/server'

export function proxy(request: NextRequest) {
  const apiKey = request.headers.get('api_key')
  if (apiKey) {
    const requestHeaders = new Headers(request.headers)
    requestHeaders.set('authorization', `benutzer API-Key ${apiKey}`)
    return NextResponse.next({
      request: { headers: requestHeaders },
    })
  }
  return NextResponse.next()
}

export const config = {
  matcher: ['/cms/api/:path*'],
}

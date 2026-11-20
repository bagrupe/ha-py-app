import { beforeEach, describe, expect, it, vi } from 'vitest'

const getPayloadMock = vi.hoisted(() => vi.fn())
const ssoLoginMock = vi.hoisted(() => vi.fn())

vi.mock('@payload-config', () => ({
  default: { test: true },
}))

vi.mock('payload', () => ({
  getPayload: getPayloadMock,
}))

vi.mock('@/sso', () => ({
  ssoLogin: ssoLoginMock,
}))

import { POST } from './route'

const makeRequest = (body: unknown, secret: string | null = 'shared-secret') =>
  new Request('http://localhost/internal/sso/login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      ...(secret ? { 'x-internal-api-secret': secret } : {}),
    },
    body: JSON.stringify(body),
  })

describe('POST /internal/sso/login', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    vi.unstubAllEnvs()
    vi.stubEnv('INTERNAL_API_SECRET', 'shared-secret')
    vi.spyOn(console, 'error').mockImplementation(() => undefined)
    vi.spyOn(console, 'warn').mockImplementation(() => undefined)
  })

  it('returns a plain text token for a valid request body', async () => {
    const payload = { name: 'payload' }
    getPayloadMock.mockResolvedValue(payload)
    ssoLoginMock.mockResolvedValue('signed-token')

    const response = await POST(
      makeRequest({
        email: 'jane@example.com',
        type: 'sso',
        kommuneId: 'bereich-a-kommune-1',
        bereichAUserId: 'bereich-a-user-1',
      }),
    )

    expect(response.status).toBe(200)
    expect(response.headers.get('Content-Type')).toContain('text/plain')
    expect(await response.text()).toBe('signed-token')
    expect(getPayloadMock).toHaveBeenCalledTimes(1)
    expect(ssoLoginMock).toHaveBeenCalledWith(payload, {
      email: 'jane@example.com',
      type: 'sso',
      kommuneId: 'bereich-a-kommune-1',
      bereichAUserId: 'bereich-a-user-1',
    })
  })

  it('returns 400 for malformed JSON', async () => {
    const request = new Request('http://localhost/internal/sso/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-internal-api-secret': 'shared-secret',
      },
      body: '{"email":',
    })

    const response = await POST(request)

    expect(response.status).toBe(400)
    expect(await response.json()).toEqual({ error: 'Invalid JSON body' })
    expect(getPayloadMock).not.toHaveBeenCalled()
    expect(ssoLoginMock).not.toHaveBeenCalled()
  })

  it('returns 400 when the request body shape is invalid', async () => {
    const response = await POST(
      makeRequest({
        email: 'not-an-email',
        bereichAUserId: '',
      }),
    )

    expect(response.status).toBe(400)
    const body = await response.json()
    expect(body.error).toContain('email:')
    expect(body.error).toContain('bereichAUserId:')
    expect(getPayloadMock).not.toHaveBeenCalled()
    expect(ssoLoginMock).not.toHaveBeenCalled()
  })

  it('allows requests without kommuneId', async () => {
    const payload = { name: 'payload' }
    getPayloadMock.mockResolvedValue(payload)
    ssoLoginMock.mockResolvedValue('signed-token')

    const response = await POST(
      makeRequest({
        email: 'jane@example.com',
        bereichAUserId: 'bereich-a-user-1',
      }),
    )

    expect(response.status).toBe(200)
    expect(ssoLoginMock).toHaveBeenCalledWith(payload, {
      email: 'jane@example.com',
      bereichAUserId: 'bereich-a-user-1',
    })
  })

  it('returns 500 when payload bootstrap fails', async () => {
    getPayloadMock.mockRejectedValue(new Error('bootstrap failed'))

    const response = await POST(
      makeRequest({
        email: 'jane@example.com',
        bereichAUserId: 'bereich-a-user-1',
      }),
    )

    expect(response.status).toBe(500)
    expect(await response.json()).toEqual({ error: 'Internal Server Error' })
    expect(ssoLoginMock).not.toHaveBeenCalled()
  })

  it('returns 401 when INTERNAL_API_SECRET is set and the header is missing', async () => {
    const response = await POST(
      makeRequest(
        {
          email: 'jane@example.com',
          bereichAUserId: 'bereich-a-user-1',
        },
        null,
      ),
    )

    expect(response.status).toBe(401)
    expect(getPayloadMock).not.toHaveBeenCalled()
    expect(ssoLoginMock).not.toHaveBeenCalled()
  })

  it('returns 401 when INTERNAL_API_SECRET is missing', async () => {
    vi.stubEnv('INTERNAL_API_SECRET', '')

    const response = await POST(
      makeRequest({
        email: 'jane@example.com',
        bereichAUserId: 'bereich-a-user-1',
      }),
    )

    expect(response.status).toBe(401)
    expect(getPayloadMock).not.toHaveBeenCalled()
    expect(ssoLoginMock).not.toHaveBeenCalled()
    expect(console.error).toHaveBeenCalledWith(
      'INTERNAL_API_SECRET is not set — refusing /internal/sso/login request.',
    )
  })

  it('returns 401 when the provided secret does not match', async () => {
    vi.stubEnv('INTERNAL_API_SECRET', 'shared-secret')

    const request = new Request('http://localhost/internal/sso/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-internal-api-secret': 'wrong-secret',
      },
      body: JSON.stringify({ email: 'jane@example.com', bereichAUserId: 'bereich-a-user-1' }),
    })

    const response = await POST(request)

    expect(response.status).toBe(401)
    expect(ssoLoginMock).not.toHaveBeenCalled()
  })

  it('accepts the request when the provided secret matches', async () => {
    vi.stubEnv('INTERNAL_API_SECRET', 'shared-secret')
    const payload = { name: 'payload' }
    getPayloadMock.mockResolvedValue(payload)
    ssoLoginMock.mockResolvedValue('signed-token')

    const request = new Request('http://localhost/internal/sso/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-internal-api-secret': 'shared-secret',
      },
      body: JSON.stringify({ email: 'jane@example.com', bereichAUserId: 'bereich-a-user-1' }),
    })

    const response = await POST(request)

    expect(response.status).toBe(200)
    expect(await response.text()).toBe('signed-token')
  })

  it('returns 500 when ssoLogin fails', async () => {
    const payload = { name: 'payload' }
    getPayloadMock.mockResolvedValue(payload)
    ssoLoginMock.mockRejectedValue(new Error('sso failed'))

    const response = await POST(
      makeRequest({
        email: 'jane@example.com',
        bereichAUserId: 'bereich-a-user-1',
      }),
    )

    expect(response.status).toBe(500)
    expect(await response.json()).toEqual({ error: 'Internal Server Error' })
  })
})

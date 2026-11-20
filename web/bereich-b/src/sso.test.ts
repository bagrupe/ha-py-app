import { beforeEach, describe, expect, it, vi } from 'vitest'
import type { Payload } from 'payload'

const randomBytesMock = vi.hoisted(() => vi.fn())
const jwtSignMock = vi.hoisted(() => vi.fn(async () => ({ exp: 0, token: 'signed-token' })))
const getFieldsToSignMock = vi.hoisted(() => vi.fn())

vi.mock('node:crypto', () => ({
  randomBytes: randomBytesMock,
}))

vi.mock('payload', () => ({
  getFieldsToSign: getFieldsToSignMock,
  jwtSign: jwtSignMock,
}))

import { ssoLogin } from './sso'

type MockPayload = Payload & {
  find: ReturnType<typeof vi.fn>
  create: ReturnType<typeof vi.fn>
  update: ReturnType<typeof vi.fn>
}

const makePayload = (): MockPayload =>
  ({
    secret: 'test-secret',
    collections: {
      benutzer: {
        config: {
          auth: {
            tokenExpiration: 7200,
          },
        },
      },
    },
    find: vi.fn(),
    create: vi.fn(),
    update: vi.fn(),
  }) as unknown as MockPayload

const makeInput = (overrides: Partial<Parameters<typeof ssoLogin>[1]> = {}) => ({
  email: 'jane@example.com',
  type: 'sso',
  kommuneId: 'bereich-a-kommune-1',
  bereichAUserId: 'bereich-a-user-1',
  ...overrides,
})

describe('ssoLogin', () => {
  beforeEach(() => {
    vi.clearAllMocks()

    randomBytesMock.mockImplementation(
      (size: number, callback: (error: Error | null, buffer: Buffer) => void) => {
        callback(null, Buffer.alloc(size, 1))
      },
    )

    getFieldsToSignMock.mockImplementation(({ user, email }) => ({
      sub: user.id,
      email,
      bereichAId: user.bereichAId,
      kommune: user.kommune,
    }))
  })

  it('rejects invalid email input before touching Payload', async () => {
    const payload = makePayload()

    await expect(ssoLogin(payload, makeInput({ email: '   ' }))).rejects.toThrow(
      'email must be a non-empty string',
    )

    expect(payload.find).not.toHaveBeenCalled()
    expect(payload.create).not.toHaveBeenCalled()
    expect(payload.update).not.toHaveBeenCalled()
  })

  it('rejects invalid Bereich A user ids before touching Payload', async () => {
    const payload = makePayload()

    await expect(ssoLogin(payload, makeInput({ bereichAUserId: '' }))).rejects.toThrow(
      'bereichAUserId must be a non-empty string',
    )

    expect(payload.find).not.toHaveBeenCalled()
    expect(payload.create).not.toHaveBeenCalled()
    expect(payload.update).not.toHaveBeenCalled()
  })

  it('creates a new user with a resolved kommune and signs the created user state', async () => {
    const payload = makePayload()

    payload.find
      .mockResolvedValueOnce({ docs: [{ id: 'kommune-1' }] })
      .mockResolvedValueOnce({ docs: [] })
    payload.create.mockResolvedValue({
      id: 'user-1',
      email: 'jane@example.com',
      bereichAId: 'bereich-a-user-1',
      kommune: 'kommune-1',
    })

    const token = await ssoLogin(payload, makeInput())

    expect(token).toBe('signed-token')
    expect(payload.find).toHaveBeenNthCalledWith(
      1,
      expect.objectContaining({
        collection: 'kommunen',
        depth: 0,
        limit: 1,
        where: { bereichAId: { equals: 'bereich-a-kommune-1' } },
      }),
    )
    expect(payload.find).toHaveBeenNthCalledWith(
      2,
      expect.objectContaining({
        collection: 'benutzer',
        depth: 0,
        limit: 1,
        where: { email: { equals: 'jane@example.com' } },
      }),
    )
    expect(randomBytesMock).toHaveBeenCalledWith(128, expect.any(Function))
    expect(payload.create).toHaveBeenCalledWith({
      collection: 'benutzer',
      depth: 0,
      data: {
        email: 'jane@example.com',
        kommune: 'kommune-1',
        password: '01'.repeat(128),
        lockUntil: undefined,
        bereichAId: 'bereich-a-user-1',
      },
    })
    expect(payload.update).not.toHaveBeenCalled()
    expect(getFieldsToSignMock).toHaveBeenCalledWith({
      collectionConfig: payload.collections.benutzer.config,
      email: 'jane@example.com',
      user: expect.objectContaining({
        id: 'user-1',
        collection: 'benutzer',
        bereichAId: 'bereich-a-user-1',
        kommune: 'kommune-1',
      }),
    })
    expect(jwtSignMock).toHaveBeenCalledWith({
      fieldsToSign: {
        sub: 'user-1',
        email: 'jane@example.com',
        bereichAId: 'bereich-a-user-1',
        kommune: 'kommune-1',
      },
      secret: 'test-secret',
      tokenExpiration: 7200,
    })
  })

  it('creates a new user without a kommune when the incoming mapping cannot be resolved', async () => {
    const payload = makePayload()

    payload.find.mockResolvedValueOnce({ docs: [] }).mockResolvedValueOnce({ docs: [] })
    payload.create.mockResolvedValue({
      id: 'user-2',
      email: 'jane@example.com',
      bereichAId: 'bereich-a-user-1',
    })

    await ssoLogin(payload, makeInput())

    expect(payload.create).toHaveBeenCalledWith({
      collection: 'benutzer',
      depth: 0,
      data: {
        email: 'jane@example.com',
        password: '01'.repeat(128),
        lockUntil: undefined,
        bereichAId: 'bereich-a-user-1',
      },
    })
  })

  it('updates an existing user and signs the persisted user state instead of stale in-memory data', async () => {
    const payload = makePayload()

    payload.find.mockResolvedValueOnce({ docs: [{ id: 'kommune-1' }] }).mockResolvedValueOnce({
      docs: [
        {
          id: 'user-1',
          email: 'jane@example.com',
          bereichAId: 'old-bereich-a-user-id',
          kommune: 'old-kommune',
        },
      ],
    })
    payload.update.mockResolvedValue({
      id: 'user-1',
      email: 'jane@example.com',
      bereichAId: 'bereich-a-user-1',
      kommune: 'kommune-1',
    })

    await ssoLogin(payload, makeInput())

    expect(payload.update).toHaveBeenCalledWith({
      collection: 'benutzer',
      id: 'user-1',
      depth: 0,
      data: {
        bereichAId: 'bereich-a-user-1',
        kommune: 'kommune-1',
      },
    })
    expect(payload.create).not.toHaveBeenCalled()
    expect(getFieldsToSignMock).toHaveBeenCalledWith(
      expect.objectContaining({
        user: expect.objectContaining({
          bereichAId: 'bereich-a-user-1',
          kommune: 'kommune-1',
        }),
      }),
    )
  })

  it('skips the kommune lookup when no incoming kommune id is provided', async () => {
    const payload = makePayload()

    payload.find.mockResolvedValueOnce({
      docs: [
        {
          id: 'user-1',
          email: 'jane@example.com',
          bereichAId: 'old-bereich-a-user-id',
          kommune: 'kommune-existing',
        },
      ],
    })
    payload.update.mockResolvedValue({
      id: 'user-1',
      email: 'jane@example.com',
      bereichAId: 'bereich-a-user-1',
      kommune: 'kommune-existing',
    })

    await ssoLogin(payload, makeInput({ kommuneId: '' }))

    expect(payload.find).toHaveBeenCalledTimes(1)
    expect(payload.find).toHaveBeenCalledWith(
      expect.objectContaining({
        collection: 'benutzer',
        where: { email: { equals: 'jane@example.com' } },
      }),
    )
  })

  it('preserves the existing kommune when no new kommune mapping is provided', async () => {
    const payload = makePayload()

    payload.find.mockResolvedValueOnce({
      docs: [
        {
          id: 'user-1',
          email: 'jane@example.com',
          bereichAId: 'old-bereich-a-user-id',
          kommune: 'kommune-existing',
        },
      ],
    })
    payload.update.mockResolvedValue({
      id: 'user-1',
      email: 'jane@example.com',
      bereichAId: 'bereich-a-user-1',
      kommune: 'kommune-existing',
    })

    await ssoLogin(payload, makeInput({ kommuneId: '' }))

    expect(payload.update).toHaveBeenCalledWith({
      collection: 'benutzer',
      id: 'user-1',
      depth: 0,
      data: {
        bereichAId: 'bereich-a-user-1',
        kommune: 'kommune-existing',
      },
    })
  })

  it('normalizes populated kommune relationship objects before update and before signing', async () => {
    const payload = makePayload()

    payload.find.mockResolvedValueOnce({
      docs: [
        {
          id: 'user-1',
          email: 'jane@example.com',
          bereichAId: 'old-bereich-a-user-id',
          kommune: { id: 'kommune-existing' },
        },
      ],
    })
    payload.update.mockResolvedValue({
      id: 'user-1',
      email: 'jane@example.com',
      bereichAId: 'bereich-a-user-1',
      kommune: { id: 'kommune-existing' },
    })

    await ssoLogin(payload, makeInput({ kommuneId: '' }))

    expect(payload.update).toHaveBeenCalledWith({
      collection: 'benutzer',
      id: 'user-1',
      depth: 0,
      data: {
        bereichAId: 'bereich-a-user-1',
        kommune: 'kommune-existing',
      },
    })
    expect(getFieldsToSignMock).toHaveBeenCalledWith(
      expect.objectContaining({
        user: expect.objectContaining({
          kommune: 'kommune-existing',
        }),
      }),
    )
  })

  it('does not write an undefined kommune when neither an existing nor mapped kommune is available', async () => {
    const payload = makePayload()

    payload.find.mockResolvedValueOnce({
      docs: [
        {
          id: 'user-1',
          email: 'jane@example.com',
          bereichAId: 'old-bereich-a-user-id',
          kommune: null,
        },
      ],
    })
    payload.update.mockResolvedValue({
      id: 'user-1',
      email: 'jane@example.com',
      bereichAId: 'bereich-a-user-1',
      kommune: null,
    })

    await ssoLogin(payload, makeInput({ kommuneId: '' }))

    expect(payload.update).toHaveBeenCalledWith({
      collection: 'benutzer',
      id: 'user-1',
      depth: 0,
      data: {
        bereichAId: 'bereich-a-user-1',
      },
    })
  })

  it('propagates create failures', async () => {
    const payload = makePayload()

    payload.find
      .mockResolvedValueOnce({ docs: [{ id: 'kommune-1' }] })
      .mockResolvedValueOnce({ docs: [] })
    payload.create.mockRejectedValue(new Error('create failed'))

    await expect(ssoLogin(payload, makeInput())).rejects.toThrow('create failed')
  })

  it('propagates update failures', async () => {
    const payload = makePayload()

    payload.find.mockResolvedValueOnce({ docs: [{ id: 'kommune-1' }] }).mockResolvedValueOnce({
      docs: [{ id: 'user-1', email: 'jane@example.com', bereichAId: 'old-id' }],
    })
    payload.update.mockRejectedValue(new Error('update failed'))

    await expect(ssoLogin(payload, makeInput())).rejects.toThrow('update failed')
  })
})

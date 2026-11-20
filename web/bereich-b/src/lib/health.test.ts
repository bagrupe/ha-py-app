import type { Connection } from 'mongoose'
import type { MongooseAdapter } from '@payloadcms/db-mongodb'
import type { Payload } from 'payload'
import { describe, expect, it, vi } from 'vitest'

import { pingMongo } from './health'

function createPayload(connection: Partial<Connection> | undefined, connect = vi.fn()): Payload {
  return {
    db: {
      connection,
      connect,
    } as unknown as MongooseAdapter,
  } as unknown as Payload
}

describe('pingMongo', () => {
  it('returns Healthy when the app database responds to ping', async () => {
    const command = vi.fn().mockResolvedValue({ ok: 1 })
    const payload = createPayload({
      readyState: 1,
      db: { command },
    } as unknown as Connection)

    await expect(pingMongo(payload)).resolves.toBe('Healthy')
    expect(command).toHaveBeenCalledWith({ ping: 1 })
  })

  it('falls back to the native client when connection.db is not set yet', async () => {
    const command = vi.fn().mockResolvedValue({ ok: 1 })
    const payload = createPayload({
      readyState: 1,
      name: 'bereich-b',
      getClient: () => ({
        db: () => ({ command }),
      }),
    } as unknown as Connection)

    await expect(pingMongo(payload)).resolves.toBe('Healthy')
    expect(command).toHaveBeenCalledWith({ ping: 1 })
  })

  it('reconnects when the mongoose connection is not ready', async () => {
    const command = vi.fn().mockResolvedValue({ ok: 1 })
    const connect = vi.fn().mockImplementation(async function connect(this: MongooseAdapter) {
      this.connection = {
        readyState: 1,
        db: { command },
      } as unknown as Connection
    })
    const payload = createPayload(undefined, connect)

    await expect(pingMongo(payload)).resolves.toBe('Healthy')
    expect(connect).toHaveBeenCalledOnce()
  })

  it('returns Unhealthy when ping fails', async () => {
    const payload = createPayload({
      readyState: 1,
      db: {
        command: vi.fn().mockRejectedValue(new Error('not authorized')),
      },
    } as unknown as Connection)

    await expect(pingMongo(payload)).resolves.toBe('Unhealthy')
  })
})

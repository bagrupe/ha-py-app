import type { Connection } from 'mongoose'
import type { MongooseAdapter } from '@payloadcms/db-mongodb'
import type { Payload } from 'payload'

export type HealthStatus = 'Healthy' | 'Unhealthy'

export type HealthResponse = {
  status: HealthStatus
  checks: Record<string, HealthStatus>
}

export function buildHealthResponse(checks: Record<string, HealthStatus>): Response {
  const status: HealthStatus = Object.values(checks).every((value) => value === 'Healthy')
    ? 'Healthy'
    : 'Unhealthy'

  return Response.json({ status, checks } satisfies HealthResponse, {
    status: status === 'Healthy' ? 200 : 503,
  })
}

function getMongoDb(connection: Connection) {
  return connection.db ?? connection.getClient().db(connection.name)
}

export async function pingMongo(payload: Payload): Promise<HealthStatus> {
  try {
    const adapter = payload.db as MongooseAdapter
    let connection = adapter.connection

    if (!connection || connection.readyState !== 1) {
      if (typeof adapter.connect === 'function') {
        await adapter.connect()
        connection = adapter.connection
      }
    }

    if (!connection || connection.readyState !== 1) {
      return 'Unhealthy'
    }

    await getMongoDb(connection).command({ ping: 1 })
    return 'Healthy'
  } catch {
    return 'Unhealthy'
  }
}

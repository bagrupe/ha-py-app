import { describe, expect, it, vi } from 'vitest'
import { loadSensorArten } from './sensor-art-loader'

const response = (docs: unknown[], ok = true, status = 200) => ({
  ok,
  status,
  json: vi.fn().mockResolvedValue({ docs }),
})

describe('loadSensorArten', () => {
  it('shares one request among concurrent callers and evicts it after success', async () => {
    let resolveResponse!: (value: ReturnType<typeof response>) => void
    const fetchSensorArten = vi.fn(
      () =>
        new Promise<ReturnType<typeof response>>((resolve) => {
          resolveResponse = resolve
        }),
    )

    const first = loadSensorArten('/cms/api', fetchSensorArten)
    const second = loadSensorArten('/cms/api', fetchSensorArten)

    expect(first).toBe(second)
    expect(fetchSensorArten).toHaveBeenCalledTimes(1)

    resolveResponse(response([{ id: 'temperature' }]))
    await expect(first).resolves.toEqual([{ id: 'temperature' }])

    fetchSensorArten.mockResolvedValue(response([{ id: 'temperature' }]))
    await loadSensorArten('/cms/api', fetchSensorArten)
    expect(fetchSensorArten).toHaveBeenCalledTimes(2)
  })

  it('evicts failed requests so later callers can retry', async () => {
    const fetchSensorArten = vi
      .fn()
      .mockResolvedValueOnce(response([], false, 500))
      .mockResolvedValueOnce(response([{ id: 'pressure' }]))

    await expect(loadSensorArten('/retry/api', fetchSensorArten)).rejects.toThrow(
      'Failed to load sensor types (500)',
    )
    await expect(loadSensorArten('/retry/api', fetchSensorArten)).resolves.toEqual([
      { id: 'pressure' },
    ])
    expect(fetchSensorArten).toHaveBeenCalledTimes(2)
  })
})

import { APIError, ValidationError } from 'payload'
import { beforeEach, describe, expect, it, vi } from 'vitest'

const mocks = vi.hoisted(() => ({ upsert: vi.fn() }))

vi.mock('../../dataseeder/upsert', () => ({ upsert: mocks.upsert }))

import { CronJobItemFailures } from '../cron-job-item-failures'
import { createVeranstaltungUpserter } from '../import-veranstaltungen/utils/veranstaltung-upserter'

const detail = 'link node failed to validate: The following fields are invalid: url'

const validationResults = {
  collection: 'veranstaltungskalender',
  errors: [{ message: detail, path: 'inhalte.0.content' }],
} as never

const validationError = () => new ValidationError(validationResults)

const minifiedValidationError = () => {
  class k extends ValidationError {}
  return new k(validationResults)
}

const args = (id: string) =>
  ({ collection: 'veranstaltungskalender', key: 'id', data: { id } }) as never

describe('createVeranstaltungUpserter', () => {
  let failures: CronJobItemFailures
  let errorLog: ReturnType<typeof vi.spyOn>

  beforeEach(() => {
    mocks.upsert.mockReset()
    failures = new CronJobItemFailures()
    errorLog = vi.spyOn(console, 'error').mockImplementation(() => {})
    errorLog.mockClear()
  })

  it('passes the arguments through and records no failure on success', async () => {
    mocks.upsert.mockResolvedValue({})

    await createVeranstaltungUpserter(failures)(args('1'))

    expect(mocks.upsert).toHaveBeenCalledWith(args('1'))
    expect(failures.getCount()).toBe(0)
    expect(errorLog).not.toHaveBeenCalled()
  })

  it('records a failure instead of throwing when Payload rejects an event', async () => {
    mocks.upsert.mockRejectedValue(validationError())

    await expect(createVeranstaltungUpserter(failures)(args('1'))).resolves.toBeUndefined()

    expect(failures.getCount()).toBe(1)
  })

  it('logs the event id, the failing field and the validation detail', async () => {
    mocks.upsert.mockRejectedValue(validationError())

    await createVeranstaltungUpserter(failures)(args('100837713'))

    expect(errorLog).toHaveBeenCalledWith(expect.stringContaining('100837713'))
    expect(errorLog).toHaveBeenCalledWith(expect.stringContaining(`inhalte.0.content: ${detail}`))
  })

  it('falls back to the error message when the validation errors carry no path or message', async () => {
    mocks.upsert.mockRejectedValue(
      new ValidationError({
        collection: 'veranstaltungskalender',
        errors: [{ label: 'Inhalte' }],
      } as never),
    )

    await createVeranstaltungUpserter(failures)(args('1'))

    expect(failures.getCount()).toBe(1)
    expect(errorLog).toHaveBeenCalledWith(
      expect.stringContaining('The following field is invalid: Inhalte'),
    )
  })

  it('does not fail itself when the error list contains unexpected entries', async () => {
    mocks.upsert.mockRejectedValue(new APIError('bad request', 400, { errors: [null, 'x', 5] }))

    await expect(createVeranstaltungUpserter(failures)(args('1'))).resolves.toBeUndefined()

    expect(failures.getCount()).toBe(1)
    expect(errorLog).toHaveBeenCalledWith(expect.stringContaining('bad request'))
  })

  it('still recognises the error when a production build renamed its class', async () => {
    const error = minifiedValidationError()
    expect(error.name).toBe('k')
    mocks.upsert.mockRejectedValue(error)

    await expect(createVeranstaltungUpserter(failures)(args('1'))).resolves.toBeUndefined()

    expect(failures.getCount()).toBe(1)
  })

  it.each([
    ['a plain error', () => new Error('connection lost')],
    ['a database error', () => Object.assign(new Error('E11000 duplicate key'), { code: 11000 })],
    ['an internal server error', () => new APIError('boom', 500)],
    ['a bad request without validation details', () => new APIError('bad request', 400)],
    ['a thrown string', () => 'connection lost'],
    ['a thrown null', () => null],
  ])('rethrows %s and records nothing', async (_name, make) => {
    const thrown = make()
    mocks.upsert.mockRejectedValue(thrown)

    await expect(createVeranstaltungUpserter(failures)(args('1'))).rejects.toBe(thrown)

    expect(failures.getCount()).toBe(0)
    expect(errorLog).not.toHaveBeenCalled()
  })

  it('keeps going with the remaining events after one fails', async () => {
    mocks.upsert
      .mockResolvedValueOnce({})
      .mockRejectedValueOnce(validationError())
      .mockResolvedValueOnce({})
    const upsertVeranstaltung = createVeranstaltungUpserter(failures)

    for (const id of ['1', '2', '3']) await upsertVeranstaltung(args(id))

    expect(mocks.upsert).toHaveBeenCalledTimes(3)
    expect(failures.getCount()).toBe(1)
  })
})

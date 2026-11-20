import type { ZodError } from 'zod'

export const formatZodErrors = ({ issues }: ZodError): string =>
  issues
    .map(({ path, message }) => {
      const pathString = path.join('.')
      return `${pathString}: ${message}`
    })
    .join('\n')

export const getId = (docOrId: { id: string } | string | null | undefined) =>
  typeof docOrId === 'string' ? docOrId : docOrId?.id

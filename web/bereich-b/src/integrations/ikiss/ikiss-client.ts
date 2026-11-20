import {
  type IKissAction,
  type IKissApiReturnMode,
  type IKissFetchSettings,
  type IKissModules,
  type IkissRequest,
  type IKissSearchSettings,
  type IKissUser,
} from './ikiss-request-types'

export const createIKissRequest = (
  ikissAction: IKissAction,
  ikissModule: IKissModules,
  ikissApiReturnMode: IKissApiReturnMode,
  ikissUser: IKissUser,
  specificQuery: IKissSearchSettings | IKissFetchSettings,
): IkissRequest => ({
  ikiss: {
    request: {
      action: ikissAction,
      set_api_return_mode: ikissApiReturnMode,
      set_module: ikissModule,
      user: ikissUser,
      ...specificQuery,
    },
  },
})

export const fetchIKissResponse = async (url: string, query: string) => {
  const fetchURL = new URL('/api.phtml', url)
  const response = await fetch(fetchURL, {
    method: 'POST',
    headers: { 'user-agent': 'node' },
    body: query,
  })
  return response
}

// Node.js response.text() ignores the charset from Content-Type and always
// decodes as UTF-8. The iKISS API declares text/xml;charset=iso-8859-15, so
// raw umlaut bytes (e.g. 0xFC for ü) get corrupted to U+FFFD. This helper
// reads the declared charset from Content-Type and decodes accordingly.
export async function decodeIkissResponse(response: Response): Promise<string> {
  const contentType = response.headers.get('content-type') ?? ''
  const charsetMatch = contentType.match(/charset=([^\s;,]+)/i)
  const charset = charsetMatch?.[1] ?? 'utf-8'
  const buffer = await response.arrayBuffer()
  return new TextDecoder(charset).decode(buffer)
}

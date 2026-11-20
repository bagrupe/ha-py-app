import { XMLParser } from 'fast-xml-parser'

const parser = new XMLParser({
  ignoreAttributes: false,
  allowBooleanAttributes: true,
  attributeNamePrefix: '', // Removing the default prefix for prettier keys
})

export const fetchRSSResponse = async (url: string) => {
  const fetchURL = new URL(url)

  const response = await fetch(fetchURL, {
    method: 'GET',
    headers: { 'user-agent': 'node' },
  })

  const data = await response.text()
  return parser.parse(data)
}

import { type EventEntity, type EventsResponse } from './ikiss-response-types'
import { ikissXmlParser, isReleased, stripCdata } from './ikiss-xml'

export type IkissArea = 'internet' | 'user' | 'intranet'

export type IkissEvent = {
  id: string
  title: string
  datetimeFrom?: string
  datetimeTo?: string
  released: boolean
  area?: IkissArea
  shortContent?: string
  content?: string
  location?: string
  contact?: string
  priceInfo?: string
  image?: string
  updateDate?: string
}

export const IKISS_NO_DATA_FOUND = 4043

export class IkissApiError extends Error {
  constructor(
    readonly errorNumber: number,
    message?: string,
  ) {
    super(`iKISS API error ${errorNumber}${message ? `: ${message}` : ''}`)
  }
}

const AREA_BY_WIRE_VALUE: Record<string, IkissArea> = {
  '1': 'intranet',
  '2': 'user',
  '3': 'internet',
  intranet: 'intranet',
  user: 'user',
  internet: 'internet',
}

const text = (value: unknown): string | undefined => {
  if (value === undefined || value === null) return undefined
  const trimmed = String(value).trim()
  return trimmed === '' ? undefined : trimmed
}

const parseRelease = (release: unknown): boolean => isReleased(release) || release === 1

const toIkissEvent = (entity: EventEntity): IkissEvent => ({
  id: String(entity.object_full_id ?? entity.object_id),
  title: text(entity.title) ?? '',
  datetimeFrom: text(entity.datetime_from),
  datetimeTo: text(entity.datetime_to),
  released: parseRelease(entity.release),
  area: AREA_BY_WIRE_VALUE[String(entity.area)],
  shortContent: text(entity.data_short_content),
  content: entity.data_content === undefined ? undefined : text(stripCdata(entity.data_content)),
  location: text(entity.location),
  contact: text(entity.contact),
  priceInfo: text(entity.priceinfo),
  image: text(entity.image),
  updateDate: text(entity.update_date),
})

const asArray = <T>(value: T | T[] | '' | undefined): T[] => {
  if (value === undefined || value === '') return []
  return Array.isArray(value) ? value : [value]
}

// iKISS sends unescaped `&` in text, so strict XML validation would reject real responses.
// A missing closing root tag is the reliable sign of a truncated body, which would otherwise
// parse as an empty list and delete every stored event.
const COMPLETE_DOCUMENT = /<\/ikiss>\s*$/

export const parseIkissEventsResponse = (xml: string): IkissEvent[] => {
  if (!COMPLETE_DOCUMENT.test(xml)) {
    throw new Error('iKISS events response is incomplete')
  }
  const { result } = (ikissXmlParser.parse(xml) as EventsResponse).ikiss ?? {}

  if (result?.terror) {
    const { error_num, error_msg } = result.terror
    throw new IkissApiError(Number(error_num), error_msg)
  }
  if (result?.tevents) return [toIkissEvent(result.tevents)]
  if (result?.tevents_list === undefined) {
    throw new Error('iKISS events response has no tevents_list')
  }
  const entries = result.tevents_list === '' ? [] : asArray(result.tevents_list.tevents)
  return entries.map(toIkissEvent)
}

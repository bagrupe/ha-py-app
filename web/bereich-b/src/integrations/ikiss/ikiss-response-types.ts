export type RichText = {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  [k: string]: any
}[]

export interface ContentResponse {
  '?xml': string
  ikiss: Ikiss
}
export interface Ikiss {
  result: Result
}
export interface Result {
  tcontent_list?: TcontentList
  tcontent?: Tcontent
  tmedia?: Tmedia
}

export interface Tmedia {
  tdata_list: TdataList
}
export interface TdataList {
  tdata: Tdata[]
}
export interface Tdata {
  media_path: string
  width: string
  height: string
}
export interface TcontentList {
  tcontent?: TcontentEntity[] | null
}
export interface TcontentEntity {
  object_id: string
  title: string
  data_content: string
  date: string
}

export interface Tcontent {
  data_content: string
  description?: null[] | null
  date: string
  release: boolean
  tLayout: TLayout
  tTpFields: TTpFields
}
export interface TLayout {
  rand_bilder?: string
  trand_bilder_list?: RandBilder
}

export interface RandBilder {
  rand_bilder: string[]
}
export interface TTpFields {
  title: string
  data_content: string
}

export interface ImageBlockJson {
  type: string
  url: string
  children?: {
    text: string
  }[]
}

export interface EventsResponse {
  ikiss: {
    result: {
      terror?: { error_num: string | number; error_msg?: string }
      tevents_list?: { tevents?: EventEntity | EventEntity[] | '' } | ''
      tevents?: EventEntity
    }
  }
}

export interface EventEntity {
  object_id: string | number
  object_full_id?: string
  title?: string | number
  datetime_from?: string
  datetime_to?: string
  data_short_content?: string | number
  data_content?: string
  location?: string | number
  contact?: string | number
  priceinfo?: string | number
  release?: string | number | boolean
  area?: string | number
  image?: string | number
  update_date?: string
}

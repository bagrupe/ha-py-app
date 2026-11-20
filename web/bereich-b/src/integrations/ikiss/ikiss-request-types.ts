export type IkissRequest = {
  ikiss: {
    request: {
      user: IKissUser
      set_module: IKissModules
      action: IKissAction
      set_api_return_mode: IKissApiReturnMode
    }
  }
}

export type IKissUser = {
  name: string
  password: string
}

export type IKissModules = 'content' | 'media' | 'categories' | 'events'
export type IKissLanguages = 'de' | 'en'
export type IKissAction = 'fetch' | 'search'
export type IKissApiReturnMode = 'full' | 'short'

export type IKissSearchSettings = {
  set_language: IKissLanguages
  set_include_sub_categories: number
  set_search_params: {
    categorie?: string
    area?: string
  }
  search_result_format: string
}

export type IKissFetchSettings = {
  set_language: IKissLanguages
  set_include_sub_categories: number
  set_data: {
    id: string
  }
  set_fetch_mask: number
}

export type MediaSettings = {
  set_language: string
  set_api_return_mode: string
  set_include_sub_categories: number
  action: string
  set_data: {
    id: string
  }
  set_fetch_mask: number
}

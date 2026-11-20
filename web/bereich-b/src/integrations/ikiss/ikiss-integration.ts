import { type Integration } from '../../payload-types'

export type IkissIntegration = {
  url: string
  benutzername: string
  passwort: string
} & Omit<Integration, 'zugangsdaten'>

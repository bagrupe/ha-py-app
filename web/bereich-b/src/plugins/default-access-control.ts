import {
  type Access,
  type CollectionConfig,
  type Config,
  type Field,
  type GlobalConfig,
} from 'payload'
import { type Benutzer } from '../payload-types'
import { ACCESS_SKIP_FOLLOWING_RULES, accessRules, composeAccessRules } from '../access'
import { hasKommuneField } from '../fields/kommune'
import { hasUntereinheitField } from '../fields/untereinheit-field'
import {
  hasAnyFunktionsberechtigung,
  Funktionsberechtigung,
  funktionsberechtigungenOf,
} from '../lib/funktionsberechtigungen'
import { isSuperAdmin } from '../utils/is-super-admin'
import { deriveUploadFunktionsberechtigungen } from './upload-funktionsberechtigungen'

export const wrapAccess = (
  operation: keyof Exclude<CollectionConfig['access'], undefined>,
  config: CollectionConfig | GlobalConfig,
): Access => {
  const configAccess = (config.access as CollectionConfig['access']) ?? {}
  const rules: Access[] = []

  if (config.slug === 'kommunen') {
    rules.push(accessRules.kommune(true))
  } else if (hasKommuneField(config)) {
    rules.push(accessRules.kommune(false))
  }

  rules.push(({ req: { user } }) => (isSuperAdmin(user) ? ACCESS_SKIP_FOLLOWING_RULES : true))

  if (config.slug === 'untereinheit') {
    rules.push(accessRules.organisationseinheit(true))
  } else if (hasUntereinheitField(config)) {
    rules.push(accessRules.organisationseinheit(false, funktionsberechtigungenOf(config.custom)))
  }

  return (args) => {
    const user = args.req.user as Benutzer | undefined

    if (!user && operation !== 'read') {
      return false
    }

    const customRule = configAccess[operation]

    return composeAccessRules([...rules, customRule ?? accessRules.authenticated])(args)
  }
}

export const wrapHidden = (config: CollectionConfig | GlobalConfig) => {
  const customHidden = config.admin?.hidden
  if (customHidden) return customHidden
  const funktionsberechtigungen = funktionsberechtigungenOf(config.custom) ?? [
    Funktionsberechtigung.Inhaltspflege,
  ]
  return ({ user }: { user: unknown }) => {
    if (!user) return true
    const { isSuperAdmin = false, organisationseinheiten } = user as Benutzer
    const berechtigt =
      isSuperAdmin ||
      (organisationseinheiten ?? []).some((oe) =>
        hasAnyFunktionsberechtigung(oe.funktionsberechtigungen, funktionsberechtigungen),
      )
    return !berechtigt
  }
}

export const wrapField = (field: Field, config: CollectionConfig) => {
  if (field.custom && Array.isArray(field.custom.funktionsberechtigungen)) {
    field.custom.funktionsberechtigungen = funktionsberechtigungenOf(config.custom) ?? [
      Funktionsberechtigung.Inhaltspflege,
    ]
  }
  return field
}

export const defaultAccessControl = (config: Config): Config => ({
  ...config,
  collections: deriveUploadFunktionsberechtigungen(config.collections ?? []).map(
    ({ ...collectionConfig }) =>
      ({
        ...collectionConfig,
        admin: {
          ...collectionConfig.admin,
          hidden: wrapHidden(collectionConfig),
        },
        access: {
          ...collectionConfig.access,
          read: wrapAccess('read', collectionConfig),
          create: wrapAccess('create', collectionConfig),
          delete: wrapAccess('delete', collectionConfig),
          update: wrapAccess('update', collectionConfig),
        },
        fields: collectionConfig.fields.map((field) => wrapField(field, collectionConfig)),
      }) as CollectionConfig,
  ),
  globals: config.globals?.map(
    ({ access = {}, ...globalConfig }) =>
      ({
        ...globalConfig,
        access: {
          ...access,
          read: wrapAccess('read', globalConfig),
          update: wrapAccess('update', globalConfig),
        },
      }) satisfies GlobalConfig,
  ),
})

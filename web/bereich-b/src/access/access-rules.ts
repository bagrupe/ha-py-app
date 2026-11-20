import { type Access, type Where } from 'payload'
import { type Benutzer, type Kommune, type Untereinheit } from '../payload-types'
import {
  hasAnyFunktionsberechtigung,
  type Funktionsberechtigung,
} from '../lib/funktionsberechtigungen'
import { getId } from '../utils/get-id'
import { isSuperAdmin } from '../utils/is-super-admin'

const authenticated: Access = ({ req: { user } }) => user != null

type AccessArgs = Parameters<Access>[0]

const publicRead =
  (anonymousWhere: Where | ((args: AccessArgs) => Where)): Access =>
  (args) => {
    if (args.req.user) return true
    return typeof anonymousWhere === 'function' ? anonymousWhere(args) : anonymousWhere
  }

// Der Default-Access-Control-Plugin umschließt nur read/create/update/delete, nicht `readVersions`.
// Kommune- und Funktionsberechtigungsprüfung müssen hier also selbst passieren. Versionsdokumente
// haben die Form { parent, version: {...} }, deshalb der `version.`-Präfix im Filter.
const versionsWithFunktionsberechtigung =
  (funktionsberechtigung: Funktionsberechtigung): Access =>
  ({ req: { user } }) => {
    if (!user) return false

    const benutzer = user as unknown as Benutzer
    const kommuneId = getId(benutzer.kommune)
    const kommuneFilter: Where | true = kommuneId
      ? { 'version.kommune': { equals: kommuneId } }
      : true

    if (isSuperAdmin(benutzer)) return kommuneFilter

    const berechtigt = (benutzer.organisationseinheiten ?? []).some((oe) =>
      (oe.funktionsberechtigungen as Funktionsberechtigung[]).includes(funktionsberechtigung),
    )
    return berechtigt ? kommuneFilter : false
  }

// This is automatically added by the default access control plugin if the collection has a `kommune` field.
const kommune =
  (collectionIsKommune: boolean): Access =>
  ({ data, id, req: { user } }) => {
    if (!user) return true

    const userKommuneId = getId((user as unknown as Benutzer).kommune)

    /* Lese-Operationen */

    if (!data) {
      return userKommuneId
        ? ({
            [collectionIsKommune ? 'id' : 'kommune']: { equals: userKommuneId },
          } satisfies Where)
        : // Der API-User für den Synchronizer hat keine kommuneId, damit er für *alle* Mandanten eingesetzt
          // werden kann.
          {}
    }

    /* Schreib-Operationen */

    if (!userKommuneId) return true

    const { kommune: docKommune } = (data ?? {}) as WithKommune
    if (!collectionIsKommune && !docKommune) return true
    if (collectionIsKommune && !id) return true
    const kommuneId = collectionIsKommune ? id : getId(docKommune)
    return userKommuneId === kommuneId
  }

// This is automatically added by the default access control plugin if the collection has an `untereinheit` field.
const organisationseinheit =
  (
    collectionIsUntereinheit: boolean = false,
    funktionsberechtigungen?: Funktionsberechtigung[] | null,
  ): Access =>
  ({ data, id, isReadingStaticFile, req }) => {
    const { user, method } = req
    if (!user) return true
    const collection = (req as { collection?: { config?: { versions?: unknown } } }).collection
    const benutzer = user as unknown as Benutzer
    let organisationseinheiten = benutzer.organisationseinheiten ?? []
    if (funktionsberechtigungen) {
      organisationseinheiten = organisationseinheiten.filter((oe) =>
        hasAnyFunktionsberechtigung(oe.funktionsberechtigungen, funktionsberechtigungen),
      )
    }
    const organisationseinheitIds = organisationseinheiten.map((oe) =>
      getId(oe.organisationseinheit),
    )

    /* Lese-Operationen */

    if (!data) {
      // In v3, `isReadingStaticFile` replaces the old `!collection && !id` check.
      // Access rules werden auch auf die Download-URLs von `upload`-Collections angewendet. Diese URLs sollen nicht
      // eingeschränkt werden, damit ein eingeloggter Nutzer trotzdem auf die Datei zugreifen kann, falls diese direkt
      // verlinkt wird.
      if (isReadingStaticFile) {
        return {}
      }
      // Die hier zurückgegebene Where-Klausel wird sowohl auf die Listenansicht als auch bei der Abfrage per ID
      // angewendet. Bei versionierten Collections heben wir die Einschränkung für GET-by-id auf, da sonst Entwürfe
      // ohne Organisationseinheit nicht abrufbar wären.
      if (method === 'GET' && id && collection?.config?.versions) {
        return {}
      }
      if (organisationseinheitIds.length === 0) {
        return false
      }
      return {
        [collectionIsUntereinheit ? 'id' : 'untereinheit']: {
          in: organisationseinheitIds,
        },
      } satisfies Where
    }

    /* Schreib-Operationen */

    const { untereinheit: docUntereinheit } = (data ?? {}) as WithUntereinheit

    if (!collectionIsUntereinheit && !docUntereinheit) return true
    if (collectionIsUntereinheit && !id) return true
    const untereinheitId = collectionIsUntereinheit ? id : getId(docUntereinheit)
    if (!benutzer.organisationseinheiten) {
      return false
    }
    return (
      untereinheitId != null &&
      benutzer.organisationseinheiten.some(
        (oe) =>
          getId(oe.organisationseinheit) === untereinheitId &&
          (funktionsberechtigungen == null ||
            hasAnyFunktionsberechtigung(oe.funktionsberechtigungen, funktionsberechtigungen)),
      )
    )
  }

const superAdmin: Access = ({ req: { user } }) => isSuperAdmin(user)

const forbidden: Access = () => false

export const composeAccessRules = (rules: Access[]): Access => {
  if (rules.length === 0) return () => true
  if (rules.length === 1) return rules[0]
  return async (args) => {
    let where: Where | undefined = undefined
    for (const rule of rules) {
      const res = await rule(args)
      if (res === false) {
        return false
      }
      if (res === ACCESS_SKIP_FOLLOWING_RULES) {
        break
      }
      if (typeof res === 'object') {
        ;(where ??= { and: [] }).and!.push(res)
      }
    }
    return where ?? true
  }
}

type WithKommune = {
  id: string
  kommune?: string | Kommune
}

type WithUntereinheit = {
  id: string
  untereinheit?: string | Untereinheit
}

export const ACCESS_SKIP_FOLLOWING_RULES = {}

export const accessRules = {
  authenticated,
  publicRead,
  versionsWithFunktionsberechtigung,
  kommune,
  organisationseinheit,
  superAdmin,
  forbidden,
} as const

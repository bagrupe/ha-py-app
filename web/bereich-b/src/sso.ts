import { randomBytes } from 'node:crypto'
import { promisify } from 'node:util'
import { type Payload, getFieldsToSign, jwtSign } from 'payload'
import { type Benutzer } from './payload-types'

const randomBytesAsync = promisify(randomBytes)

// Reference: payload/src/auth/operations/login.ts

const AUTH_COLLECTION = 'benutzer'

type SSOLoginInput = {
  email: string
  type?: string
  kommuneId?: string | null
  bereichAUserId: string
}

type RelationshipValue = Benutzer['kommune'] | { id?: string | null } | null | undefined

const requireNonEmptyString = (value: unknown, fieldName: string) => {
  if (typeof value !== 'string' || value.trim() === '') {
    throw new TypeError(`${fieldName} must be a non-empty string`)
  }

  return value
}

const getRelationshipId = (value: RelationshipValue): string | undefined => {
  if (typeof value === 'string') return value
  if (value && typeof value === 'object' && 'id' in value && typeof value.id === 'string') {
    return value.id
  }
  return undefined
}

const normalizeUser = (user: Benutzer): Benutzer => ({
  ...user,
  kommune: getRelationshipId(user.kommune),
})

const findKommuneIdByBereichAId = async (payload: Payload, bereichAKommuneId?: string) => {
  if (!bereichAKommuneId) return undefined

  const result = await payload.find({
    collection: 'kommunen',
    depth: 0,
    limit: 1,
    where: { bereichAId: { equals: bereichAKommuneId } },
  })

  return result.docs[0]?.id
}

const findUserByEmail = async (payload: Payload, email: string) => {
  const result = await payload.find({
    collection: AUTH_COLLECTION,
    depth: 0,
    limit: 1,
    where: { email: { equals: email } },
  })

  return result.docs[0] as Benutzer | undefined
}

const buildUserData = (
  bereichAUserId: string,
  kommuneId?: string,
): Pick<Benutzer, 'bereichAId' | 'kommune'> => ({
  bereichAId: bereichAUserId,
  ...(kommuneId ? { kommune: kommuneId } : {}),
})

export const ssoLogin = async (
  payload: Payload,
  { email, kommuneId: bereichAKommuneId, bereichAUserId }: SSOLoginInput,
) => {
  const normalizedEmail = requireNonEmptyString(email, 'email')
  const normalizedBereichAUserId = requireNonEmptyString(bereichAUserId, 'bereichAUserId')
  const normalizedBereichAKommuneId =
    typeof bereichAKommuneId === 'string' && bereichAKommuneId.trim() !== ''
      ? bereichAKommuneId
      : undefined

  const collectionConfig = payload.collections[AUTH_COLLECTION]?.config
  if (!collectionConfig?.auth) {
    throw new Error(`Auth collection "${AUTH_COLLECTION}" is not configured`)
  }

  const kommuneId = await findKommuneIdByBereichAId(payload, normalizedBereichAKommuneId)
  const existingUser = await findUserByEmail(payload, normalizedEmail)

  let user: Benutzer

  if (existingUser) {
    const persistedKommuneId = kommuneId ?? getRelationshipId(existingUser.kommune)
    user = normalizeUser(
      (await payload.update({
        collection: AUTH_COLLECTION,
        depth: 0,
        id: existingUser.id,
        data: buildUserData(normalizedBereichAUserId, persistedKommuneId),
      })) as Benutzer,
    )
  } else {
    const password = (await randomBytesAsync(128)).toString('hex')
    user = normalizeUser(
      (await payload.create({
        collection: AUTH_COLLECTION,
        data: {
          email: normalizedEmail,
          password,
          lockUntil: undefined,
          ...buildUserData(normalizedBereichAUserId, kommuneId),
        },
        depth: 0,
      })) as Benutzer,
    )
  }

  const fieldsToSign = getFieldsToSign({
    collectionConfig,
    user: { ...user, collection: AUTH_COLLECTION },
    email: normalizedEmail,
  })

  const { token } = await jwtSign({
    fieldsToSign,
    secret: payload.secret,
    tokenExpiration: collectionConfig.auth.tokenExpiration,
  })

  return token
}

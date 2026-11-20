import { type FieldAccess } from 'payload'
import { accessRules } from './index'

export const fieldAccessRules = {
  superAdmin: accessRules.superAdmin as FieldAccess,
  forbidden: accessRules.forbidden as FieldAccess,
}

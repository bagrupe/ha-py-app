import {
  type CheckboxField,
  type FieldHook,
  type NumberField,
  type PayloadRequest,
  type TextField,
} from 'payload'
import { fieldAccessRules } from '../access'

type GeneratedValueOptions<TValue, TDoc, TSiblingData = unknown> = {
  name: string
  beforeValidate?: FieldHook<TDoc & { id: string }, TValue, TSiblingData>
} & (
  | {
      nullable?: false
      value: (
        doc: TDoc,
        siblingData: TSiblingData,
        request: PayloadRequest,
      ) => TValue | Promise<TValue>
    }
  | {
      nullable: true
      value: (
        doc: TDoc,
        siblingData: TSiblingData,
        request: PayloadRequest,
      ) => TValue | null | Promise<TValue | null>
    }
)

// A generated field that reads document or sibling fields must have those fields included in
// its owning collection's forceSelect configuration. Payload applies select projections before
// afterRead hooks, so required source data is otherwise absent from narrow Select API requests.
const generatedValue =
  <TType extends 'text' | 'number' | 'checkbox'>(type: TType) =>
  <TDoc = { id: string }, TSiblingData = unknown>({
    value,
    beforeValidate,
    nullable: _nullable,
    ...rest
  }: GeneratedValueOptions<
    TType extends 'number' ? number : TType extends 'text' ? string : boolean,
    TDoc,
    TSiblingData
  >) =>
    ({
      ...rest,
      type: type,
      admin: {
        hidden: true,
      },
      access: {
        create: fieldAccessRules.forbidden,
        update: fieldAccessRules.forbidden,
      },
      hooks: {
        beforeValidate: [beforeValidate ?? (() => (type === 'text' ? '' : 0))] as FieldHook[],
        afterRead: [
          ({ data, siblingData, req }) => value(data as TDoc, siblingData as TSiblingData, req),
        ],
      },
    }) as NumberField | TextField | CheckboxField

export const generatedString = generatedValue('text')
export const generatedNumber = generatedValue('number')
export const generatedBoolean = generatedValue('checkbox')

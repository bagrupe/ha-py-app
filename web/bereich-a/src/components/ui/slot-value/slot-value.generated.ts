import * as Types from '../../../__generated__/graphql';

import {EncryptedValueFragment} from '../../../lib/context/auth/auth.generated';
import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import {EncryptedValueFragmentDoc} from '../../../lib/context/auth/auth.generated';

export type SlotValue_EncryptedSlotValue_Fragment = {
  __typename?: 'EncryptedSlotValue';
  id: string;
  slotName: string;
  istFreigegeben?: boolean | null;
  encryptedValue: {__typename?: 'EncryptedValue'} & EncryptedValueFragment;
};

export type SlotValue_PlainSlotValue_Fragment = {
  __typename?: 'PlainSlotValue';
  id: string;
  slotName: string;
  istFreigegeben?: boolean | null;
  plainValue: unknown;
};

export type SlotValueFragment =
  | SlotValue_EncryptedSlotValue_Fragment
  | SlotValue_PlainSlotValue_Fragment;

export const SlotValueFragmentDoc = gql`
  fragment SlotValue on SlotValue {
    id
    slotName
    istFreigegeben
    ... on EncryptedSlotValue {
      encryptedValue: value {
        ...EncryptedValue
      }
    }
    ... on PlainSlotValue {
      plainValue: value
    }
  }
  ${EncryptedValueFragmentDoc}
`;

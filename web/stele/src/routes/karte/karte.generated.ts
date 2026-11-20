import * as Types from '../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;

export type StelePoisQueryVariables = Types.Exact<{
  kommuneId?: Types.Maybe<unknown>;
  limit?: Types.Maybe<number>;
}>;

export type StelePoisQuery = {
  __typename?: 'Query';
  pois?: {
    __typename?: 'Pois';
    docs: Array<{
      __typename?: 'Poi';
      id: string;
      title: string;
      position: Array<number>;
      positionString?: string | null;
      additionalInformation?: Array<{
        __typename?: 'Poi_AdditionalInformation';
        heading?: string | null;
        text?: string | null;
        kind?: Types.Poi_AdditionalInformation_Kind | null;
      }> | null;
      category?: {
        __typename?: 'PoiCategory';
        id: string;
        title: string;
        supercategory?: {
          __typename?: 'PoiSupercategory';
          id: string;
          title: string;
        } | null;
        icon?: {__typename?: 'PoiIcon'; id: string; url?: string | null} | null;
      } | null;
    }>;
  } | null;
};

export const StelePoisDocument = gql`
  query StelePois($kommuneId: JSON, $limit: Int) {
    pois(where: {kommune: {equals: $kommuneId}}, limit: $limit) {
      docs {
        id
        title
        position
        positionString
        additionalInformation {
          heading
          text
          kind
        }
        category {
          id
          title
          supercategory {
            id
            title
          }
          icon {
            id
            url
          }
        }
      }
    }
  }
`;

export function useStelePoisQuery(
  options?: Omit<Urql.UseQueryArgs<StelePoisQueryVariables>, 'query'>,
) {
  return Urql.useQuery<StelePoisQuery, StelePoisQueryVariables>({
    query: StelePoisDocument,
    ...options,
  });
}

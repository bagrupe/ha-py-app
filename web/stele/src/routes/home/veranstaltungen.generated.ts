import * as Types from '../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;

export type KioskVeranstaltungsTermineListQueryVariables = Types.Exact<{
  kommune?: Types.Maybe<string>;
  untereinheiten?: Types.Maybe<Array<Types.Maybe<string>>>;
  von?: Types.Maybe<string>;
  bis?: Types.Maybe<string>;
  categoryIds?: Types.Maybe<Array<Types.Maybe<string>>>;
  limit?: Types.Maybe<number>;
  page?: Types.Maybe<number>;
  sortDirection?: Types.Maybe<string>;
}>;

export type KioskVeranstaltungsTermineListQuery = {
  __typename?: 'Query';
  veranstaltungsTermine?: {
    __typename?: 'VeranstaltungsTermineResult';
    totalDocs?: number | null;
    totalPages?: number | null;
    hasNextPage?: boolean | null;
    page?: number | null;
    limit?: number | null;
    docs?: Array<{
      __typename?: 'VeranstaltungsTermin';
      id?: string | null;
      titel?: string | null;
      teaser?: string | null;
      buchungsUrl?: string | null;
      ticketUrl?: string | null;
      anbieterUrl?: string | null;
      locationName?: string | null;
      start?: string | null;
      end?: string | null;
      dates?: Array<{
        __typename?: 'VeranstaltungsTerminDate';
        start?: string | null;
        end?: string | null;
      } | null> | null;
      titelbild?: {
        __typename?: 'VeranstaltungsTerminTitelbild';
        external?: boolean | null;
        url?: string | null;
        internal?: {
          __typename?: 'VeranstaltungsTerminTitelbildInternal';
          url?: string | null;
        } | null;
      } | null;
      veranstalterAdresse?: {
        __typename?: 'VeranstaltungsTerminVeranstalterAdresse';
        name?: string | null;
        strasse?: string | null;
        plz?: string | null;
        ort?: string | null;
        url?: string | null;
      } | null;
    } | null> | null;
  } | null;
};

export const KioskVeranstaltungsTermineListDocument = gql`
  query KioskVeranstaltungsTermineList(
    $kommune: String
    $untereinheiten: [String]
    $von: String
    $bis: String
    $categoryIds: [String]
    $limit: Int = 20
    $page: Int = 1
    $sortDirection: String = "asc"
  ) {
    veranstaltungsTermine(
      kommune: $kommune
      untereinheiten: $untereinheiten
      von: $von
      bis: $bis
      categoryIds: $categoryIds
      visible: true
      limit: $limit
      page: $page
      sortDirection: $sortDirection
    ) {
      totalDocs
      totalPages
      hasNextPage
      page
      limit
      docs {
        id
        titel
        teaser
        buchungsUrl
        ticketUrl
        anbieterUrl
        locationName
        start
        end
        dates {
          start
          end
        }
        titelbild {
          external
          url
          internal {
            url
          }
        }
        veranstalterAdresse {
          name
          strasse
          plz
          ort
          url
        }
      }
    }
  }
`;

export function useKioskVeranstaltungsTermineListQuery(
  options?: Omit<
    Urql.UseQueryArgs<KioskVeranstaltungsTermineListQueryVariables>,
    'query'
  >,
) {
  return Urql.useQuery<
    KioskVeranstaltungsTermineListQuery,
    KioskVeranstaltungsTermineListQueryVariables
  >({query: KioskVeranstaltungsTermineListDocument, ...options});
}

import * as Types from '../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;

export type ProgrammatischeSchritteQueryVariables = Types.Exact<{
  [key: string]: never;
}>;

export type ProgrammatischeSchritteQuery = {
  __typename?: 'Query';
  programmatischeSchritte: Array<{
    __typename?: 'ProgrammatischerSchrittDefinition';
    name: string;
    implementationAssemblyQualifiedName: string;
    liefertZustaendigkeit: boolean;
  }>;
};

export const ProgrammatischeSchritteDocument = gql`
  query ProgrammatischeSchritte {
    programmatischeSchritte {
      name
      implementationAssemblyQualifiedName
      liefertZustaendigkeit
    }
  }
`;

export function useProgrammatischeSchritteQuery(
  options?: Omit<
    Urql.UseQueryArgs<ProgrammatischeSchritteQueryVariables>,
    'query'
  >,
) {
  return Urql.useQuery<
    ProgrammatischeSchritteQuery,
    ProgrammatischeSchritteQueryVariables
  >({query: ProgrammatischeSchritteDocument, ...options});
}

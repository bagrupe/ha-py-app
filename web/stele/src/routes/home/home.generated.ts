import * as Types from '../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;

export type KioskHomeWeatherQueryVariables = Types.Exact<{
  kommuneId: unknown;
  locationName: string;
}>;

export type KioskHomeWeatherQuery = {
  __typename?: 'Query';
  wettermesspunkteList?: {
    __typename?: 'Wettermesspunktes';
    totalDocs: number;
    docs: Array<{
      __typename?: 'Wettermesspunkte';
      id: string;
      locationName: string;
      location: Array<number>;
      weather: Array<{
        __typename?: 'Wettermesspunkte_Weather';
        date?: Date | null;
        maxTemp?: number | null;
        minTemp?: number | null;
        icon?: string | null;
      }>;
    }>;
  } | null;
};

export const KioskHomeWeatherDocument = gql`
  query KioskHomeWeather($kommuneId: JSON!, $locationName: String!) {
    wettermesspunkteList(
      where: {
        kommune: {equals: $kommuneId}
        locationName: {equals: $locationName}
      }
    ) {
      totalDocs
      docs {
        id
        locationName
        location
        weather {
          date
          maxTemp
          minTemp
          icon
        }
      }
    }
  }
`;

export function useKioskHomeWeatherQuery(
  options: Omit<Urql.UseQueryArgs<KioskHomeWeatherQueryVariables>, 'query'>,
) {
  return Urql.useQuery<KioskHomeWeatherQuery, KioskHomeWeatherQueryVariables>({
    query: KioskHomeWeatherDocument,
    ...options,
  });
}

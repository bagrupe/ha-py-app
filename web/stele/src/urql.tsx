import {
  createUrqlClient as baseCreateUrqlClient,
  type CreateUrqlClientOptions,
} from '@kommunalapp/graphql-client';
import {type FC, type PropsWithChildren, useMemo} from 'react';
import {Provider} from 'urql';
import introspectionSchema from './__generated__/introspection';

export const createUrqlClient = (
  options: Partial<Omit<CreateUrqlClientOptions, 'url' | 'introspection'>> = {},
) =>
  baseCreateUrqlClient({
    url: '/graphql',
    introspection: introspectionSchema,
    cache: true,
    ...options,
  });

export const UrqlProvider: FC<PropsWithChildren> = ({children}) => {
  const client = useMemo(() => createUrqlClient(), []);

  return <Provider value={client}>{children}</Provider>;
};

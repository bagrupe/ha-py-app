import type * as GraphQL from 'graphql'
import { type GraphQLInfo, type PayloadRequest, type SanitizedConfig } from 'payload'

export type GraphQLExtensionContext = { config: SanitizedConfig } & GraphQLInfo

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type ResolverFactory<TResult = any, TResolvedArgs = any> = (
  graphql: typeof GraphQL,
  context: GraphQLExtensionContext,
) => {
  type: GraphQL.GraphQLType
  args: Record<string, unknown>
  resolve: (
    source: unknown,
    args: TResolvedArgs,
    context: { req: PayloadRequest },
    info: GraphQL.GraphQLResolveInfo,
  ) => Promise<TResult> | TResult
}

export const getCollectionType = (
  context: GraphQLExtensionContext,
  slug: string,
): GraphQL.GraphQLObjectType => context.collections[slug].graphQL!.type

/**
 * Creates a payload query factory from a mapping of query names to query factories.
 *
 * Usage:
 *
 * my-query.ts:
 * const myQuery: QueryFactory<any, any> = (GraphQL, context) => ({
 *   type: new GraphQL.GraphQLObjectType({
 *     ...,
 *   }),
 *   ...,
 * })
 *
 * payload.config.ts:
 * buildConfig({
 *   ...,
 *   graphQL: {
 *     queries: mergeQueries({nameOfQuery: myQuery}),
 *   }
 * })
 */
export const mergeResolvers =
  <TFactory extends ResolverFactory>(queryFactories: Record<string, TFactory>) =>
  (graphql: typeof GraphQL, context: GraphQLExtensionContext) => {
    const queries: { [key: string]: ReturnType<ResolverFactory> } = {}
    for (const [name, factory] of Object.entries(queryFactories)) {
      queries[name] = factory(graphql, context)
    }
    return queries
  }

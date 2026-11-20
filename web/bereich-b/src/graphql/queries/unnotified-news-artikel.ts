import { type NewsArtikel } from '../../payload-types'
import { getCollectionType, type ResolverFactory } from '../../utils/merge-queries'

export const unnotifiedNewsArtikel: ResolverFactory<
  NewsArtikel[] | undefined,
  { from: string; until: string }
> = (GraphQL, context) => ({
  type: new GraphQL.GraphQLNonNull(
    new GraphQL.GraphQLList(new GraphQL.GraphQLNonNull(getCollectionType(context, 'news-artikel'))),
  ),
  args: {
    from: { type: new GraphQL.GraphQLNonNull(GraphQL.GraphQLString) },
    until: { type: new GraphQL.GraphQLNonNull(GraphQL.GraphQLString) },
  },
  resolve: async (_source, { from, until }, { req }) => {
    if (!req.user) {
      throw new GraphQL.GraphQLError('Authentication required', {
        extensions: { code: 'UNAUTHENTICATED' },
      })
    }

    // We need this custom query resolver because the same query is not
    // possible through the graphql API, which does not support multiple and-conditions on the same field.
    const { docs } = await req.payload.find({
      collection: 'news-artikel',
      draft: false,
      depth: 0,
      overrideAccess: false,
      req,
      where: {
        notified: { not_equals: true },
        and: [
          { _status: { equals: 'published' } },
          { visible: { equals: true } },
          { datum: { greater_than_equal: new Date(from) } },
          { datum: { less_than_equal: new Date(until) } },
        ],
      },
    })
    return docs
  },
})

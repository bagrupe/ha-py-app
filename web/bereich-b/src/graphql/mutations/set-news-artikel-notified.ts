import { type ResolverFactory } from '../../utils/merge-queries'

export const setNewsArtikelNotified: ResolverFactory<{ success: boolean }, { ids: string[] }> = (
  GraphQL,
) => ({
  type: new GraphQL.GraphQLObjectType({
    name: 'SetNewsArtikelNotifiedPayload',
    fields: {
      success: { type: GraphQL.GraphQLBoolean },
    },
  }),
  args: {
    ids: {
      type: new GraphQL.GraphQLNonNull(
        new GraphQL.GraphQLList(new GraphQL.GraphQLNonNull(GraphQL.GraphQLString)),
      ),
    },
  },
  resolve: async (_source, { ids }, { req }) => {
    const { errors } = await req.payload.update({
      collection: 'news-artikel',
      where: { id: { in: ids } },
      depth: 0,
      overrideAccess: false,
      req,
      data: {
        notified: true,
      },
    })
    return { success: errors.length === 0 }
  },
})

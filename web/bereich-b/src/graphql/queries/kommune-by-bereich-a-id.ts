import { type Kommune } from '../../payload-types'
import { getCollectionType, type ResolverFactory } from '../../utils/merge-queries'

export const kommuneByBereichAIdQuery: ResolverFactory<
  Kommune | undefined,
  { kommuneId: string }
> = (GraphQL, context) => ({
  type: getCollectionType(context, 'kommunen'),
  args: { kommuneId: { type: GraphQL.GraphQLID } },
  resolve: async (_source, { kommuneId }, { req }) => {
    const { docs } = await req.payload.find({
      collection: 'kommunen',
      depth: 0,
      overrideAccess: false,
      req,
      where: { bereichAId: { equals: kommuneId } },
    })
    return docs[0]
  },
})

import { type GeoFlaechen } from '../../payload-types'
import { getCollectionType, type ResolverFactory } from '../../utils/merge-queries'

export const geoflaechenByBereichAId: ResolverFactory<
  GeoFlaechen | undefined,
  { kommuneId: string }
> = (GraphQL, context) => ({
  type: getCollectionType(context, 'geo-flaechen'),
  args: { kommuneId: { type: GraphQL.GraphQLID } },
  resolve: async (_source, { kommuneId }, { req }) => {
    const { docs } = await req.payload.find({
      collection: 'geo-flaechen',
      depth: 0,
      overrideAccess: false,
      req,
      where: { 'kommune.bereichAId': { equals: kommuneId } },
    })
    return docs[0]
  },
})

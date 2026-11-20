import {
  GraphQLBoolean,
  GraphQLFloat,
  GraphQLInputObjectType,
  GraphQLObjectType,
  GraphQLString,
} from 'graphql'
import { type ResolverFactory } from '../../utils/merge-queries'
import {
  isPointInGeoflaeche,
  type IsPointInGeoflaecheResult,
} from '../../utils/point-in-geoflaeche'

const positionType = new GraphQLInputObjectType({
  name: 'Position',
  fields: {
    lat: { type: GraphQLFloat },
    long: { type: GraphQLFloat },
  },
})

const isInsideReturnType = new GraphQLObjectType({
  name: 'IsInside',
  fields: {
    isInside: { type: GraphQLBoolean },
    message: { type: GraphQLString },
  },
})

export const isPointInGeoflaecheQuery: ResolverFactory<
  IsPointInGeoflaecheResult,
  { kommuneId: string; name: string; position: { lat: number; long: number } }
> = (GraphQL) => ({
  type: isInsideReturnType,
  args: {
    kommuneId: { type: GraphQL.GraphQLID },
    name: { type: GraphQL.GraphQLString },
    position: { type: positionType },
  },
  resolve: async (_: unknown, { kommuneId, name, position }, { req }) =>
    await isPointInGeoflaeche(name, kommuneId, position, req),
})

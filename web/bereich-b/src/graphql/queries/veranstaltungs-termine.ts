import { GraphQLBoolean, GraphQLInt, GraphQLList, GraphQLObjectType, GraphQLString } from 'graphql'
import { type MongooseAdapter } from '@payloadcms/db-mongodb'
import { type PipelineStage, Types } from 'mongoose'
import { type Veranstaltungsmedien } from '../../payload-types'
import { type ResolverFactory } from '../../utils/merge-queries'

const ISO_FORMAT = '%Y-%m-%dT%H:%M:%S.%LZ'
const OBJECT_ID_PATTERN = /^[a-f\d]{24}$/i

const toObjectId = (id: string) =>
  OBJECT_ID_PATTERN.test(id) && Types.ObjectId.isValid(id) ? new Types.ObjectId(id) : null

const toDateExpression = (input: string) => ({
  $convert: {
    input,
    to: 'date',
    onError: null,
    onNull: null,
  },
})

const toIsoStringExpression = (date: string) => ({
  $dateToString: {
    format: ISO_FORMAT,
    date,
    onNull: null,
  },
})

const kategorieType = new GraphQLObjectType({
  name: 'VeranstaltungsTerminKategorie',
  fields: {
    id: { type: GraphQLString },
    label: { type: GraphQLString },
  },
})

const titelbildInternalThumbnailType = new GraphQLObjectType({
  name: 'VeranstaltungsTerminTitelbildInternalThumbnail',
  fields: {
    url: { type: GraphQLString },
  },
})

const titelbildInternalSizesType = new GraphQLObjectType({
  name: 'VeranstaltungsTerminTitelbildInternalSizes',
  fields: {
    thumbnail: { type: titelbildInternalThumbnailType },
  },
})

const titelbildInternalType = new GraphQLObjectType({
  name: 'VeranstaltungsTerminTitelbildInternal',
  fields: {
    url: { type: GraphQLString },
    sizes: { type: titelbildInternalSizesType },
  },
})

const titelbildType = new GraphQLObjectType({
  name: 'VeranstaltungsTerminTitelbild',
  fields: {
    external: { type: GraphQLBoolean },
    url: { type: GraphQLString },
    internal: { type: titelbildInternalType },
  },
})

const terminDateType = new GraphQLObjectType({
  name: 'VeranstaltungsTerminDate',
  fields: {
    start: { type: GraphQLString },
    end: { type: GraphQLString },
  },
})

const veranstalterAdresseType = new GraphQLObjectType({
  name: 'VeranstaltungsTerminVeranstalterAdresse',
  fields: {
    name: { type: GraphQLString },
    plz: { type: GraphQLString },
    ort: { type: GraphQLString },
    strasse: { type: GraphQLString },
    telefon: { type: GraphQLString },
    url: { type: GraphQLString },
    email: { type: GraphQLString },
  },
})

const terminType = new GraphQLObjectType({
  name: 'VeranstaltungsTermin',
  fields: {
    id: { type: GraphQLString },
    titel: { type: GraphQLString },
    subtitle: { type: GraphQLString },
    teaser: { type: GraphQLString },
    buchungsUrl: { type: GraphQLString },
    ticketUrl: { type: GraphQLString },
    anbieterUrl: { type: GraphQLString },
    locationName: { type: GraphQLString },
    address: { type: GraphQLString },
    coordinates: { type: new GraphQLList(GraphQLString) },
    start: { type: GraphQLString },
    end: { type: GraphQLString },
    dates: { type: new GraphQLList(terminDateType) },
    titelbild: { type: titelbildType },
    category: { type: new GraphQLList(kategorieType) },
    veranstalterAdresse: { type: veranstalterAdresseType },
  },
})

const resultType = new GraphQLObjectType({
  name: 'VeranstaltungsTermineResult',
  fields: {
    docs: { type: new GraphQLList(terminType) },
    totalDocs: { type: GraphQLInt },
    page: { type: GraphQLInt },
    limit: { type: GraphQLInt },
    totalPages: { type: GraphQLInt },
    hasNextPage: { type: GraphQLBoolean },
  },
})

interface VeranstaltungsTermineArgs {
  kommune?: string
  untereinheit?: string
  untereinheiten?: string[]
  von?: string
  bis?: string
  categoryIds?: string[]
  search?: string
  visible?: boolean
  limit?: number
  page?: number
  sortDirection?: string
}

export const veranstaltungsTermineQuery: ResolverFactory = (GraphQL) => ({
  type: resultType,
  args: {
    kommune: { type: GraphQL.GraphQLString },
    // TODO: remove once app builds <= 1.0.2 are no longer supported. Replaced by `untereinheiten`.
    untereinheit: {
      type: GraphQL.GraphQLString,
      deprecationReason: 'Use `untereinheiten` for multi-select.',
    },
    untereinheiten: { type: new GraphQL.GraphQLList(GraphQL.GraphQLString) },
    von: { type: GraphQL.GraphQLString },
    bis: { type: GraphQL.GraphQLString },
    categoryIds: { type: new GraphQL.GraphQLList(GraphQL.GraphQLString) },
    search: { type: GraphQL.GraphQLString },
    visible: { type: GraphQL.GraphQLBoolean },
    limit: { type: GraphQL.GraphQLInt },
    page: { type: GraphQL.GraphQLInt },
    sortDirection: { type: GraphQL.GraphQLString },
  },
  resolve: async (_source, args: VeranstaltungsTermineArgs, { req }) => {
    const {
      kommune,
      untereinheit,
      untereinheiten,
      von,
      bis,
      categoryIds,
      search,
      visible = true,
      limit = 20,
      page = 1,
      sortDirection = 'asc',
    } = args

    const untereinheitFilter = untereinheiten?.length
      ? untereinheiten
      : untereinheit
        ? [untereinheit]
        : undefined

    const now = new Date().toISOString()
    const emptyResult = {
      docs: [],
      totalDocs: 0,
      page,
      limit,
      totalPages: 0,
      hasNextPage: false,
    }

    // Stage 1: Pre-filter match on parent document fields
    const preMatch: Record<string, unknown> = {}

    preMatch['visible'] = req.user ? visible : true

    if (kommune) {
      const kommuneId = toObjectId(kommune)
      if (!kommuneId) return emptyResult
      preMatch['kommune'] = { $in: [kommuneId, kommune] }
    }

    if (untereinheitFilter) {
      preMatch['untereinheit'] = { $in: untereinheitFilter }
    }

    if (search) {
      const escaped = search.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
      preMatch['titel'] = { $regex: escaped, $options: 'i' }
    }

    if (categoryIds && categoryIds.length > 0) {
      const categoryStorageIds = categoryIds.flatMap((id) => {
        const objectId = toObjectId(id)
        return objectId ? [objectId, id] : []
      })
      if (categoryStorageIds.length === 0) return emptyResult
      preMatch['category'] = { $in: categoryStorageIds }
    }

    // Stage 3: Post-unwind date range filter
    const dateMatch: Record<string, unknown> = {}
    const startFilter: Record<string, unknown> = {}

    startFilter['$gte'] = new Date(von ?? now)
    if (bis) {
      startFilter['$lte'] = new Date(bis)
    }

    dateMatch['__startDate'] = startFilter

    const sortDir = sortDirection === 'desc' ? -1 : 1
    const skip = (page - 1) * limit

    // In Payload v3 with @payloadcms/db-mongodb, Mongoose models are at payload.db.collections
    const Model = (req.payload.db as MongooseAdapter).collections['veranstaltungskalender']

    const pipeline: PipelineStage[] = [
      // Stage 1: Pre-filter
      { $match: preMatch },
      // Stage 2: Unwind dates
      { $unwind: '$timeAndLocation.dates' },
      // Stage 2.5: Normalize Payload date values. Existing v1/v3 data can contain either
      // BSON Dates or ISO strings, depending on when the document was written.
      {
        $addFields: {
          __startDate: toDateExpression('$timeAndLocation.dates.start'),
          __endDate: toDateExpression('$timeAndLocation.dates.end'),
        },
      },
      // Stage 3: Date range filter
      { $match: dateMatch },
      // Stage 4: Sort by start ascending (needed for $group $first to pick earliest)
      { $sort: { __startDate: 1 as const } },
      // Stage 5: Group by (document, calendar day) to aggregate same-day termine
      {
        $group: {
          _id: {
            docId: '$_id',
            day: {
              $dateToString: {
                format: '%Y-%m-%d',
                date: '$__startDate',
                timezone: 'Europe/Berlin',
              },
            },
          },
          // Keep the earliest termin as root (guaranteed by prior sort)
          firstStart: { $first: '$__startDate' },
          firstEnd: { $first: '$__endDate' },
          // Collect all termine on this day (includes the first)
          allDates: {
            $push: {
              start: '$__startDate',
              end: '$__endDate',
            },
          },
          // Preserve document fields from the first occurrence
          titel: { $first: '$titel' },
          subtitle: { $first: '$subtitle' },
          teaser: { $first: '$teaser' },
          buchungsUrl: { $first: '$buchungsUrl' },
          ticketUrl: { $first: '$ticketUrl' },
          anbieterUrl: { $first: '$anbieterUrl' },
          locationName: { $first: '$timeAndLocation.locationName' },
          address: { $first: '$timeAndLocation.address' },
          coordinates: { $first: '$timeAndLocation.coordinates.coordinates' },
          titelbild: { $first: '$titelbild' },
          category: { $first: '$category' },
          veranstalterAdresse: { $first: '$veranstalterAdresse' },
        },
      },
      // Stage 6: Sort grouped results by the requested direction.
      // _id tie-break keeps pagination deterministic for equal start times.
      { $sort: { firstStart: sortDir, _id: 1 as const } },
      // Stage 7: Facet for pagination
      {
        $facet: {
          docs: [
            { $skip: skip },
            { $limit: limit },
            // Lookup categories only for the paginated subset
            {
              $lookup: {
                from: 'veranstaltungskalender-kategories',
                // `category` holds ObjectIds in v3 (v1 stored strings)
                let: { catIds: { $ifNull: ['$category', []] } },
                pipeline: [
                  {
                    $match: {
                      $expr: {
                        $in: [
                          { $toString: '$_id' },
                          {
                            $map: {
                              input: '$$catIds',
                              as: 'catId',
                              in: { $toString: '$$catId' },
                            },
                          },
                        ],
                      },
                    },
                  },
                  {
                    $project: {
                      _id: 0,
                      id: { $toString: '$_id' },
                      label: '$label',
                    },
                  },
                ],
                as: 'resolvedCategories',
              },
            },
            {
              $project: {
                _id: 0,
                id: { $toString: '$_id.docId' },
                titel: 1,
                subtitle: 1,
                teaser: 1,
                buchungsUrl: 1,
                ticketUrl: 1,
                anbieterUrl: 1,
                locationName: 1,
                address: 1,
                coordinates: 1,
                start: toIsoStringExpression('$firstStart'),
                end: toIsoStringExpression('$firstEnd'),
                // Remaining termine on the same day (skip first by position)
                dates: {
                  $cond: {
                    if: { $gt: [{ $size: '$allDates' }, 1] },
                    then: {
                      $map: {
                        input: {
                          $slice: ['$allDates', 1, { $subtract: [{ $size: '$allDates' }, 1] }],
                        },
                        as: 'd',
                        in: {
                          start: toIsoStringExpression('$$d.start'),
                          end: toIsoStringExpression('$$d.end'),
                        },
                      },
                    },
                    else: [],
                  },
                },
                titelbild: {
                  external: '$titelbild.external',
                  url: '$titelbild.url',
                  // stored as ObjectId in v3; stringify for payload.find and the media map below
                  internalId: { $toString: '$titelbild.internal' },
                },
                category: '$resolvedCategories',
                veranstalterAdresse: 1,
              },
            },
          ],
          totalCount: [{ $count: 'count' }],
        },
      },
    ]

    const [result] = await Model.aggregate(pipeline)

    const totalDocs = result.totalCount[0]?.count ?? 0
    const totalPages = Math.ceil(totalDocs / limit)
    const hasNextPage = page < totalPages

    // Resolve internal titelbild media via Payload
    const mediaIds = [
      ...new Set(
        result.docs
          .map((d: { titelbild?: { internalId?: string } }) => d.titelbild?.internalId)
          .filter(Boolean) as string[],
      ),
    ]

    const mediaMap = new Map<string, Veranstaltungsmedien>()
    if (mediaIds.length > 0) {
      const mediaResult = await req.payload.find({
        collection: 'veranstaltungsmedien',
        where: { id: { in: mediaIds } },
        limit: mediaIds.length,
        depth: 0,
        overrideAccess: false,
        req,
      })
      for (const doc of mediaResult.docs) {
        mediaMap.set(doc.id, doc)
      }
    }

    const docs = result.docs.map(
      (doc: { titelbild?: { external?: boolean; url?: string; internalId?: string } }) => {
        const { titelbild, ...rest } = doc
        const internal = titelbild?.internalId ? (mediaMap.get(titelbild.internalId) ?? null) : null
        return {
          ...rest,
          titelbild: titelbild
            ? {
                external: titelbild.external,
                url: titelbild.url,
                internal,
              }
            : null,
        }
      },
    )

    return {
      docs,
      totalDocs,
      page,
      limit,
      totalPages,
      hasNextPage,
    }
  },
})

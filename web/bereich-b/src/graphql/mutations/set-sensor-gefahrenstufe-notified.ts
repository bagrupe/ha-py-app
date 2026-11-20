import { type ResolverFactory } from '../../utils/merge-queries'

// Die 8 gültigen Gefahrenstufen-Werte: 4 für Pegelstand (GRUEN..ROT) + 4 für Glätte (SAFE..CRITICAL).
// Ein Enum statt eines freien Strings verhindert, dass versehentlich ein Tippfehler oder ein
// fremder Wert als Watermark persistiert wird (siehe SensorGrenzwertPushNotificationJob, der
// letzteBenachrichtigteGefahrenstufe genau gegen diese 8 Werte abgleicht).
//
// `confirmed` steuert, welches Feld geschrieben wird: `true` setzt die tatsächlich per Push
// gemeldete Stufe (letzteBenachrichtigteGefahrenstufe) und räumt den Kandidaten auf; `false`
// schreibt nur den Kandidaten (ausstehendeGefahrenstufe), ohne dass eine Push versendet wurde.
// Damit kann derselbe Mutation-Aufruf für beide Schritte des zweistufigen Debounce im
// SensorGrenzwertPushNotificationJob genutzt werden, statt eine zweite Mutation (und damit
// einen zweiten `SensorGefahrenstufe`-Enum-Typ, der zu einem Namenskonflikt im Schema führen
// würde) einzuführen.
export const setSensorGefahrenstufeNotified: ResolverFactory<
  { success: boolean },
  { sensorId: string; gefahrenstufe: string; confirmed: boolean }
> = (GraphQL) => ({
  type: new GraphQL.GraphQLObjectType({
    name: 'SetSensorGefahrenstufeNotifiedPayload',
    fields: {
      success: { type: GraphQL.GraphQLBoolean },
    },
  }),
  args: {
    sensorId: { type: new GraphQL.GraphQLNonNull(GraphQL.GraphQLString) },
    gefahrenstufe: {
      type: new GraphQL.GraphQLNonNull(
        new GraphQL.GraphQLEnumType({
          name: 'SensorGefahrenstufe',
          values: {
            GRUEN: { value: 'GRUEN' },
            GELB: { value: 'GELB' },
            ORANGE: { value: 'ORANGE' },
            ROT: { value: 'ROT' },
            SAFE: { value: 'SAFE' },
            ADVISORY: { value: 'ADVISORY' },
            WARNING: { value: 'WARNING' },
            CRITICAL: { value: 'CRITICAL' },
          },
        }),
      ),
    },
    confirmed: { type: new GraphQL.GraphQLNonNull(GraphQL.GraphQLBoolean) },
  },
  resolve: async (_source, { sensorId, gefahrenstufe, confirmed }, { req }) => {
    const { errors } = await req.payload.update({
      collection: 'sensoren',
      where: { id: { equals: sensorId } },
      depth: 0,
      overrideAccess: false,
      req,
      data: confirmed
        ? {
            letzteBenachrichtigteGefahrenstufe: gefahrenstufe,
            ausstehendeGefahrenstufe: gefahrenstufe,
          }
        : { ausstehendeGefahrenstufe: gefahrenstufe },
    })
    return { success: errors.length === 0 }
  },
})

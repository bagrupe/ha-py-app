import { z } from 'zod'

// Siehe Spezifikation von 2008 (https://geojson.org/geojson-spec#coordinate-reference-system-objects) für mehr
// Informationen über die inzwischen abgelöste `crs`-Eigenschaft.

const pointSchema = z.object({
  type: z.literal('Point'),
  coordinates: z.tuple([z.number(), z.number()]).describe('Längengrad, Breitengrad'),
})

const propertiesSchema = z.object({
  // Wahrscheinlich ArcGIS
  OBJECTID: z
    .number()
    .describe('Objektkennung, die in dieser Sammlung eindeutig diesem POI zugeordnet ist'),
  // Caveat emptor: keine der folgenden Eigenschaften entsprechen irgendeinem Standard.
  // Sie wurden vollkommen willkürlich gewählt.
  Name: z.string(),
  Telefonnummer: z.string().nullable().optional(),
  Homepage: z.string().nullable().optional(),
  email: z.string().nullable().optional(),
  other: z.string().nullable().optional(),
})

const featureSchema = z.object({
  type: z.literal('Feature'),
  geometry: pointSchema,
  properties: propertiesSchema,
})

const crsSchema = z.object({
  type: z.literal('name'),
  properties: z.object({
    name: z
      .union([
        // https://www.lgln.niedersachsen.de/startseite/online_angebote_amp_services/webdienste/geodatendienste_der_vkv/web-map-service-der-nds-vermessungs--und-katasterverwaltung-vkv-51660.html
        z.literal('urn:ogc:def:crs:EPSG::4326'),
        z.literal('urn:ogc:def:crs:EPSG::25832'),
        z.literal('urn:ogc:def:crs:EPSG::31466'),
        z.literal('urn:ogc:def:crs:EPSG::31467'),
        z.literal('urn:ogc:def:crs:EPSG::31468'),
        z.literal('urn:ogc:def:crs:EPSG::31469'),
        z.literal('urn:ogc:def:crs:EPSG::32632'),
        z.literal('urn:ogc:def:crs:EPSG::32633'),
      ])
      .describe(
        'Optionale Angabe eines Koordinatenreferenzsystems. Ohne diese Angabe gehen wir von EPSG:4326 aus.',
      ),
  }),
})

export const featureCollectionSchema = z.object({
  type: z.literal('FeatureCollection'),
  features: z.array(featureSchema),
  crs: crsSchema.optional(),

  // Dies ist auch keine Standard-Eigenschaft!
  name: z.string().min(1),
})

export const jsonSchema = z.toJSONSchema(featureCollectionSchema, {
  io: 'input',
  target: 'draft-7',
})

export const validateGeoJson = (data: unknown) => featureCollectionSchema.safeParse(data)

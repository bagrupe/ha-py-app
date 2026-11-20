import proj4 from 'proj4'

// https://epsg.io/

proj4.defs(
  'EPSG:25832',
  '+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs +type=crs',
)

proj4.defs(
  'EPSG:31466',
  '+proj=tmerc +lat_0=0 +lon_0=6 +k=1 +x_0=2500000 +y_0=0 +ellps=bessel +nadgrids=de_adv_BETA2007.tif +units=m +no_defs +type=crs',
)

proj4.defs(
  'EPSG:31467',
  '+proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0 +ellps=bessel +nadgrids=de_adv_BETA2007.tif +units=m +no_defs +type=crs',
)

proj4.defs(
  'EPSG:31468',
  '+proj=tmerc +lat_0=0 +lon_0=12 +k=1 +x_0=4500000 +y_0=0 +ellps=bessel +nadgrids=de_adv_BETA2007.tif +units=m +no_defs +type=crs',
)

proj4.defs(
  'EPSG:31469',
  '+proj=tmerc +lat_0=0 +lon_0=15 +k=1 +x_0=5500000 +y_0=0 +ellps=bessel +nadgrids=de_adv_BETA2007.tif +units=m +no_defs +type=crs',
)

proj4.defs('EPSG:32632', '+proj=utm +zone=32 +datum=WGS84 +units=m +no_defs +type=crs')

proj4.defs('EPSG:32633', '+proj=utm +zone=33 +datum=WGS84 +units=m +no_defs +type=crs')

export const urnToEpsg = (urn: string): string => {
  const match = /EPSG::(\d+)$/.exec(urn)
  if (match) {
    return `EPSG:${match[1]}`
  }
  throw new Error(`Bad URN: ${urn}`)
}

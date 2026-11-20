type ResData = {
  features: {
    place_name_de?: string
  }[]
}

export const coordinatesToAddress = async (coordinates: [number, number]) => {
  const mapboxToken = process.env.MAPBOX_TOKEN
  const res = await fetch(
    `https://api.mapbox.com/geocoding/v5/mapbox.places/${coordinates[1]},${coordinates[0]}.json?access_token=${mapboxToken}&language=de&types=address,locality,poi`,
  )
  const resData = (await res.json()) as ResData
  if (!resData.features?.length) return undefined

  return resData.features[0].place_name_de
}

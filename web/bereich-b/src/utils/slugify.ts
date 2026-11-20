export const slugify = (raw: string, inPlace = false) => {
  const res = raw
    .toLowerCase()
    .replaceAll('ä', 'ae')
    .replaceAll('ö', 'oe')
    .replaceAll('ü', 'ue')
    .replaceAll('ß', 'ss')
    .replaceAll(/[^A-Za-z0-9]+/g, '-')
  return inPlace ? res : res.replaceAll(/^-+|-+$/g, '')
}

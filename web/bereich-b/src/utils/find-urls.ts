export const findUrls = (haystack: string) => {
  const urlRegex = /^(https?:\/\/)?((([a-zA-Z0-9-]+)\.)+[a-zA-Z]{2,})(:\d+)?(\/\S*)?$/g
  const urls = []
  for (const match of haystack.matchAll(urlRegex)) {
    urls.push(match[0])
  }
  return urls
}

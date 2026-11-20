import { XMLBuilder, XMLParser } from 'fast-xml-parser'

export const ikissXmlBuilder = new XMLBuilder()
export const ikissXmlParser = new XMLParser({
  stopNodes: ['*.data_content'],
})

export function stripCdata(content: string): string {
  return content.replace(/<!\[CDATA\[/g, '').replace(/\]\]>/g, '')
}

// Only an explicit iKISS release flag counts as released (freigeschaltet);
// missing or any other value means the article is not imported.
export const isReleased = (release: unknown): boolean => release === true || release === 'true'

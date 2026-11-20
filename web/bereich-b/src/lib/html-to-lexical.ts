/**
 * Shared HTML → Lexical conversion utility.
 *
 * Replaces the per-importer htmlToSlate converters with Payload v3's
 * native convertHTMLToLexical.
 */
import {
  convertHTMLToLexical,
  editorConfigFactory,
  type SanitizedServerEditorConfig,
} from '@payloadcms/richtext-lexical'
import { JSDOM } from 'jsdom'
import { type SanitizedConfig } from 'payload'

let cachedEditorConfig: SanitizedServerEditorConfig | null = null

/**
 * Get or create the default Lexical editor config.
 * Caches the result for repeated calls.
 */
export async function getDefaultEditorConfig(config: SanitizedConfig) {
  if (!cachedEditorConfig) {
    cachedEditorConfig = await editorConfigFactory.default({ config })
  }
  return cachedEditorConfig
}

/**
 * Convert an HTML string to Lexical richText JSON.
 *
 * @param html - The HTML content to convert
 * @param editorConfig - A sanitized Lexical editor config
 * @returns Lexical editor state JSON ({ root: { ... } })
 */
export function htmlToLexical(html: string, editorConfig: SanitizedServerEditorConfig) {
  return convertHTMLToLexical({ editorConfig, html, JSDOM })
}

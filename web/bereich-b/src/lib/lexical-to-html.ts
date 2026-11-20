import type { SerializedEditorState } from '@payloadcms/richtext-lexical/lexical'
import { convertLexicalToHTML } from '@payloadcms/richtext-lexical/html'

const isEditorState = (value: unknown): value is SerializedEditorState =>
  typeof value === 'object' && value !== null && 'root' in value

/** Converts a Lexical editor state to an HTML string, returning '' for empty or non-Lexical input. */
export const lexicalToHtml = (value: unknown): string => {
  if (!isEditorState(value)) return ''
  try {
    return convertLexicalToHTML({ data: value, disableContainer: true }).trim()
  } catch {
    return ''
  }
}

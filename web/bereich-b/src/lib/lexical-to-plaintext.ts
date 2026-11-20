import type { SerializedEditorState } from '@payloadcms/richtext-lexical/lexical'
import { convertLexicalToPlaintext } from '@payloadcms/richtext-lexical/plaintext'

const isEditorState = (value: unknown): value is SerializedEditorState =>
  typeof value === 'object' && value !== null && 'root' in value

/** Converts a Lexical editor state to plain text, returning '' for empty or non-Lexical input. */
export const lexicalToPlaintext = (value: unknown): string => {
  if (!isEditorState(value)) return ''
  try {
    return convertLexicalToPlaintext({ data: value }).trim()
  } catch {
    return ''
  }
}

type Block = { blockType?: string; content?: unknown }

/** Plain text of the first `rich-text` block in a Payload blocks array, or '' if none. */
export const firstRichTextBlockPlaintext = (
  blocks: readonly Block[] | null | undefined,
): string => {
  const block = blocks?.find((b) => b?.blockType === 'rich-text')
  return lexicalToPlaintext(block?.content)
}

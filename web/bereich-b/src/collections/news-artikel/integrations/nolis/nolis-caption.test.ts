import { describe, expect, test } from 'vitest'
import { extractNolisImageCaption } from './nolis-caption'

describe('extractNolisImageCaption', () => {
  test('leaves content without a caption unchanged', () => {
    const html = 'Ein normaler Meldungstext.<br />Mit einer zweiten Zeile.'

    expect(extractNolisImageCaption(html, true)).toEqual({
      contentHtml: html,
    })
  })

  test.each(['<br>', '<br/>', '<br />'])(
    'extracts one trailing photo credit separated by %s',
    (separator) => {
      const html = `Ein normaler Meldungstext.${separator}${separator}Foto: Peter Jahn`

      expect(extractNolisImageCaption(html, true)).toEqual({
        contentHtml: 'Ein normaler Meldungstext.',
        caption: 'Foto: Peter Jahn',
      })
    },
  )

  test('extracts a descriptive caption containing a copyright marker', () => {
    const html =
      'Ein normaler Meldungstext.<br><br>Gespannt schauen die Kinder dem Künstler zu. © Foto: Peter Jahn'

    expect(extractNolisImageCaption(html, true)).toEqual({
      contentHtml: 'Ein normaler Meldungstext.',
      caption: 'Gespannt schauen die Kinder dem Künstler zu. © Foto: Peter Jahn',
    })
  })

  test('recognizes a NOLIS copyright marker without preceding whitespace', () => {
    const html = [
      'Ein normaler Meldungstext.',
      'Bürgermeister und Ortsbrandmeister übergeben den Schlüssel.© Foto: Peter Jahn',
      'Die Jugendfeuerwehr übernimmt den Wimpel.© Foto: Peter Jahn',
    ].join('<br><br>')

    expect(extractNolisImageCaption(html, true)).toEqual({
      contentHtml: 'Ein normaler Meldungstext.',
      caption: 'Bürgermeister und Ortsbrandmeister übergeben den Schlüssel.© Foto: Peter Jahn',
    })
  })

  test('extracts a trailing caption paragraph', () => {
    const html = '<p>Ein normaler Meldungstext.</p><p>Text und Fotos: © Beispiel, 2026</p>'

    expect(extractNolisImageCaption(html, true)).toEqual({
      contentHtml: '<p>Ein normaler Meldungstext.</p>',
      caption: 'Text und Fotos: © Beispiel, 2026',
    })
  })

  test('does not treat a mention of a photo in body text as a caption', () => {
    const html =
      'Im Text wird ein Foto aus dem Stadtarchiv beschrieben.<br><br>Danach folgt weiterer Inhalt.'

    expect(extractNolisImageCaption(html, true)).toEqual({
      contentHtml: html,
    })
  })

  test('removes a caption without assigning it when no preview image exists', () => {
    const html = 'Ein normaler Meldungstext.<br><br>Foto: Peter Jahn'

    expect(extractNolisImageCaption(html, false)).toEqual({
      contentHtml: 'Ein normaler Meldungstext.',
    })
  })

  test('assigns the first and removes all trailing image captions', () => {
    const html = [
      'Ein normaler Meldungstext.',
      'Bild 1: Übergabe des Fahrzeugs. © Foto: Peter Jahn',
      'Bild 2: Die Jugendfeuerwehr. © Foto: Peter Jahn',
    ].join('<br><br>')

    expect(extractNolisImageCaption(html, true)).toEqual({
      contentHtml: 'Ein normaler Meldungstext.',
      caption: 'Bild 1: Übergabe des Fahrzeugs. © Foto: Peter Jahn',
    })
  })

  test('removes all trailing caption paragraphs and assigns the first one', () => {
    const html = [
      '<p>Ein normaler Meldungstext.</p>',
      '<p>Bild 1: Übergabe des Fahrzeugs.</p>',
      '<p>Bild 2: Die Jugendfeuerwehr.</p>',
    ].join('')

    expect(extractNolisImageCaption(html, true)).toEqual({
      contentHtml: '<p>Ein normaler Meldungstext.</p>',
      caption: 'Bild 1: Übergabe des Fahrzeugs.',
    })
  })

  test('supports a caption inside a paragraph with line breaks', () => {
    const html = '<p>Ein normaler Meldungstext.<br><br>Bildnachweis: Stadtarchiv</p>'

    expect(extractNolisImageCaption(html, true)).toEqual({
      contentHtml: '<p>Ein normaler Meldungstext.</p>',
      caption: 'Bildnachweis: Stadtarchiv',
    })
  })

  test('extracts a name-credited caption from the middle of the article', () => {
    const html = [
      'Erster Absatz.',
      'Zweiter Absatz.',
      'Die Gruppe vor dem Start der Wanderung auf der Treppe hinter dem Rathaus.© Peter Jahn',
      'Dritter Absatz.',
    ].join('<br /><br />')

    expect(extractNolisImageCaption(html, true)).toEqual({
      contentHtml: 'Erster Absatz.<br /><br />Zweiter Absatz.<br /><br />Dritter Absatz.',
      caption:
        'Die Gruppe vor dem Start der Wanderung auf der Treppe hinter dem Rathaus.© Peter Jahn',
    })
  })

  test('assigns only the first of several captions glued into one block', () => {
    const html = [
      'Erster Absatz.',
      'Die Gruppe auf der Treppe.© Peter Jahn Am &quot;Café&quot; führen die Gäste Gespräche© Peter Jahn',
      'Weiterer Absatz.',
    ].join('<br /><br />')

    expect(extractNolisImageCaption(html, true)).toEqual({
      contentHtml: 'Erster Absatz.<br /><br />Weiterer Absatz.',
      caption: 'Die Gruppe auf der Treppe.© Peter Jahn',
    })
  })

  test('assigns only the first of several glued captions with a Bild credit', () => {
    const html = [
      'Erster Absatz.',
      'Die Gruppe auf der Treppe.© Bild: Peter Jahn Am Café führen die Gäste Gespräche© Bild: Peter Jahn',
      'Weiterer Absatz.',
    ].join('<br /><br />')

    expect(extractNolisImageCaption(html, true)).toEqual({
      contentHtml: 'Erster Absatz.<br /><br />Weiterer Absatz.',
      caption: 'Die Gruppe auf der Treppe.© Bild: Peter Jahn',
    })
  })

  test('extracts a credit-only caption', () => {
    const html = 'Erster Absatz.<br /><br />© Anke Hettwer<br /><br />Weiterer Absatz.'

    expect(extractNolisImageCaption(html, true)).toEqual({
      contentHtml: 'Erster Absatz.<br /><br />Weiterer Absatz.',
      caption: '© Anke Hettwer',
    })
  })

  test('does not treat a copyright mention followed by more than a credit as a caption', () => {
    const html =
      'Erster Absatz.<br /><br />Die Stadt weist darauf hin, dass © 2026 Stadt Hessisch Oldendorf gilt und alle Rechte an den Inhalten vorbehalten bleiben, weshalb eine Weitergabe nicht erlaubt ist.<br /><br />Letzter Absatz.'

    expect(extractNolisImageCaption(html, true)).toEqual({ contentHtml: html })
  })

  test('extracts a credit-ending paragraph of exactly 600 characters', () => {
    const paragraph = `${'a'.repeat(600 - '.© Peter Jahn'.length)}.© Peter Jahn`
    const html = `Erster Absatz.<br /><br />${paragraph}<br /><br />Letzter Absatz.`

    expect(paragraph).toHaveLength(600)
    expect(extractNolisImageCaption(html, true)).toEqual({
      contentHtml: 'Erster Absatz.<br /><br />Letzter Absatz.',
      caption: paragraph,
    })
  })

  test('keeps a credit-ending paragraph longer than 600 characters as body text', () => {
    const paragraph = `${'a'.repeat(601 - '.© Peter Jahn'.length)}.© Peter Jahn`
    const html = `Erster Absatz.<br /><br />${paragraph}<br /><br />Letzter Absatz.`

    expect(paragraph).toHaveLength(601)
    expect(extractNolisImageCaption(html, true)).toEqual({ contentHtml: html })
  })

  test('keeps the body text of a paragraph that ends in a copyright credit after line breaks', () => {
    const html = '<p>Der eigentliche Artikeltext.<br><br>© Foto: Peter Jahn</p>'

    expect(extractNolisImageCaption(html, true)).toEqual({
      contentHtml: '<p>Der eigentliche Artikeltext.</p>',
      caption: '© Foto: Peter Jahn',
    })
  })

  test('keeps a paragraph with a copyright mention in the middle of the text', () => {
    const html =
      '<p>Erster Absatz.</p><p>Vor dem Bild. © Foto: Peter Jahn Danach geht der Text weiter.</p>'

    expect(extractNolisImageCaption(html, true)).toEqual({ contentHtml: html })
  })

  test('keeps a closing sentence that mentions a copyright marker as body text', () => {
    const html =
      'Ein normaler Text.<br /><br />Wie immer gilt: © Foto bitte nicht kopieren, danke für Ihr Verständnis.'

    expect(extractNolisImageCaption(html, true)).toEqual({ contentHtml: html })
  })

  test('keeps the full credit when a marked credit names several people', () => {
    const html =
      'Erster Absatz.<br /><br />Die Gruppe.© Foto: Peter Jahn und Anke Hettwer<br /><br />Letzter Absatz.'

    expect(extractNolisImageCaption(html, true)).toEqual({
      contentHtml: 'Erster Absatz.<br /><br />Letzter Absatz.',
      caption: 'Die Gruppe.© Foto: Peter Jahn und Anke Hettwer',
    })
  })

  test('keeps a name-only credit with more than two words as body text', () => {
    const html =
      'Erster Absatz.<br /><br />Die Gruppe.© Peter Jahn und Anke Hettwer<br /><br />Letzter Absatz.'

    expect(extractNolisImageCaption(html, true)).toEqual({ contentHtml: html })
  })

  test('keeps the first part as body text even when it ends in a credit', () => {
    const html = 'Vor dem Start.© Peter Johnson<br /><br />Ein ganz normaler Text.'

    expect(extractNolisImageCaption(html, true)).toEqual({ contentHtml: html })
  })

  test('does not remove all content when the only paragraph looks like a caption', () => {
    const html = '<p>Foto: Peter Jahn</p>'

    expect(extractNolisImageCaption(html, true)).toEqual({ contentHtml: html })
  })

  test('does not split block content at line breaks when no caption paragraph is found', () => {
    const html = '<p>Intro.<br>Bild: Max</p><p>Normaler Text.</p>'

    expect(extractNolisImageCaption(html, true)).toEqual({ contentHtml: html })
  })

  test('handles empty content', () => {
    expect(extractNolisImageCaption('', true)).toEqual({
      contentHtml: '',
    })
  })
})

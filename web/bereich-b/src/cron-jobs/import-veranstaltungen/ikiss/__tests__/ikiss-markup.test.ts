import { JSDOM } from 'jsdom'
import { describe, expect, it } from 'vitest'
import { renderIkissElements } from '../ikiss-markup'

const render = (html: string) => {
  const { body } = new JSDOM(html).window.document
  renderIkissElements(body)
  return body
}

const normalizeWhitespace = (text: string | null) => (text ?? '').replace(/\s+/g, ' ').trim()

// Tag shapes as delivered by the LK iKISS API (live events and news, surveyed 2026-11-19).
describe('iKISS markup rendering', () => {
  it('renders a mail link as a mailto anchor', () => {
    const body = render(
      '<p>Per Mail <ikiss i_ma="geste@impuls-hamelnpyrmont.de" i_ms="" i_tp="3" i_lt="geste@impuls-hamelnpyrmont.de" /></p>',
    )

    const anchor = body.querySelector('a')
    expect(anchor?.getAttribute('href')).toBe('mailto:geste@impuls-hamelnpyrmont.de')
    expect(anchor?.textContent).toBe('geste@impuls-hamelnpyrmont.de')
  })

  it('renders an inline image as an img', () => {
    const body = render(
      '<ikiss i_mod="med" i_tv="2561.50.1" i_id="3767.3497.1" i_sort="0" i_sm="0" i_la="1" i_nonpar="0" i_tp="22" />',
    )

    expect(body.querySelector('img')?.getAttribute('src')).toBe('3767.3497.1')
  })

  it('renders a page link as its link text', () => {
    const body = render(
      '<p>Mehr <ikiss i_tp="4" i_mod="tx" i_lt="hier" i_autowidth="0" i_id="3767.1604.1" i_par="kuo=2&#30;sub=0" i_setnav="0" />.</p>',
    )

    expect(normalizeWhitespace(body.textContent)).toBe('Mehr hier.')
  })

  it('renders an external link as its link text', () => {
    const body = render('<p>Siehe <ikiss i_tp="6" i_lt="www.messe-weserbergland.de" /></p>')

    expect(normalizeWhitespace(body.textContent)).toBe('Siehe www.messe-weserbergland.de')
  })

  it('renders a media link as its link text', () => {
    const body = render(
      '<p>Programm <ikiss i_url="3767.1190.1" i_lt="&quot;Akti(F)&quot;" i_ta="_blank" i_autowidth="0" i_tp="4" /> gefördert.</p>',
    )

    expect(normalizeWhitespace(body.textContent)).toBe('Programm "Akti(F)" gefördert.')
  })

  it('does not leak a tag whose link text holds markup', () => {
    const body = render(
      '<p>gef&ouml;rdert.&nbsp;<ikiss i_url="3767.1190.1" i_tp="4" i_ta="_blank" i_lt="<br>" /></p>',
    )

    expect(normalizeWhitespace(body.textContent)).toBe('gefördert.')
  })
})

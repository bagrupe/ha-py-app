import { JSDOM } from 'jsdom'
import { describe, expect, test } from 'vitest'
import { splitHtmlAtImages } from '../split-html-at-images'

const split = (html: string) => splitHtmlAtImages(new JSDOM(html).window.document)

describe('splitHtmlAtImages', () => {
  test('splits at images nested in wrappers and drops the emptied wrappers', () => {
    expect(split('<div><p>a</p><p><img src="/1_2_3.jpg"></p><p>b</p></div>')).toEqual([
      { type: 'html', value: '<div><p>a</p></div>' },
      { type: 'image', src: '/1_2_3.jpg' },
      { type: 'html', value: '<div><p>b</p></div>' },
    ])
  })

  test('replaces a link that only wraps an image', () => {
    expect(split('<p>a</p><a href="/x"><img src="/1_2_3.jpg"></a><p>b</p>')).toEqual([
      { type: 'html', value: '<p>a</p>' },
      { type: 'image', src: '/1_2_3.jpg' },
      { type: 'html', value: '<p>b</p>' },
    ])
  })

  test('keeps empty table cells so columns stay aligned', () => {
    const table = '<table><tbody><tr><td>A</td><td></td><td>C</td></tr></tbody></table>'

    expect(split(`${table}<p>x</p><img src="/1_2_3.jpg"><p>y</p>`)).toEqual([
      { type: 'html', value: `${table}<p>x</p>` },
      { type: 'image', src: '/1_2_3.jpg' },
      { type: 'html', value: '<p>y</p>' },
    ])
    expect(split(table)).toEqual([{ type: 'html', value: table }])
  })
})

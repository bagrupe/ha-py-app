/**
 * Test fixtures derived from real iKISS-imported articles in the database.
 *
 * HTML fixtures are reconstructed from Slate output of real articles.
 * XML fixtures wrap the HTML in an iKISS API response envelope.
 */

// ─── HTML fixtures ───────────────────────────────────────────────

/**
 * Based on article 3767.1689.1 — "B 83: Vollsperrung der Fischbecker Landstraße"
 * 4 paragraphs, no inline marks. Baseline for plain text import.
 */
export const plainTextArticleHtml = [
  '<p>Das teilt die Niedersächsische Landesbehörde für Straßenbau und Verkehr in Hameln mit.</p>',
  '<p>Grund für die Arbeiten ist die notwendige Erneuerung der Deckschicht aufgrund mehrerer Absackungen. Der gesperrte Bereich beginnt auf Höhe der Abwasserbetriebe Weserbergland (Kreuzungsbereich) und erstreckt sich auf einer Länge von etwa 250 Metern Richtung stadteinwärts bis kurz vor die Tankstelle.</p>',
  '<p>Die Umleitungsstrecke verläuft auf der B 83 Richtung Fischbeck, Hessisch Oldendorf, von dort in Richtung Lachem, Haverbeck und von dort auf die Klütstraße im Hamelner Westen und in die andere Richtung.</p>',
  '<p>Die Landesbehörde für Straßenbau und Verkehr bittet alle Anwohnenden, Gewerbetreibenden und Verkehrsteilnehmenden um Verständnis.</p>',
].join('')

/**
 * Based on article 3767.1703.1 — "LieblingsbusfahrerIn gesucht!"
 * 3 paragraphs with an <a target="_blank"> link in the third paragraph, text after the link.
 */
export const articleWithLinkHtml = [
  '<p>Ob jemand selbst in stressigen Situationen gelassen bleibt und stets einen freundlichen Spruch parat hat oder schon früh am Morgen mit guter Laune und Gesang den ganzen Bus zum Schmunzeln bringt – genau solche Geschichten sind gefragt.</p>',
  '<p>Noch bis zum 31. Mai 2026 können Fahrgäste ihre schönsten Bus-Erlebnisse einreichen und gleichzeitig ihre Favoriten vorschlagen. „Wir sind stolz auf unsere Busfahrerinnen und Busfahrer, die ihren Beruf mit Engagement und Begeisterung ausüben, und sind gespannt auf viele spannende und interessante Geschichten", sagt Geschäftsführer Holger Waldhausen.</p>',
  '<p>Eine Jury wählt anschließend aus allen Einsendungen die eindrucksvollsten Beiträge aus und kürt die Gewinner. Weitere Informationen sowie das Kontaktformular gibt es unter <a href="/redirect.phtml?extlink=1&amp;La=1&amp;url_fid=3767.824.1" target="_blank">www.lieblingsbusfahrerin.de</a>.</p>',
].join('')

/**
 * Based on article 3767.1702.1 — "Eltern zeigen großes Interesse an IGS Hessisch Oldendorf"
 * Multiple paragraphs with <strong> and <br> line breaks inside paragraphs.
 */
export const articleWithBoldHtml = [
  '<p>Im Rahmen der Veranstaltung wurde deutlich, welche Ziele mit der Gründung der IGS Hessisch Oldendorf verbunden sind.</p>',
  '<p>Weitere Informationen zur Anmeldung für die IGS Hessisch Oldendorf sind online abrufbar unter:<br><strong>www.oberschule-ho.de/schulanmeldung-jahrgang-5</strong></p>',
  '<p>Fragen zur Anmeldung beantwortet außerdem das Sekretariat der Schule unter der Telefonnummer<br><strong>030 00000000</strong>.</p>',
  '<p>Für weitergehende Fragen, auch zum schulischen Konzept, steht der Leiter der Planungsgruppe, <strong>Herr Sieker</strong>, per E-Mail zur Verfügung:<br><strong>contact-682c14a5@example.com</strong></p>',
].join('')

/**
 * Based on article 3767.1646.1 — "Verdienstorden der Bundesrepublik Deutschland an Dieter Hainer"
 * Leading <em> paragraph followed by plain <p> nodes — tests that content after <em> is preserved.
 */
export const articleWithItalicHtml = [
  '<p><em>Am 20. Februar 2026 hat Landrat Dirk Adomat Dieter Hainer im Auftrag des Bundespräsidenten den Verdienstorden der Bundesrepublik Deutschland verliehen. Mit der Auszeichnung wird sein langjähriges ehrenamtliches Engagement für die Gemeinschaft im Landkreis Hameln-Pyrmont gewürdigt.</em></p>',
  '<p>Seit 2007 prägt Dieter Hainer maßgeblich die Entwicklung der Tafel Bad Münder. Als Mitbegründer war er von Beginn an am Aufbau der Einrichtung beteiligt.</p>',
  '<p>Neben der Organisation der Lebensmittelausgabe engagiert sich Hainer in vielfältiger Weise für die Weiterentwicklung der Tafel.</p>',
  '<p>Mit der Verleihung des Verdienstordens der Bundesrepublik Deutschland wird dieses außergewöhnliche Engagement nun öffentlich gewürdigt.</p>',
].join('')

/**
 * Based on article 3767.1588.1 — "Winterdienst als anspruchsvolles Unterfangen"
 * 10+ paragraphs, <em> only in the last two paragraphs — tests italic at end of long content.
 */
export const articleWithItalicAtEndHtml = [
  '<p>Die letzten Tage und Wochen haben den Autofahrern im Weserbergland viel abverlangt.</p>',
  '<p>Um die Bedingungen so sicher wie nur möglich zu gestalten, arbeiten die Beschäftigten der vier Straßenmeistereien weit über dem normalen Arbeitspensum.</p>',
  '<p>Wenn draußen noch Dunkelheit herrscht und viele Menschen schlafen, beginnt für sie im Winterdienst bereits ein langer und anstrengender Arbeitstag.</p>',
  '<p>Zur Einordnung: Zum Geschäftsbereich Hameln gehören die Landkreise Hameln-Pyrmont, Holzminden und Schaumburg.</p>',
  '<p>Mit schweren Räumfahrzeugen und Streuern sind die Mitarbeiter oft stundenlang unterwegs.</p>',
  '<p>Mit eigenen und auch Fremdfahrzeugen werden Bundes-, Landes- und Kreisstraßen und auch Radwege bearbeitet.</p>',
  '<p>Trotz aller sorgfältiger Planung und Einsatzbereitschaft gilt auch, dass der Winterdienst nicht überall gleichzeitig sein kann.</p>',
  '<p>Der Winterdienst leistet einen unverzichtbaren Beitrag zur Verkehrssicherheit.</p>',
  '<p>Ergänzend: Aufgrund von Schneeverwehungen ist die Kreisstraße 52 zwischen Eichenborn und Neersen bis Montag für den Verkehr vollgesperrt.</p>',
  '<p></p>',
  '<p><em>Bildunterschriften:</em></p>',
  '<p><em>Bild 1 und 2: Auch die Mitarbeiter der Straßenmeisterei Hameln sind bei Tag und auch bei Nacht im Einsatz.</em></p>',
].join('')

/**
 * Based on article 3767.1656.1 — "KAW: Grünschnitt-Mobil startet wieder"
 * <strong> lead text, <ul><li> list, then <p> paragraphs after the list.
 */
export const articleWithListHtml = [
  '<p><strong>Am 02. März startet das KAW-Grünmobil in die Saison 2026. Auch in diesem Jahr bietet die KAW acht Mal die Abholung von Grünschnitt an den Grundstücken an.</strong></p>',
  '<p>Für einen reibungslosen Ablauf der Abfuhr bittet die KAW um die Berücksichtigung einiger wichtiger Hinweise zur Bereitstellung des Grünschnitts:</p>',
  '<ul>',
  '<li>Geeignete Grünabfälle, wie beispielsweise Rasenschnitt oder Laub, bitte in leicht zu entleerenden, festen und wiederverwendbaren Behältnissen bereitstellen.</li>',
  '<li>Anderes Grünmaterial, wie Äste und Zweige, bitte zu maximal 1 Meter langen Bündeln zusammenschnüren.</li>',
  '<li>Größere Wurzeln und Erde gehören genau wie Bioabfälle aus dem Haushalt nicht zum Grünschnitt.</li>',
  '<li>Eine Entleerung von Säcken, Springsäcken oder Bigbags erfolgt aus Arbeitsschutzgründen nicht!</li>',
  '</ul>',
  '<p>Fragen beantwortet der Kundenservice der KAW unter contact-170fde41@example.com oder unter der Tel.-Nummer 030 00000000.</p>',
  '<p>Montag bis Donnerstag von 7.30 bis 17.00 Uhr und Freitag von 7.30 bis 16.00 Uhr.</p>',
].join('')

/**
 * Based on article 3767.1643.1 — "Tag des Gesundheitsamtes 2026"
 * The most comprehensive fixture: <em>, <strong>, <ul><li>, <a target="_blank">, <br>.
 */
export const mixedArticleHtml = [
  '<p>So vielfältig wie Herkunft, Kultur, Alter und Alltag der Menschen in unserem Landkreis sind, ist auch ihr persönliches Verständnis von Gesundheit. Um diese Arbeit sichtbar und erlebbar zu machen, öffnet das Gesundheitsamt am Nachmittag des 19. März 2026 seine Türen. Unter dem Motto <em>Vielfalt für Gesundheit</em> sind alle Interessierten herzlich eingeladen, auf Entdeckungsreise zu gehen.</p>',
  '<p>Unser Gesundheitsamt arbeitet jeden Tag daran, für alle Menschen ein gesundes Lebensumfeld zu schaffen.</p>',
  '<p><strong>Besucherinnen und Besucher erwartet ein abwechslungsreiches Angebot</strong></p>',
  '<p>Neben Informationen rund um die einzelnen Teams und ihre Aufgaben erwartet die Besucherinnen und Besucher ein vielfältiges Mitmach- und Aktionsangebot:</p>',
  '<ul>',
  '<li>Gesundheitsamt-Rallye mit Verlosung</li>',
  '<li>Mini-Gesundheitscheck</li>',
  '<li>DKMS-Typisierungsaktion</li>',
  '<li>Kreativstation, Bewegungsbingo und Wurfbude für Kinder und vieles mehr.</li>',
  '</ul>',
  '<p>Die Teams stehen den ganzen Nachmittag über bereit, um Fragen zu beantworten und über Angebote zu informieren.</p>',
  '<p>Wann? 15:00–18:00 Uhr<br>Wo? Gesundheitsamt Hameln-Pyrmont, Hugenottenstr. 6 31785 Hameln</p>',
  '<p>Das Gesundheitsamt freut sich auf alle, die neugierig sind.</p>',
  '<p><a href="/media/custom/3767_3083_1.PDF?1771414354" target="_blank">Tag des Gesundheitsamtes Flyer</a> (PDF, 879 kB)</p>',
].join('')

// ─── XML envelope helper ─────────────────────────────────────────

function wrapInIkissXml(
  html: string,
  opts: { title?: string; date?: string; cdata?: boolean } = {},
): string {
  const { title = 'Test Artikel', date = '2026-01-01', cdata = false } = opts
  const content = cdata ? `<![CDATA[${html}]]>` : html
  return [
    '<?xml version="1.0"?>',
    '<ikiss>',
    '  <result>',
    '    <tcontent>',
    `      <data_content>${content}</data_content>`,
    `      <date>${date}</date>`,
    '      <release>true</release>',
    '      <tLayout/>',
    '      <tTpFields>',
    `        <title>${title}</title>`,
    '        <data_content></data_content>',
    '      </tTpFields>',
    '    </tcontent>',
    '  </result>',
    '</ikiss>',
  ].join('\n')
}

// ─── XML fixtures (no CDATA) ─────────────────────────────────────

export const plainTextArticleXml = wrapInIkissXml(plainTextArticleHtml, {
  title: 'B 83: Vollsperrung der Fischbecker Landstraße',
  date: '2026-03-19',
})

export const articleWithLinkXml = wrapInIkissXml(articleWithLinkHtml, {
  title: 'LieblingsbusfahrerIn gesucht!',
  date: '2026-03-20',
})

export const articleWithBoldXml = wrapInIkissXml(articleWithBoldHtml, {
  title: 'Eltern zeigen großes Interesse an IGS Hessisch Oldendorf',
  date: '2026-03-20',
})

export const articleWithItalicXml = wrapInIkissXml(articleWithItalicHtml, {
  title: 'Verdienstorden der Bundesrepublik Deutschland an Dieter Hainer',
  date: '2026-02-20',
})

export const articleWithItalicAtEndXml = wrapInIkissXml(articleWithItalicAtEndHtml, {
  title: 'Winterdienst als anspruchsvolles Unterfangen',
  date: '2026-01-08',
})

export const articleWithListXml = wrapInIkissXml(articleWithListHtml, {
  title: 'KAW: Grünschnitt-Mobil startet wieder',
  date: '2026-02-27',
})

export const mixedArticleXml = wrapInIkissXml(mixedArticleHtml, {
  title: 'Tag des Gesundheitsamtes 2026',
  date: '2026-02-19',
})

// ─── XML fixtures (with CDATA) ───────────────────────────────────

export const mixedArticleCdataXml = wrapInIkissXml(mixedArticleHtml, {
  title: 'Tag des Gesundheitsamtes 2026',
  date: '2026-02-19',
  cdata: true,
})

export const articleWithItalicCdataXml = wrapInIkissXml(articleWithItalicHtml, {
  title: 'Verdienstorden der Bundesrepublik Deutschland an Dieter Hainer',
  date: '2026-02-20',
  cdata: true,
})

// ─── XML fixture (empty content) ─────────────────────────────────

export const emptyContentXml = wrapInIkissXml('', {
  title: 'Leerer Artikel',
  date: '2026-01-01',
})

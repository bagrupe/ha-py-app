import {format} from 'date-fns';
import {asymmetricUnwrapKeyWithCache} from 'src/lib/crypto/crypto.tsx';
import type {CryptoCache} from 'src/lib/hooks/use-crypto-cache.ts';
import type {AusfuehrungFragment} from '../ausfuehrungen.generated.ts';
import {
  buildBeschreibungstextSlotsMap,
  formatVerantwortlicheGruppeLabel,
} from './ausfuehrungen-list-helpers.ts';

export const AUSFUEHRUNGEN_LIST_CSV_HEADERS = [
  'Antragseingang',
  'Antragsart',
  'Beschreibungstext',
  'Verantwortliche Gruppe',
] as const;

/**
 * Tabellenkalkulationsprogramme (Excel, LibreOffice, …) können Zellwerte, die mit
 * `=`, `+`, `-`, `@`, Tabulator oder Wagenrücklauf beginnen, als Formeln auswerten (CSV-Injection).
 * Ein führendes Apostroph erzwingt den Textmodus; Excel zeigt dieses Apostroph nicht an.
 * @see https://cheatsheetseries.owasp.org/cheatsheets/CSV_Injection_Prevention_Cheat_Sheet.html
 */
function escapeCsvFormulaInjection(value: string): string {
  const trimmedStart = value.trimStart();
  const first = trimmedStart[0];
  if (
    first === '=' ||
    first === '+' ||
    first === '-' ||
    first === '@' ||
    first === '\t' ||
    first === '\r'
  ) {
    return `'${value}`;
  }
  return value;
}

function escapeCsvCell(value: string): string {
  const normalized = escapeCsvFormulaInjection(value).replace(/\r\n/g, '\n');
  if (/[",;\n]/.test(normalized)) {
    return `"${normalized.replace(/"/g, '""')}"`;
  }
  return normalized;
}

/**
 * Erzeugt den CSV-Inhalt (UTF-8) mit derselben Spaltenlogik wie {@link AusfuehrungenList}
 * ohne die Aktions-Spalte.
 */
export async function buildAusfuehrungenListCsvContent(
  ausfuehrungen: AusfuehrungFragment[],
  organisationPrivateKey: CryptoKey,
  cryptoCache: CryptoCache,
): Promise<string> {
  const lines: string[] = [];
  lines.push(AUSFUEHRUNGEN_LIST_CSV_HEADERS.map(escapeCsvCell).join(';'));

  for (const ausfuehrung of ausfuehrungen) {
    const decryptionKey = await asymmetricUnwrapKeyWithCache(
      organisationPrivateKey,
      ausfuehrung.sharedKeyEncryptedForKommune,
      cryptoCache,
    );
    const slots = await buildBeschreibungstextSlotsMap(
      ausfuehrung,
      decryptionKey,
      cryptoCache,
    );
    const beschreibung =
      ausfuehrung.prozessVersion.beschreibungstext.evaluate(slots);

    const row = [
      format(ausfuehrung.createdAt, 'dd.MM.yyyy'),
      ausfuehrung.prozessVersion.prozess.name,
      String(beschreibung ?? ''),
      formatVerantwortlicheGruppeLabel(ausfuehrung),
    ].map(escapeCsvCell);

    lines.push(row.join(';'));
  }

  return lines.join('\r\n');
}

export function triggerCsvDownload(filename: string, content: string): void {
  const blob = new Blob([`\uFEFF${content}`], {
    type: 'text/csv;charset=utf-8',
  });
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement('a');
  anchor.href = url;
  anchor.download = filename;
  anchor.click();
  URL.revokeObjectURL(url);
}

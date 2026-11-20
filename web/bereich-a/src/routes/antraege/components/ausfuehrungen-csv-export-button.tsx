import {DownloadIcon} from '@radix-ui/react-icons';
import * as Sentry from '@sentry/react';
import {format} from 'date-fns';
import {useCallback, useState, type FC} from 'react';
import {toast} from 'react-toastify';
import {Button} from 'src/components/ui/button';
import {useAuth} from 'src/lib/context/auth/auth.tsx';
import {useCryptoCache} from 'src/lib/hooks/use-crypto-cache.ts';
import type {AusfuehrungFragment} from '../ausfuehrungen.generated.ts';
import {
  buildAusfuehrungenListCsvContent,
  triggerCsvDownload,
} from './ausfuehrungen-list-csv.ts';

export type AusfuehrungenCsvExportButtonProps = {
  ausfuehrungen: AusfuehrungFragment[];
  /**
   * Wenn gesetzt, lädt der Export alle passenden Datensätze über diese Funktion
   * (z. B. paginiert), statt nur die aktuell übergebenen {@link ausfuehrungen}.
   */
  loadAllAusfuehrungenForExport?: () => Promise<AusfuehrungFragment[]>;
  /**
   * Gesamtanzahl für die Anzeige „Export möglich“ bei {@link loadAllAusfuehrungenForExport}
   * (z. B. `totalCount` der Liste), falls die aktuelle Seite leer sein kann.
   */
  totalCountForExport?: number;
  /** Dateiname ohne Endung oder mit .csv; Standard: abgeschlossene-antraege-YYYY-MM-DD.csv */
  fileBasename?: string;
};

/**
 * Button zum Herunterladen von Ausführungen als CSV
 * (gleiche Datenspalten wie {@link AusfuehrungenList} ohne Aktionsspalte).
 * Optional können alle Datensätze per {@link loadAllAusfuehrungenForExport} geladen werden.
 */
export const AusfuehrungenCsvExportButton: FC<
  AusfuehrungenCsvExportButtonProps
> = ({
  ausfuehrungen,
  loadAllAusfuehrungenForExport,
  totalCountForExport,
  fileBasename,
}) => {
  const {organisationPrivateKey} = useAuth();
  const cryptoCache = useCryptoCache();
  const [exporting, setExporting] = useState(false);

  const handleExport = useCallback(async () => {
    if (!organisationPrivateKey) return;
    setExporting(true);
    try {
      const rows = loadAllAusfuehrungenForExport
        ? await loadAllAusfuehrungenForExport()
        : ausfuehrungen;
      if (rows.length === 0) return;
      const csv = await buildAusfuehrungenListCsvContent(
        rows,
        organisationPrivateKey,
        cryptoCache,
      );
      const base =
        fileBasename?.replace(/\.csv$/i, '') ??
        `abgeschlossene-antraege-${format(new Date(), 'yyyy-MM-dd')}`;
      triggerCsvDownload(`${base}.csv`, csv);
    } catch (e) {
      toast.error('Fehler beim exportieren der CSV-Daten');
      Sentry.captureException(e);
    } finally {
      setExporting(false);
    }
  }, [
    ausfuehrungen,
    loadAllAusfuehrungenForExport,
    organisationPrivateKey,
    cryptoCache,
    fileBasename,
  ]);

  const hasExportableRows = loadAllAusfuehrungenForExport
    ? (totalCountForExport ?? 0) > 0
    : ausfuehrungen.length > 0;

  const disabled =
    !hasExportableRows || organisationPrivateKey === undefined || exporting;

  return (
    <Button
      type='button'
      variant='outlined-secondary'
      disabled={disabled}
      onClick={() => {
        void handleExport();
      }}
      endAdornment={<DownloadIcon className='size-4' aria-hidden />}
    >
      {exporting ? 'Export …' : 'CSV exportieren'}
    </Button>
  );
};

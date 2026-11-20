import {BackofficeNutzerArt} from '../__generated__/graphql.ts';

/**
 * Prüft, ob die aktuelle Nutzerart die geforderte Nutzerart erfüllt.
 * @param ist Die aktuelle Nutzerart des Nutzers.
 * @param verlangt Die geforderte Nutzerart für eine Aktion oder Berechtigung.
 * @returns true, wenn die aktuelle Nutzerart die geforderte erfüllt, sonst false.
 */
export const matchNutzerart = (
  ist: BackofficeNutzerArt,
  verlangt: BackofficeNutzerArt,
) => {
  if (ist === BackofficeNutzerArt.Superadmin) {
    return true;
  }

  if (verlangt === BackofficeNutzerArt.Admin) {
    return ist === BackofficeNutzerArt.Admin;
  } else if (verlangt === BackofficeNutzerArt.Nutzer) {
    return (
      ist === BackofficeNutzerArt.Admin || ist === BackofficeNutzerArt.Nutzer
    );
  } else if (verlangt === BackofficeNutzerArt.Dienstleister) {
    return (
      ist === BackofficeNutzerArt.Admin ||
      ist === BackofficeNutzerArt.Nutzer ||
      ist === BackofficeNutzerArt.Dienstleister
    );
  }

  return false;
};

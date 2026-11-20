import {type UserFragment} from './auth.generated.ts';

/**
 * Prüft, ob ein Mitarbeiter einer bestimmten Gruppe angehört.
 * @param user Der Nutzer, dessen Gruppenmitgliedschaft geprüft wird.
 * @param gruppeId Die ID der Gruppe, nach der gesucht wird.
 * @returns true, wenn der Nutzer Mitglied der Gruppe ist, sonst false.
 */
export const mitarbeiterIsInGruppe = (
  user: UserFragment,
  gruppeId: string,
): boolean => 'gruppen' in user && user.gruppen.some((g) => g.id === gruppeId);

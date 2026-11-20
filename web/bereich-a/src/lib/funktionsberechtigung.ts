import {
  BackofficeNutzerArt,
  type FunktionsberechtigungInOrganisationseinheit,
  type GlobaleFunktionsberechtigung,
} from 'src/__generated__/graphql';
import {type User_BackofficeUser_Fragment} from './context/auth/auth.generated';

/**
 * Prüft, ob ein Nutzer eine bestimmte Funktionsberechtigung besitzt, entweder global oder in einer Organisationseinheit.
 * @param user Der Nutzer, dessen Berechtigungen geprüft werden.
 * @param funktionsberechtigung Die zu prüfende Funktionsberechtigung.
 * @returns true, wenn der Nutzer die Berechtigung besitzt oder keine Berechtigung angegeben ist, sonst false.
 */
export const hasFunktionsberechtigungInAnyOrganisationseinheit = (
  user: User_BackofficeUser_Fragment | null,
  funktionsberechtigung?:
    | GlobaleFunktionsberechtigung
    | FunktionsberechtigungInOrganisationseinheit
    | null,
) => {
  if (
    !funktionsberechtigung ||
    user?.art === BackofficeNutzerArt.Superadmin ||
    user?.funktionsberechtigungen?.includes(funktionsberechtigung as never) ||
    user?.organisationseinheiten?.some((o) =>
      o.funktionsberechtigungen.includes(funktionsberechtigung as never),
    )
  ) {
    return true;
  }

  return false;
};

import {useCallback} from 'react';
import {toast} from 'react-toastify';
import {PendingConfirmationReason} from 'src/__generated__/graphql';
import {Button} from 'src/components/ui/button';
import {useAuth} from 'src/lib/context/auth/auth';
import {
  importPublicKey,
  reencryptOrganisationKeyForNewUser,
} from 'src/lib/crypto/crypto';
import {mutationFailed} from 'src/lib/mutation';
import {
  type PendingUserFragment,
  useNutzendePendingConfrimationQuery,
  useUserConfirmMutation,
} from './pending-confirmation.generated';

/**
 * Komponente zur Anzeige und Bestätigung ausstehender Nutzenden-Bestätigungen.
 * Lädt ausstehende Bestätigungen, zeigt diese in einer Tabelle an und ermöglicht die Bestätigung einzelner Nutzender.
 */
export const PendingConfirmation = () => {
  const {user, personalPrivateKey} = useAuth();

  const [{data}, refetch] = useNutzendePendingConfrimationQuery();

  const nutzendePendingConfirmation =
    data?.my.__typename === 'BackofficeUser'
      ? data.my.kommune.mitarbeiterPendingConfirmation ?? []
      : [];

  const [, mutateUserConfirm] = useUserConfirmMutation();

  /**
   * Bestätigt einen ausstehenden Nutzenden und reverschlüsselt den Organisationsschlüssel für diesen.
   * @param pendingUser Der ausstehende Nutzende, der bestätigt werden soll
   */
  const confirmUser = useCallback(
    async (pendingUser: PendingUserFragment) => {
      if (
        user?.__typename !== 'BackofficeUser' ||
        !personalPrivateKey ||
        !user.organisationPrivateKey ||
        !pendingUser.publicKey
      ) {
        return;
      }

      const newOrganizationPrivateKey =
        await reencryptOrganisationKeyForNewUser(
          personalPrivateKey,
          user.organisationPrivateKey,
          await importPublicKey(pendingUser.publicKey),
        );

      const result = await mutateUserConfirm({
        input: {
          userId: pendingUser.id,
          organizationPrivateKey: newOrganizationPrivateKey,
        },
      });

      if (mutationFailed(result)) return;
      if (result.data!.userConfirm.boolean) {
        refetch({requestPolicy: 'network-only'});
        toast.success(
          `Bestätigung erfolgreich, der/die Nutzende kann sich nun anmelden.`,
        );
      } else {
        toast.error(`Fehler bei der Bestätigung`);
      }
    },
    [mutateUserConfirm, personalPrivateKey, refetch, user],
  );

  if (nutzendePendingConfirmation.length === 0) return null;

  return (
    <div className='flex flex-col gap-4'>
      <h2 className='w-full text-lg font-bold'>Ausstehende Bestätigungen</h2>

      <p className='max-w-4xl'>
        Für die Funktionen <strong>Nutzer einladen</strong> und{' '}
        <strong>Passwort vergessen</strong> ist eine Bestätigung notwendig.
      </p>

      <table className='w-full'>
        <thead className='text-left'>
          <tr>
            <th className='pb-2 pl-5 pr-12'>Vorname</th>
            <th className='pb-2 pr-20'>Nachname</th>
            <th className='pb-2'>E-Mail Adresse</th>
            <th className='pb-2'>Bestätigungsgrund</th>
            <th />
          </tr>
        </thead>
        <tbody className='border-t-2'>
          {nutzendePendingConfirmation.map((n) => (
            <tr key={n.id} className='m-4 even:bg-neutral-100'>
              <td className='py-4 pl-5'>{n.vorname}</td>
              <td>{n.nachname}</td>
              <td>{n.eMail}</td>
              <td>
                {n.pendingConfirmation ===
                  PendingConfirmationReason.PasswordReset &&
                  'Passwort geändert'}
                {n.pendingConfirmation === PendingConfirmationReason.Invited &&
                  'Eingeladen'}
              </td>
              <td>
                <div className='mr-4 flex justify-end gap-2 py-1'>
                  <Button onClick={() => confirmUser(n)}>Bestätigen</Button>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

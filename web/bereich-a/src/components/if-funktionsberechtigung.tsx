import * as Dialog from '@radix-ui/react-dialog';
import {type PropsWithChildren} from 'react';
import {useNavigate} from 'react-router';
import {
  type GlobaleFunktionsberechtigung,
  type FunktionsberechtigungInOrganisationseinheit,
} from '../__generated__/graphql.ts';
import {useAuth} from '../lib/context/auth/auth';
import {hasFunktionsberechtigungInAnyOrganisationseinheit} from '../lib/funktionsberechtigung.ts';
import {Modal} from './modal/modal.tsx';
import {Button} from './ui/button';

/**
 * Komponente, die ihre Kinder nur rendert, wenn der Nutzer die angegebene Funktionsberechtigung besitzt.
 * Optional kann bei fehlender Berechtigung ein modales Fenster angezeigt werden.
 * @param children Die darzustellenden Kind-Komponenten
 * @param funktionsberechtigung Die zu prüfende Funktionsberechtigung
 * @param modal Gibt an, ob bei fehlender Berechtigung ein modales Fenster angezeigt wird
 */
export const IfFunktionsberechtigung = ({
  children,
  funktionsberechtigung,
  modal = false,
}: PropsWithChildren<{
  funktionsberechtigung?:
    | GlobaleFunktionsberechtigung
    | FunktionsberechtigungInOrganisationseinheit
    | null;
  modal?: boolean;
}>) => {
  const {user} = useAuth();

  if (
    hasFunktionsberechtigungInAnyOrganisationseinheit(
      user,
      funktionsberechtigung,
    )
  ) {
    return children;
  }

  if (modal) {
    return (
      <FehlendeFunktionsberechtigungModal
        funktionsberechtigung={funktionsberechtigung!}
      />
    );
  }

  return null;
};

/**
 * Modal-Komponente, die anzeigt, dass die erforderliche Funktionsberechtigung fehlt.
 * @param funktionsberechtigung Die fehlende Funktionsberechtigung als String
 */
const FehlendeFunktionsberechtigungModal = ({
  funktionsberechtigung,
}: {
  funktionsberechtigung: string;
}) => {
  const navigate = useNavigate();
  const close = () => {
    navigate('/');
  };
  return (
    <div className='size-full'>
      <Dialog.Root open onOpenChange={close}>
        <Modal
          title='Nicht berechtigt'
          description={`Ihnen fehlt die Funktionsberechtigung: ${funktionsberechtigung}`}
          className='max-w-2xl'
          global
        >
          <div className='mb-2'>
            <Button onClick={close} variant='solid'>
              Zurück
            </Button>
          </div>
        </Modal>
      </Dialog.Root>
    </div>
  );
};

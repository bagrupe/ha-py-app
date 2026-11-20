import {useBlocker} from 'react-router';

/**
 * React-Hook, der das Blockieren der Navigation ermöglicht.
 * @param block Gibt an, ob die Navigation blockiert werden soll.
 */
export const useNavigationBlock = (block: boolean) => {
  const blocker = useBlocker(block);

  const unblock = (withRetry?: boolean) => {
    if (withRetry) {
      blocker.proceed?.();
    } else {
      blocker.reset?.();
    }
  };

  return {blocker, unblock};
};

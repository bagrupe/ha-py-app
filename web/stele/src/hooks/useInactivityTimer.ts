import {useEffect} from 'react';
import {useTimerActions, useTimerStore} from '../store/useCountdownStore';

// Starts the global inactivity timer on mount and resets it on any user
// interaction. When the timer expires, `onExpire` runs so the caller can
// return the kiosk to a known clean state (e.g. navigate back to /).
export const useInactivityTimer = (onExpire?: () => void) => {
  const {startTimer, resetTimer} = useTimerActions();

  useEffect(() => {
    startTimer(onExpire);

    const handleInteraction = () =>
      useTimerStore.getState().isActive ? resetTimer() : startTimer(onExpire);

    window.addEventListener('mousemove', handleInteraction);
    window.addEventListener('keydown', handleInteraction);
    window.addEventListener('click', handleInteraction);
    window.addEventListener('touchstart', handleInteraction);
    window.addEventListener('touchmove', handleInteraction);

    return () => {
      window.removeEventListener('mousemove', handleInteraction);
      window.removeEventListener('keydown', handleInteraction);
      window.removeEventListener('click', handleInteraction);
      window.removeEventListener('touchstart', handleInteraction);
      window.removeEventListener('touchmove', handleInteraction);
    };
  }, [startTimer, resetTimer, onExpire]);
};

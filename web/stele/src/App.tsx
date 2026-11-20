import {useCallback} from 'react';
import {RouterProvider} from 'react-router';
import {ControlledModal} from './components/controlled-modal/ControlledModal';
import {buildKioskHomeHref} from './context/location-context';
import {useInactivityTimer} from './hooks/useInactivityTimer';
import {router} from './router';
import {useTimerStore} from './store/useCountdownStore';
import {UrqlProvider} from './urql';

// Seconds-remaining threshold at which the "are you still here?" modal opens.
// Guarded against missing/invalid env values (e.g. "" → NaN, "0", negatives).
const configuredActivityTimerWindowThresholdSecs = Number(
  import.meta.env.VITE_ACTIVITY_TIMER_WINDOW_THRESHOLD_SECS,
);
const FALLBACK_ACTIVITY_TIMER_WINDOW_THRESHOLD_SECS = 10;
const ACTIVITY_TIMER_WINDOW_THRESHOLD_SECS =
  Number.isFinite(configuredActivityTimerWindowThresholdSecs) &&
  configuredActivityTimerWindowThresholdSecs > 0
    ? configuredActivityTimerWindowThresholdSecs
    : FALLBACK_ACTIVITY_TIMER_WINDOW_THRESHOLD_SECS;

function App() {
  return (
    <UrqlProvider>
      <AppShell />
    </UrqlProvider>
  );
}

// Hosts app-wide concerns that should outlive any single route:
// the inactivity timer and the timeout modal that floats above all pages.
function AppShell() {
  const resetKiosk = useCallback(() => {
    window.location.replace(buildKioskHomeHref());
  }, []);

  useInactivityTimer(resetKiosk);

  const isActive = useTimerStore((state) => state.isActive);
  const timeRemaining = useTimerStore((state) => state.timeRemaining);

  // Show the timeout modal if the session is active and the time remaining is less than the threshold
  const isTimeoutWindowVisible =
    isActive && timeRemaining <= ACTIVITY_TIMER_WINDOW_THRESHOLD_SECS;

  return (
    <>
      <RouterProvider router={router} />
      <ControlledModal
        open={isTimeoutWindowVisible}
        title='Sind Sie noch da?'
        buttonText='Weiter machen'
        onClickAction={() => useTimerStore.getState().actions.resetTimer()}
        description={`Da für längere Zeit keine Eingabe erfolgt ist, wird die Anwendung in ${timeRemaining} Sekunden zurückgesetzt. Möchten Sie die Sitzung fortsetzen?`}
      />
    </>
  );
}

export default App;

import {create} from 'zustand';

const configuredActivityTimerDurationSecs = Number(
  import.meta.env.VITE_ACTIVITY_TIMER_DURATION_SECS,
);
const FALLBACK_ACTIVITY_TIMER_DURATION_SECS = 120;
// Time to reach an inactive state. Defaults to 2 minutes
const ACTIVITY_TIMER_DURATION_SECS =
  Number.isFinite(configuredActivityTimerDurationSecs) &&
  configuredActivityTimerDurationSecs > 0
    ? configuredActivityTimerDurationSecs
    : FALLBACK_ACTIVITY_TIMER_DURATION_SECS;

interface TimerState {
  timeRemaining: number;
  isActive: boolean;
  actions: {
    startTimer: (onExpire?: () => void) => void;
    resetTimer: () => void;
    stopTimer: () => void;
  };
}

let timerInterval: ReturnType<typeof setInterval> | null = null;

export const useTimerStore = create<TimerState>((set, get) => ({
  timeRemaining: ACTIVITY_TIMER_DURATION_SECS,
  isActive: false,

  actions: {
    startTimer: (onExpire) => {
      // Clear existing timers
      get().actions.stopTimer();
      // Start new timer
      set({timeRemaining: ACTIVITY_TIMER_DURATION_SECS, isActive: true});
      // This runs every second
      timerInterval = setInterval(() => {
        const remaining = get().timeRemaining;

        if (remaining <= 0) {
          get().actions.stopTimer();
          // Arbitrary action that can be executed when the timer finishes
          if (onExpire) onExpire();
        } else {
          set({timeRemaining: remaining - 1});
        }
      }, 1000);
    },

    resetTimer: () => {
      // Reset the counter (the interval is already running)
      set({timeRemaining: ACTIVITY_TIMER_DURATION_SECS});
    },

    stopTimer: () => {
      // Clear the interval if the timer is running
      if (timerInterval) clearInterval(timerInterval);
      set({isActive: false, timeRemaining: ACTIVITY_TIMER_DURATION_SECS});
    },
  },
}));

// Exports a hook for actions to avoid unnecessary re-renders
export const useTimerActions = () => useTimerStore((state) => state.actions);

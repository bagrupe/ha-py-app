const INTERVAL_IN_MILLISECONDS = 3000; // 3 seconds

// berechnet die Anzahl an Millisekunden, die bis zum nächsten konkreten Zeitpunkt gemäß eines festgelegten Intervalls verbleiben
export const getDelay = () => {
  const now = Date.now();
  const nextRoundedTime =
    Math.ceil(now / INTERVAL_IN_MILLISECONDS) * INTERVAL_IN_MILLISECONDS;
  const delay = nextRoundedTime - now;
  return delay;
};

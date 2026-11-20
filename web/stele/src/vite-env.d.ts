/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_CAROUSEL_SLIDER_AUTOPLAY_DELAY_MS?: string;
  readonly VITE_ACTIVITY_TIMER_DURATION_SECS?: string;
  readonly VITE_ACTIVITY_TIMER_WINDOW_THRESHOLD_SECS?: string;
  readonly VITE_KOMMUNE_ID?: string;
  readonly VITE_UNTEREINHEITEN_IDS?: string;
  readonly VITE_AKTUELLES_NEWS_LIMIT?: string;
  readonly VITE_AUFRUFE_QR_ENABLED?: string;
  readonly VITE_SHOW_POI_MAP?: string;
  readonly VITE_POI_MAP_CARD_IMAGE?: string;
}

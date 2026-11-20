import * as Sentry from '@sentry/react';
import {StrictMode} from 'react';
import {createRoot} from 'react-dom/client';
import 'leaflet/dist/leaflet.css';
import 'leaflet.markercluster/dist/MarkerCluster.css';
import 'leaflet.markercluster/dist/MarkerCluster.Default.css';
import './index.css';
import App from './App.tsx';
import generatedGitInfo from './generatedGitInfo.json';
import {SENTRY_DSN} from './sentry.ts';

Sentry.init({
  dsn: import.meta.env.VITE_SENTRY_DSN || SENTRY_DSN,
  enabled: !import.meta.env.DEV,
  environment: generatedGitInfo.environment,
  release: generatedGitInfo.release,
});

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>,
);

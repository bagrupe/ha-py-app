/**
 * Gibt zurück, ob die LageHelfer-Demo-Daten gesät werden sollen.
 * Opt-in über ENABLE_LAGEHELFER_SEED (Standard: aus); die Variable wird nur für Dev/Staging gesetzt.
 * (NODE_ENV ist in allen ausgelieferten Images `production` und taugt daher nicht zur Unterscheidung.)
 */
export const isLageHelferSeedEnabled = (env?: { ENABLE_LAGEHELFER_SEED?: string }): boolean => {
  const { ENABLE_LAGEHELFER_SEED = process.env['ENABLE_LAGEHELFER_SEED'] } = env ?? {}
  return ENABLE_LAGEHELFER_SEED === 'true'
}

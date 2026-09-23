const defaults = { language: "en", sound: true, reducedMotion: false, bestScore: 0, bestPrecision: 0, bestPrecisionStreak: 0, gamesPlayed: 0 };
const raw = globalThis.browser?.storage.local || globalThis.chrome.storage.local;
export const storage = {
  async get() { return { ...defaults, ...(await raw.get(null)) }; },
  set(values) { return raw.set(values); }
};

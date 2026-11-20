import {AnimatePresence, motion} from 'framer-motion';
import {type FC, useEffect, useState} from 'react';

import HaPyLogo from '../../../assets/hapy-logo.png';
import Bg01 from '../../../assets/login-backgrounds/login-bg-01.jpg';
import Bg02 from '../../../assets/login-backgrounds/login-bg-02.jpg';
import Bg03 from '../../../assets/login-backgrounds/login-bg-03.jpg';
import Bg04 from '../../../assets/login-backgrounds/login-bg-04.jpg';
import Bg05 from '../../../assets/login-backgrounds/login-bg-05.jpg';
import BgBadMuender from '../../../assets/login-backgrounds/login-bg-bad-muender.jpg';
import BgBadPyrmont from '../../../assets/login-backgrounds/login-bg-bad-pyrmont.jpg';
import BgCoppenbruegge from '../../../assets/login-backgrounds/login-bg-coppenbruegge.jpg';
import BgHohensteinSuentel from '../../../assets/login-backgrounds/login-bg-hohenstein-suentel.jpg';
import BgSchlossMuenchhausenAerzen from '../../../assets/login-backgrounds/login-bg-schloss-muenchhausen-aerzen.jpg';

/**
 * Typ für eine Folie mit Logo und Hintergrundbild einer Kommune.
 */
type KommuneSlide = {
  kommuneLogo: string;
  backgroundImage: string;
};

/**
 * Liste der anzuzeigenden Kommunal-Folien mit Logo und Hintergrund. Alle Folien zeigen
 * aktuell dasselbe Logo (Landkreis Hameln-Pyrmont), nur der Hintergrund wechselt zwischen
 * verschiedenen Motiven aus dem Landkreis.
 */
const slides: KommuneSlide[] = [
  Bg01,
  BgCoppenbruegge,
  Bg02,
  BgBadPyrmont,
  Bg03,
  BgSchlossMuenchhausenAerzen,
  BgHohensteinSuentel,
  BgBadMuender,
  Bg04,
  Bg05,
].map((backgroundImage) => ({kommuneLogo: HaPyLogo, backgroundImage}));

/**
 * Wie lange (ms) eine Folie stehen bleibt, bevor zur nächsten übergeblendet wird.
 */
const SLIDE_INTERVAL_MS = 6_000;

/**
 * Dauer (Sekunden) der Überblend-Animation zwischen zwei Folien.
 */
const CROSSFADE_DURATION_S = 1.6;

/**
 * Ermittelt den Index der nächsten Folie basierend auf dem aktuellen Index.
 * @param currentIndex Aktueller Folienindex
 * @returns Index der nächsten Folie
 */
const nextSlideIndex = (currentIndex: number) =>
  (currentIndex + 1) % slides.length;

/**
 * Komponente zur Anzeige eines animierten, wechselnden Folien-Sliders mit Kommunal-Logo.
 * Genau eine Folie ist zu jedem Zeitpunkt "aktiv" (stabil, ohne laufende Animation) und
 * bleibt für `SLIDE_INTERVAL_MS` stehen; beim Wechsel überblendet `AnimatePresence` die
 * alte Folie sanft in die neue, statt beide dauerhaft gegeneinander zu animieren.
 */
export const SlidingKommuneDisplay: FC = () => {
  const [slideIndex, setSlideIndex] = useState(0);

  useEffect(() => {
    const interval = setInterval(
      () => setSlideIndex(nextSlideIndex),
      SLIDE_INTERVAL_MS,
    );

    return () => clearInterval(interval);
  }, []);

  const slide = slides[slideIndex];

  return (
    <div className='relative size-full overflow-hidden bg-gray-900'>
      <AnimatePresence>
        <motion.img
          key={slide.backgroundImage}
          src={slide.backgroundImage}
          alt=''
          initial={{opacity: 0}}
          animate={{opacity: 1}}
          exit={{opacity: 0}}
          transition={{duration: CROSSFADE_DURATION_S, ease: 'easeInOut'}}
          className='absolute inset-0 size-full object-cover'
        />
      </AnimatePresence>

      {/* Abdunkelung für Lesbarkeit von Karte/Fußzeile über wechselnden Motiven. */}
      <div className='pointer-events-none absolute inset-0 bg-gradient-to-t from-black/50 via-black/0 to-black/20' />

      <div className='pointer-events-none absolute bottom-8 right-8 flex max-w-md items-center justify-between gap-6 rounded-lg bg-white/75 px-8 py-6 shadow-xl backdrop-blur-md'>
        <h2 className='text-2xl font-bold text-gray-700'>
          Wir sind schon dabei!
        </h2>

        <div className='w-[110px] shrink-0'>
          <img
            src={slide.kommuneLogo}
            alt='Logo der Kommune'
            className='ml-auto'
          />
        </div>
      </div>
    </div>
  );
};

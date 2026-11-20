import {CiLocationOn} from 'react-icons/ci';

import {AufrufAktionMarker} from '../../components/aufruf-aktion-marker';
import {Badge} from '../../components/badge';
import {CarouselSlideArtikel} from '../../components/carousel-slide';
import {CarouselSlider} from '../../components/carousel-slider';
import {QrCode} from '../../components/qr-code';
import {RibbonBadge} from '../../components/ribbon-badge';
import {useAutoCollapse} from '../../hooks/useAutoCollapse';
import type {AktuellesSlide} from './useAktuellesSlides';
import {useAktuellesSlides} from './useAktuellesSlides';

type AktuellesBlockViewProps = {
  slides: AktuellesSlide[];
};

const resolveHeaderMarker = (slide: AktuellesSlide) => {
  switch (slide.kind) {
    case 'aufruf':
      return <AufrufAktionMarker />;
    case 'news':
      return null;
  }
};

export const AktuellesBlockView = ({slides}: AktuellesBlockViewProps) => {
  const {expandedId, toggle, collapse, remainingSeconds} = useAutoCollapse();

  return (
    <CarouselSlider
      heading='Aktuelles aus der Region'
      headerEnd={slides.map(resolveHeaderMarker)}
      autoplayPaused={expandedId !== null}
      onSlideChange={collapse}
    >
      {slides.map((slide) => (
        <CarouselSlideArtikel
          key={slide.id}
          date={slide.date}
          headline={slide.headline}
          subHeadline={slide.subHeadline}
          body={slide.body}
          image={slide.image}
          imageFallback={slide.imageFallback}
          headerEnd={
            slide.location ? (
              <Badge label={slide.location} icon={CiLocationOn} colorized />
            ) : undefined
          }
          qrCode={
            slide.qrCodeSrc ? (
              <QrCode
                src={slide.qrCodeSrc}
                label='Mehr Informationen'
                size={120}
              />
            ) : undefined
          }
          isHighlight={slide.kind === 'aufruf'}
          ribbon={
            slide.ribbon ? <RibbonBadge label={slide.ribbon} /> : undefined
          }
          isExpanded={expandedId === slide.id}
          onToggleExpand={() => toggle(slide.id)}
          autoCollapseSecondsRemaining={
            expandedId === slide.id ? remainingSeconds : undefined
          }
        />
      ))}
    </CarouselSlider>
  );
};

export const AktuellesBlock = () => {
  const {slides} = useAktuellesSlides();
  return <AktuellesBlockView slides={slides} />;
};

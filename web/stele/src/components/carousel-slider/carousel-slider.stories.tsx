import type {Meta, StoryObj} from '@storybook/react-vite';
import {CiLocationOn} from 'react-icons/ci';

import {AufrufAktionMarker} from '../aufruf-aktion-marker';
import {Badge} from '../badge';
import {CarouselSlideArtikel} from '../carousel-slide/carousel-slide-artikel';
import {CarouselSlideVeranstaltung} from '../carousel-slide/carousel-slide-veranstaltung';
import {QrCode} from '../qr-code';
import {RibbonBadge} from '../ribbon-badge';
import {CarouselSlider} from './carousel-slider';

const meta = {
  title: 'Carousel/CarouselSlider',
  component: CarouselSlider,
  parameters: {layout: 'fullscreen'},
  decorators: [
    (Story) => (
      <div className='bg-gray-100 px-16 py-6'>
        <Story />
      </div>
    ),
  ],
} satisfies Meta<typeof CarouselSlider>;

export default meta;

type Story = StoryObj<typeof meta>;

const commonSlideArgs = {
  date: '23.03.2026',
  headline:
    'Leinenpflicht für Hunde in freier Landschaft vom 01. April bis zum 15. Juli',
  subHeadline:
    'Erinnerung für alle Hundehalter:innen an die geltende Leinenpflicht in der freien Landschaft vom 1. April bis zum 15. Juli',
  headerEnd: (
    <Badge label='Landkreis Hameln-Pyrmont' icon={CiLocationOn} colorized />
  ),
  qrCode: (
    <QrCode
      value='https://hameln-pyrmont.de/aktuelles/leinenpflicht'
      label='Mehr Informationen'
    />
  ),
};

const artikelArgs = {
  ...commonSlideArgs,
  body: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.',
};

const veranstaltungArgs = {
  ...commonSlideArgs,
  termin: {dateRange: '14.04.2026', timeRange: '19:00 - 21:30'},
  veranstalter: {
    name: 'Stadtkapelle Hameln e.V.',
    street: 'Rathausplatz 1',
    postalCode: '31785',
    city: 'Hameln',
    website: 'stadtkapelle-hameln.de',
  },
};

const articleSlides = (
  <>
    <CarouselSlideArtikel {...artikelArgs} />
    <CarouselSlideArtikel
      {...artikelArgs}
      headline='Neue Sprechzeiten im Bürgeramt ab April'
      subHeadline='Ab dem 1. April gelten geänderte Öffnungszeiten im Bürgeramt der Stadt Hameln.'
    />
    <CarouselSlideArtikel
      {...artikelArgs}
      isHighlight
      ribbon={<RibbonBadge label='Veranstalter' />}
      headline='Frühlingsfest auf dem Marktplatz'
      subHeadline='Das traditionelle Frühlingsfest startet am 12. April mit Musik, Kulinarik und Aktionen für die ganze Familie.'
    />
  </>
);

const eventSlides = (
  <>
    <CarouselSlideVeranstaltung {...veranstaltungArgs} />
    <CarouselSlideVeranstaltung
      {...veranstaltungArgs}
      headline='Konzert der Stadtkapelle Hameln'
      subHeadline='Frühlingsmatinee mit klassischem Programm im Theaterforum.'
    />
    <CarouselSlideVeranstaltung
      {...veranstaltungArgs}
      isHighlight
      ribbon={<RibbonBadge label='Veranstalter' />}
      headline='Sommerkino im Bürgergarten'
      subHeadline='Open-Air-Filmabend mit regionalen Speisen und Programm für Familien.'
      termin={{dateRange: '26.06.2026', timeRange: '18:30 - 22:30'}}
    />
  </>
);

export const Default: Story = {
  args: {
    heading: 'Aktuelles aus der Region',
    children: articleSlides,
  },
};

export const Events: Story = {
  args: {
    heading: 'Veranstaltungen in der Region',
    children: eventSlides,
  },
};

export const FastRotation: Story = {
  args: {
    ...Default.args,
    autoplayDelayMs: 3000,
  },
};

export const WithoutHeading: Story = {
  args: {
    children: Default.args!.children,
  },
};

export const SingleSlide: Story = {
  args: {
    heading: 'Aktuelles aus der Region',
    children: <CarouselSlideArtikel {...artikelArgs} />,
  },
};

export const Empty: Story = {
  args: {
    heading: 'Veranstaltungen',
    emptyState: 'Keine Veranstaltungen für diesen Zeitraum.',
    children: null,
  },
};

export const EmptyWithoutFallback: Story = {
  name: 'Empty (no emptyState — collapses)',
  args: {
    heading: 'Aktuelles aus der Region',
    children: null,
  },
};

export const WithPerSlideMarker: Story = {
  name: 'With per-slide marker (Aufrufe)',
  args: {
    heading: 'Aktuelles aus der Region',
    headerEnd: [<AufrufAktionMarker key='aufruf' />, null, null],
    children: (
      <>
        <CarouselSlideArtikel
          {...artikelArgs}
          isHighlight
          ribbon={<RibbonBadge label='Stadt Hameln' />}
          headline='Aufruf: Stadtputz-Aktion am 12. April'
          subHeadline='Gemeinsam für ein sauberes Hameln — Treffpunkt 09:00 Uhr am Rathausplatz.'
        />
        <CarouselSlideArtikel
          {...artikelArgs}
          headline='Neue Sprechzeiten im Bürgeramt ab April'
          subHeadline='Ab dem 1. April gelten geänderte Öffnungszeiten im Bürgeramt der Stadt Hameln.'
        />
        <CarouselSlideArtikel
          {...artikelArgs}
          headline='Sanierung der Weserbrücke abgeschlossen'
          subHeadline='Nach drei Monaten Bauzeit ist die Brücke wieder für den Verkehr freigegeben.'
        />
      </>
    ),
  },
};

export const WithStaticMarker: Story = {
  name: 'With static marker',
  args: {
    heading: 'Aktuelles aus der Region',
    headerEnd: <AufrufAktionMarker />,
    children: articleSlides,
  },
};

export const ManySlides: Story = {
  args: {
    heading: 'Aktuelles aus der Region',
    children: Array.from({length: 25}, (_, index) => (
      <CarouselSlideArtikel
        key={index}
        {...artikelArgs}
        headline={`Meldung ${index + 1}: Neues aus der Region`}
        subHeadline='Kurze Zusammenfassung einer regionalen Nachricht für den Carousel Slider Belastungstest.'
        isHighlight={index % 5 === 0}
        ribbon={
          index % 5 === 0 ? <RibbonBadge label='Veranstalter' /> : undefined
        }
      />
    )),
  },
};

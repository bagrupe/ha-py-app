import type {Meta, StoryObj} from '@storybook/react-vite';
import {CiLocationOn} from 'react-icons/ci';

import {Badge} from '../badge';
import {QrCode} from '../qr-code';
import {RibbonBadge} from '../ribbon-badge';
import {CarouselSlideVeranstaltung} from './carousel-slide-veranstaltung';

const meta = {
  title: 'Carousel/CarouselSlideVeranstaltung',
  component: CarouselSlideVeranstaltung,
  parameters: {layout: 'centered'},
  decorators: [
    (Story, context) => (
      <div style={{width: context.parameters.cardWidth ?? 920}}>
        <Story />
      </div>
    ),
  ],
} satisfies Meta<typeof CarouselSlideVeranstaltung>;

export default meta;

type Story = StoryObj<typeof meta>;

const LONG_SUB_HEADLINE =
  'Hier steht eine bewusst ausführliche Subheadline, die den Inhalt sehr präzise zusammenfasst und dabei über mehrere Zeilen läuft, damit Besucherinnen und Besucher die wichtigsten Eckdaten der Veranstaltung direkt erfassen können.';

const EXTRA_LONG_SUB_HEADLINE =
  'Die Veranstaltung umfasst mehrere Programmpunkte, Hinweise zur Anreise, konkrete Zeitfenster und wichtige Informationen für Familien, Vereine und interessierte Gäste aus der Region. Der Teaser bleibt auch bei knapper Fläche der wichtigste Orientierungspunkt der Karte.';

export const Veranstaltung: Story = {
  args: {
    date: '23.03.2026',
    headline: 'Headline',
    subHeadline:
      'Hier steht eine kurze Subheadline, die den Inhalt präzise zusammenfasst. Zwei Zeilen bieten genügend Raum für die wichtigsten Details und Key-Benefits.',
    termin: {
      dateRange: 'Do, 25.06.2026 - Fr, 10.07.2026',
      timeRange: '15:00 Uhr - 21:00 Uhr',
    },
    veranstalter: {
      name: 'Volkswagen Veteranen Hessisch Oldendorf e.V.',
      street: 'Lange Straße 25',
      postalCode: '31840',
      city: 'Hessisch Oldendorf',
      website: 'www.westliches-weserbergland.de',
    },
    headerEnd: <Badge label='Location' icon={CiLocationOn} colorized />,
    qrCode: (
      <QrCode
        value='https://www.westliches-weserbergland.de'
        label='Mehr Informationen'
        size={120}
      />
    ),
  },
};

export const VeranstaltungHighlight: Story = {
  args: {
    ...Veranstaltung.args!,
    isHighlight: true,
    ribbon: <RibbonBadge label='Veranstalter' />,
    headerEnd: (
      <>
        <Badge label='Location' icon={CiLocationOn} colorized />
        <Badge label='Jetzt mitmachen!' colorized highlight />
      </>
    ),
  },
};

// No teaser: the structured event details sit directly under the headline.
export const VeranstaltungNoSubHeadline: Story = {
  args: {
    ...Veranstaltung.args!,
    subHeadline: undefined,
  },
};

// Long teaser gets priority while the structured termin/veranstalter columns
// stay bounded inside the card.
export const VeranstaltungLongSubHeadline: Story = {
  args: {
    ...Veranstaltung.args!,
    subHeadline: LONG_SUB_HEADLINE,
  },
};

// Stress case: teaser, structured details, and QR code all remain clipped to the
// fixed-height card instead of overflowing the slide.
export const VeranstaltungVeryLongSubHeadlineNarrow: Story = {
  parameters: {cardWidth: 720},
  args: {
    ...Veranstaltung.args!,
    headline:
      'Eine bewusst sehr lange Veranstaltungsheadline mit mehreren Informationen',
    subHeadline: EXTRA_LONG_SUB_HEADLINE,
  },
};

// Tappable card with a long Veranstalter name/website: the "Mehr anzeigen"
// hint only shows up because those fields are actually clipped.
export const VeranstaltungTappableCollapsed: Story = {
  parameters: {cardWidth: 720},
  args: {
    ...Veranstaltung.args!,
    veranstalter: {
      name: 'Volkswagen Veteranen Hessisch Oldendorf e.V. - Abteilung Motorräder und Traktoren',
      street: 'Lange Straße 25',
      postalCode: '31840',
      city: 'Hessisch Oldendorf',
      website: 'www.westliches-weserbergland-tourismus-und-freizeit.de',
    },
    onToggleExpand: () => {},
  },
};

export const VeranstaltungTappableExpanded: Story = {
  args: {
    ...VeranstaltungTappableCollapsed.args!,
    isExpanded: true,
    autoCollapseSecondsRemaining: 12,
  },
};

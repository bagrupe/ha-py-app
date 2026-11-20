import type {Meta, StoryObj} from '@storybook/react-vite';
import {CiLocationOn} from 'react-icons/ci';

import {Badge} from '../badge';
import {QrCode} from '../qr-code';
import {RibbonBadge} from '../ribbon-badge';
import {CarouselSlideArtikel} from './carousel-slide-artikel';
import stockImage from './carousel-stock-example.jpg';

const meta = {
  title: 'Carousel/CarouselSlideArtikel',
  component: CarouselSlideArtikel,
  parameters: {layout: 'centered'},
  // Pin to a representative kiosk card width so the body wraps and the
  // fit-to-fill clamp is actually exercised (centered layout otherwise
  // shrinks the card to its content and the body never clamps).
  decorators: [
    (Story, context) => (
      <div style={{width: context.parameters.cardWidth ?? 920}}>
        <Story />
      </div>
    ),
  ],
} satisfies Meta<typeof CarouselSlideArtikel>;

export default meta;

type Story = StoryObj<typeof meta>;

const ONE_LINE_SUB = 'Kurze Subheadline in einer einzigen Zeile.';

const TWO_LINE_SUB =
  'Hier steht eine kurze Subheadline, die den Inhalt präzise zusammenfasst. Zwei Zeilen bieten genügend Raum für die wichtigsten Details und Key-Benefits.';

const FOUR_LINE_SUB =
  'Hier steht eine bewusst ausführliche Subheadline, die den Inhalt sehr präzise zusammenfasst und dabei über mehrere Zeilen läuft. Bürgerinnen und Bürger erhalten zuerst die wichtigsten Eckdaten, bevor weitere Details im Fließtext folgen.';

const EXTRA_LONG_SUB =
  'Die Stadt informiert über eine umfangreiche Maßnahme mit mehreren Beteiligten, konkreten Terminen und wichtigen Hinweisen für Bürgerinnen und Bürger. Der Teaser bleibt der wichtigste Orientierungspunkt der Karte und soll auch bei knapper Fläche überwiegend sichtbar bleiben.';

const LONG_BODY =
  'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.';

const SHORT_BODY =
  'Eine kurze Zusammenfassung in nur wenigen Worten, die den Platz nicht ausfüllt.';

const VERY_LONG_BODY = Array.from({length: 6}, () => LONG_BODY).join(' ');

export const Artikel: Story = {
  args: {
    date: '23.03.2026',
    headline: 'Headline',
    subHeadline: TWO_LINE_SUB,
    body: LONG_BODY,
    headerEnd: <Badge label='Location' icon={CiLocationOn} colorized />,
    qrCode: (
      <QrCode
        value='https://hameln-pyrmont.de/aktuelles/example-artikel'
        label='Mehr Informationen'
        size={120}
      />
    ),
  },
};

export const ArtikelHighlight: Story = {
  args: {
    ...Artikel.args!,
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

export const ArtikelHighlightWithImage: Story = {
  args: {
    ...ArtikelHighlight.args!,
    image: stockImage,
  },
};

// One-line teaser: the body should claim the most lines here.
export const OneLineSubHeadline: Story = {
  args: {
    ...Artikel.args!,
    subHeadline: ONE_LINE_SUB,
  },
};

// Multi-line teaser gets priority: the body clamps to fewer lines to compensate.
export const MultiLineSubHeadline: Story = {
  args: {
    ...Artikel.args!,
    subHeadline: FOUR_LINE_SUB,
  },
};

// No teaser at all: the body should fill the entire remaining column.
export const NoSubHeadline: Story = {
  args: {
    ...Artikel.args!,
    subHeadline: undefined,
  },
};

// Body shorter than the available space: no clamp, no ellipsis.
export const ShortBody: Story = {
  args: {
    ...Artikel.args!,
    subHeadline: ONE_LINE_SUB,
    body: SHORT_BODY,
  },
};

// Two-line headline + long teaser: tightest case, body squeezed to the minimum.
export const LongHeadlineAndSubHeadline: Story = {
  args: {
    ...Artikel.args!,
    headline:
      'Eine bewusst sehr lange Headline, die über zwei volle Zeilen läuft und dort abgeschnitten wird',
    subHeadline: FOUR_LINE_SUB,
  },
};

// Tappable card: click/tap toggles between the clamped and fully expanded
// (grow-to-fit) body. Autoplay pausing is wired up one level higher, in
// AktuellesBlockView.
export const ArtikelTappableCollapsed: Story = {
  args: {
    ...Artikel.args!,
    body: VERY_LONG_BODY,
    onToggleExpand: () => {},
  },
};

export const ArtikelTappableExpanded: Story = {
  args: {
    ...ArtikelTappableCollapsed.args!,
    isExpanded: true,
  },
};

// Expanded with the auto-collapse clock visible (30s inactivity timeout is
// wired up in AktuellesBlockView; here the remaining seconds are fixed for
// visual inspection).
export const ArtikelTappableExpandedWithCountdown: Story = {
  args: {
    ...ArtikelTappableExpanded.args!,
    autoCollapseSecondsRemaining: 12,
  },
};

// Stress case: the teaser is bounded generously while body and QR remain inside
// the fixed-height card.
export const VeryLongSubHeadlineNarrow: Story = {
  parameters: {cardWidth: 720},
  args: {
    ...Artikel.args!,
    headline:
      'Eine bewusst sehr lange Headline, die über zwei volle Zeilen läuft und dort abgeschnitten wird',
    subHeadline: EXTRA_LONG_SUB,
  },
};

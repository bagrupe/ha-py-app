import containerQueries from '@tailwindcss/container-queries';

/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: 'rgb(var(--color-primary) / <alpha-value>)',
          light: 'rgb(var(--color-primary-light) / <alpha-value>)',
        },
        gray: {
          50: '#FBFBFB',
          100: '#F1F1F1',
          300: '#D1D1D1',
          500: '#818181',
          700: '#6A6A6A',
          900: '#4E4E4E',
        },
      },
      container: {
        center: '#5',
        padding: '1rem',
        screens: {
          md: '1200px',
        },
      },
      keyframes: {
        overlayShow: {
          from: {opacity: 0},
          to: {opacity: 1},
        },
        contentShow: {
          from: {opacity: 0, transform: 'translate(-50%, -48%) scale(0.96)'},
          to: {opacity: 1, transform: 'translate(-50%, -50%) scale(1)'},
        },
        slideDownAndFade: {
          from: {opacity: '0', transform: 'translateY(-2px)'},
          to: {opacity: '1', transform: 'translateY(0)'},
        },
        slideLeftAndFade: {
          from: {opacity: '0', transform: 'translateX(2px)'},
          to: {opacity: '1', transform: 'translateX(0)'},
        },
        slideUpAndFade: {
          from: {opacity: '0', transform: 'translateY(2px)'},
          to: {opacity: '1', transform: 'translateY(0)'},
        },
        slideRightAndFade: {
          from: {opacity: '0', transform: 'translateX(-2px)'},
          to: {opacity: '1', transform: 'translateX(0)'},
        },
      },
      animation: {
        slideDownAndFade:
          'slideDownAndFade 200ms cubic-bezier(0.16, 1, 0.3, 1)',
        slideLeftAndFade:
          'slideLeftAndFade 200ms cubic-bezier(0.16, 1, 0.3, 1)',
        slideUpAndFade: 'slideUpAndFade 200ms cubic-bezier(0.16, 1, 0.3, 1)',
        slideRightAndFade:
          'slideRightAndFade 200ms cubic-bezier(0.16, 1, 0.3, 1)',
        overlayShow: 'overlayShow 150ms cubic-bezier(0.16, 1, 0.3, 1)',
        contentShow: 'contentShow 150ms cubic-bezier(0.16, 1, 0.3, 1)',
      },
    },
  },
  plugins: [containerQueries, require('@tailwindcss/typography')],
};

import plugin from 'tailwindcss/plugin';

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
          200: '#E5E5E5',
          300: '#D1D1D1',
          500: '#818181',
          600: '#737373',
          700: '#6A6A6A',
          900: '#4E4E4E',
        },
        hameln: {
          50: '#F7FCE9',
          200: '#DAEFA7',
          600: '#74A220',
          675: '#597D1C',
          700: '#50701B',
          800: '#42591B',
          900: '#384C1B',
        },
      },
      fontFamily: {
        sans: ['"Century Gothic"', 'ui-sans-serif', 'system-ui', 'sans-serif'],
      },
      fontSize: {
        'display-md': ['35px', {lineHeight: '1', fontWeight: '700'}],
      },
      keyframes: {
        'marker-in': {
          '0%': {opacity: '0', transform: 'translateX(4px)'},
          '100%': {opacity: '1', transform: 'translateX(0)'},
        },
      },
      animation: {
        'marker-in': 'marker-in 320ms cubic-bezier(0.22, 1, 0.36, 1) both',
      },
    },
  },
  plugins: [
    plugin(({addUtilities}) => {
      addUtilities({
        '.mask-fade-bottom': {
          '--mask-fade': '1.5rem',
          'mask-image':
            'linear-gradient(to bottom, black calc(100% - var(--mask-fade)), transparent)',
          '-webkit-mask-image':
            'linear-gradient(to bottom, black calc(100% - var(--mask-fade)), transparent)',
        },
      });
    }),
  ],
};

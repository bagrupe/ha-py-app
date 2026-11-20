const getThemeColors = () => {
  const themeColors = {}
  for (const token of ['success', 'warning', 'error', 'elevation']) {
    const variants = []
    for (let i = 0; i <= 1000; i += 50) {
      const varName = `color-${token}-${i}`
      const val = `var(--${varName})`
      variants.push([i.toString(), val])
    }
    themeColors[token] = Object.fromEntries(variants)
  }

  return themeColors
}

/** @type {import('tailwindcss').Config} */
const config = {
  content: ['./src/**/*.{ts,tsx}'],
  darkMode: ['class', '[data-theme="dark"]'],
  theme: {
    extend: {},
    colors: {
      white: '#fff',
      black: '#000',
      transparent: 'transparent',
      brown: {
        light: '#e0d0bf',
        DEFAULT: '#b69169',
      },
      ...getThemeColors(),
    },
    // https://github.com/payloadcms/payload/blob/master/src/admin/scss/vars.scss
    screens: {
      xs: '400px',
      sm: '768px',
      md: '1024px',
      lg: '1440px',
    },
  },
}

export default config

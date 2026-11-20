import './styles.css'

export const metadata = {
  description: 'Bereich B CMS',
  title: 'Bereich B CMS',
}

export default function RootLayout(props: { children: React.ReactNode }) {
  const { children } = props
  return (
    <html lang="en">
      <body>
        <main>{children}</main>
      </body>
    </html>
  )
}

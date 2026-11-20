'use client'

import React from 'react'
import { useAuth } from '@payloadcms/ui'
import { type Benutzer } from '../../payload-types'
import { Funktionsberechtigung } from '../../lib/funktionsberechtigungen'

const AfterNavLinks: React.FC = () => {
  const { user } = useAuth()
  const benutzer = user as unknown as Benutzer | undefined

  if (!benutzer) {
    return null
  }

  const hasBackofficePermissions = benutzer.organisationseinheiten?.some((o) =>
    (o.funktionsberechtigungen as Funktionsberechtigung[]).includes(
      Funktionsberechtigung.Backoffice,
    ),
  )
  const canAccessBereichA = benutzer.isSuperAdmin || hasBackofficePermissions
  if (!canAccessBereichA) {
    return null
  }

  return (
    <>
      {/* eslint-disable-next-line @next/next/no-html-link-for-pages -- `/` is bereich-a behind the proxy, not a Next route */}
      <a className="nav__link" href="/">
        <span className="nav__link-label">Bereich A</span>
      </a>
      <a className="nav__link" href="/docs-api" rel="noreferrer noopener" target="_blank">
        <span className="nav__link-label">API-Dokumentation</span>
      </a>
    </>
  )
}

export const NavLinks = AfterNavLinks

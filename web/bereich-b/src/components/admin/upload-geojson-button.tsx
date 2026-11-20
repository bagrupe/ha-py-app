'use client'

import isPlainObject from 'lodash/isPlainObject'
import { Button, SelectInput, Drawer, DrawerToggler, useModal } from '@payloadcms/ui'
import { CodeEditor } from '@payloadcms/ui/elements/CodeEditor'
import { type OptionObject } from 'payload'

type SelectOption = { value: unknown; [key: string]: unknown }
import React, { type ComponentProps, type FC, useEffect, useRef, useState } from 'react'
import { toast } from '@payloadcms/ui'
import { Funktionsberechtigung } from '../../lib/funktionsberechtigungen'
import { jsonSchema, validateGeoJson } from '../../lib/geojson'
import { useListViewRefreshHack } from '../../lib/use-list-view-refresh-hack'
import { OrganisationseinheitSelect } from './organisationseinheit-select'

type CategoryDoc = {
  title: string
  id: string
}

type CategoryDocs = {
  docs: CategoryDoc[]
}

type Monaco = Parameters<Exclude<ComponentProps<typeof CodeEditor>['beforeMount'], undefined>>[0]

type MonacoMarker = ReturnType<Monaco['editor']['getModelMarkers']>[number]

export const UploadGeojsonComponent: FC = () => {
  const [jsonValue, setJsonValue] = useState('')
  let parsedJson: unknown
  try {
    parsedJson = JSON.parse(jsonValue)
  } catch {
    parsedJson = null
  }
  const validation = validateGeoJson(parsedJson)
  const [organisationseinheitId, setOrganisationseinheitId] = useState<string | null>(null)
  const [kategorieId, setKategorieId] = useState<string | null>(null)
  const [categories, setcategories] = useState<OptionObject[] | null>(null)
  const inputRef = useRef<HTMLInputElement>(null)
  const monacoRef = useRef<Monaco | null>(null)
  const [monacoMarkers, setMonacoMarkers] = useState<MonacoMarker[]>([])
  const refresh = useListViewRefreshHack()
  const crs = validation.data?.crs?.properties?.name ?? 'auto'
  const drawerSlug = 'geojson-poi-import'

  const modal = useModal()

  useEffect(() => {
    async function getCategories() {
      const response = await fetch('/cms/api/poi-categories?pagination=false', { method: 'get' })
      const categoriesJson: CategoryDocs = (await response.json()) as CategoryDocs

      const parsedCategories = categoriesJson.docs.map((categoryDoc: CategoryDoc) => ({
        label: categoryDoc.title,
        value: categoryDoc.id,
      }))

      setcategories(parsedCategories)
    }

    void getCategories()
  }, [])

  const onSubmit = async () => {
    const response = (await fetch('/cms/api/poi/upload', {
      method: 'post',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({
        organisationseinheitId,
        kategorieId,
        featureCollection: parsedJson,
      }),
    }).then((r) => r.json())) as { success?: boolean; error: string }
    if (response.success) {
      toast.success(`${validation.data?.features.length} POIs importiert.`)
      modal.closeModal(drawerSlug)
      refresh()
    } else if (response.error) {
      toast.error(response.error)
    }
  }

  return (
    <div className="group-field py-4">
      <DrawerToggler
        slug="geojson-poi-import"
        className="pill pill--style-light pill--has-link pill--has-action"
      >
        Aus GeoJSON importieren
      </DrawerToggler>
      <Drawer slug="geojson-poi-import" title="POIs aus GeoJSON importieren">
        <OrganisationseinheitSelect
          label="Organisationseinheit"
          description="Bitte weisen Sie die POIs einer Organisationseinheit zu."
          value={organisationseinheitId ?? ''}
          onChange={(id) => {
            setOrganisationseinheitId(id)
          }}
          funktionsberechtigung={Funktionsberechtigung.InhaltspflegePois}
        />
        <SelectInput
          name="category"
          path="category"
          label="Kategorie"
          options={categories ?? []}
          description="Bitte wählen Sie die POI-Kategorie aus."
          onChange={(option: SelectOption | SelectOption[]) => {
            const val = Array.isArray(option) ? option[0] : option
            setKategorieId(val == null ? null : (val.value as string))
          }}
          isClearable={false}
          value={kategorieId ?? ''}
        />
        <SelectInput
          name="crs"
          path="crs"
          options={crsOptions}
          label="Koordinatenreferenzsystem"
          onChange={(option: SelectOption | SelectOption[]) => {
            const val = Array.isArray(option) ? option[0] : option
            if (validation.success) {
              const { crs: _, type: __, ...rest } = validation.data
              setJsonValue(
                JSON.stringify(
                  val.value === 'auto'
                    ? { type: 'FeatureCollection', ...rest, crs: undefined }
                    : {
                        type: 'FeatureCollection',
                        crs: { type: 'name', properties: { name: val.value } },
                        ...rest,
                      },
                  null,
                  2,
                ),
              )
            }
          }}
          value={crs}
          isClearable={false}
        />
        <CodeEditor
          value={jsonValue}
          language="json"
          beforeMount={(monaco: Monaco) => {
            monaco.editor.onDidChangeMarkers(() => {
              setMonacoMarkers(monaco.editor.getModelMarkers({}))
            })
            monacoRef.current = monaco
            monaco.languages.json.jsonDefaults.setDiagnosticsOptions({
              // enableSchemaRequest: true,
              validate: true,
              schemas: [
                {
                  uri: 'https://example.com',
                  fileMatch: ['*'], // Apply validation to all JSON files
                  schema: jsonSchema,
                },
              ],
            })
          }}
          onChange={(value: string | undefined) => setJsonValue(value ?? '')}
        />
        <input
          ref={inputRef}
          type="file"
          accept="*"
          className="hidden"
          onChange={async (event) => {
            const input = event.currentTarget
            const files = input.files ?? []
            if (files.length == 0) return
            const text = await files[0].text()
            try {
              const json = JSON.parse(text)
              setJsonValue(JSON.stringify(json, null, 2))
              if (!isPlainObject(json)) {
                toast.error('Die Datei enthält kein valides JSON-Objekt.')
                return
              }
            } catch {
              toast.error('Die Datei enthält kein valides JSON.')
            }
          }}
        />
        {validation.error && (
          <div className="mt-4 max-h-40 overflow-scroll font-mono text-error-350">
            {monacoMarkers.map((m, i) => (
              <div
                key={i}
                className="flex cursor-pointer hover:underline"
                onClick={() => {
                  const editor = monacoRef.current!.editor.getEditors()[0]
                  editor.revealLine(m.startLineNumber)
                  editor.setPosition({
                    lineNumber: m.startLineNumber,
                    column: m.startColumn,
                  })
                  editor.trigger('keyboard', 'editor.action.marker.next', {})
                }}
              >
                <div className="mr-4 flex-none opacity-80">Zeile {m.startLineNumber}</div>
                {m.message}
              </div>
            ))}
          </div>
        )}
        {validation.success && (
          <div className="mt-4 text-success-350">
            {validation.data.features.length} gültige POIs erfasst.
          </div>
        )}

        <div className="flex w-full justify-between">
          <Button type="button" buttonStyle="secondary" onClick={() => inputRef.current?.click()}>
            Datei laden
          </Button>
          <Button
            type="button"
            buttonStyle="primary"
            onClick={() => onSubmit()}
            disabled={
              !jsonValue ||
              !kategorieId ||
              !organisationseinheitId ||
              !validation.success ||
              validation.data.features.length === 0
            }
          >
            Import starten
          </Button>
        </div>
      </Drawer>
    </div>
  )
}

const crsOptions = [
  { label: 'Automatisch', value: 'auto' },
  {
    label: 'EPSG:4326 — Geographische Koordinaten im WGS 84',
    value: 'urn:ogc:def:crs:EPSG::4326',
  },
  {
    label: 'EPSG:25832 — UTM-Koordinaten der Zone 32N (6 – 12° Ost) im ETRS 89',
    value: 'urn:ogc:def:crs:EPSG::25832',
  },
  {
    label: 'EPSG:31466 — Gauß-Krüger-Koordinaten - Zone 2',
    value: 'urn:ogc:def:crs:EPSG::31466',
  },
  {
    label: 'EPSG:31467 — Gauß-Krüger-Koordinaten - Zone 3',
    value: 'urn:ogc:def:crs:EPSG::31467',
  },
  {
    label: 'EPSG:31468 — Gauß-Krüger-Koordinaten - Zone 4',
    value: 'urn:ogc:def:crs:EPSG::31468',
  },
  {
    label: 'EPSG:31469 — Gauß-Krüger-Koordinaten - Zone 5',
    value: 'urn:ogc:def:crs:EPSG::31469',
  },
  {
    label: 'EPSG:31469 — UTM-Koordinaten der Zone 32N (6 – 12° Ost) im WGS 84',
    value: 'urn:ogc:def:crs:EPSG::31469',
  },
  {
    label: 'EPSG:32633 — UTM-Koordinaten der Zone 33N (12 – 18° Ost) im WGS 84',
    value: 'urn:ogc:def:crs:EPSG::32633',
  },
]

'use client'

import {
  Collapsible,
  DraggableSortable,
  DraggableSortableItem,
  FieldDescription,
  FieldLabel,
  RenderFields,
  RowLabel,
  useField,
  useForm,
} from '@payloadcms/ui'
import { type ArrayFieldClientComponent } from 'payload'

/**
 * Payload's ArrayField only offers "sortable" together with add, duplicate, remove and paste.
 * The import owns which felder exist, so editors get reordering and the row's own fields only.
 */
export const SortableSensorFelderField: ArrayFieldClientComponent = ({
  field,
  path: pathFromProps,
  permissions,
  schemaPath,
}) => {
  const { path, rows = [] } = useField({ hasRows: true, potentiallyStalePath: pathFromProps })
  const { moveFieldRow, setModified } = useForm()

  return (
    <div className="field-type array-field" id={`field-${path.replace(/\./g, '__')}`}>
      <header className="array-field__header">
        <h3 className="array-field__title">
          <FieldLabel as="span" label={field.label} path={path} />
        </h3>
        <FieldDescription description={field.admin?.description} path={path} />
      </header>
      <DraggableSortable
        className="array-field__draggable-rows"
        ids={rows.map((row) => row.id)}
        onDragEnd={({ moveFromIndex, moveToIndex }) => {
          moveFieldRow({ moveFromIndex, moveToIndex, path })
          setModified(true)
        }}
      >
        {rows.map((row, rowIndex) => {
          const rowPath = `${path}.${rowIndex}`
          return (
            <DraggableSortableItem key={row.id} id={row.id}>
              {({ attributes, listeners, setNodeRef, transform, transition }) => (
                <div ref={setNodeRef} style={{ transform, transition }}>
                  <Collapsible
                    className="array-field__row"
                    dragHandleProps={{ id: row.id, attributes, listeners }}
                    header={
                      <RowLabel
                        CustomComponent={row.customComponents?.RowLabel}
                        path={rowPath}
                        rowNumber={rowIndex}
                      />
                    }
                    initCollapsed={row.collapsed}
                  >
                    <RenderFields
                      fields={field.fields}
                      margins="small"
                      parentIndexPath=""
                      parentPath={rowPath}
                      parentSchemaPath={schemaPath ?? field.name}
                      permissions={
                        permissions === true ? permissions : (permissions?.fields ?? true)
                      }
                    />
                  </Collapsible>
                </div>
              )}
            </DraggableSortableItem>
          )
        })}
      </DraggableSortable>
    </div>
  )
}

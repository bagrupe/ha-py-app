'use client'

export const SensorPositionWarning = () => {
  return (
    <div className="mb-8 rounded border border-solid border-error-600 bg-error-900 p-6">
      Die <a href="#positionAnchor">Position</a> des Sensors sollte nach dem ersten Import angepasst
      werden.
    </div>
  )
}

'use client'

import React from 'react'

export const BooleanJaNeinCell = ({ cellData }: { cellData?: boolean }) =>
  cellData ? <div>Ja</div> : <div>Nein</div>

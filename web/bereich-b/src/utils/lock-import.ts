import { type PayloadRequest } from 'payload'
import { type Poi, type Veranstaltungskalender } from '../payload-types'

export const lockImportOnManualUpdate = async (
  data: Partial<Poi | Veranstaltungskalender>,
  req: PayloadRequest,
  originalDoc: Partial<Poi | Veranstaltungskalender>,
) => {
  let modifiedData = data

  // req.user is undefined when the change-operation is triggered by the import
  // we need to check for the lockedForImport value, so that the user still can manually uncheck it
  if (req.user && (!originalDoc || !originalDoc.lockedForImport)) {
    modifiedData = {
      ...modifiedData,
      lockedForImport: true,
    }
  }

  return modifiedData
}

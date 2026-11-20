import { type Validate } from 'payload'

// We cant use the required options, because we need depending on the integrationtype
// a different set of required fields. So we have to validate manually
export const validateIntegrationField: Validate = async (val) => {
  if (!val) {
    return 'Dieses Feld ist erforderlich'
  }
  return true
}

import { type SelectField } from 'payload'

const fonts = [
  // FKA "Muli", used in https://www.hameln-pyrmont.de/
  { label: 'Mulish', value: 'Mulish' },
  { label: 'Roboto Slab', value: 'RobotoSlab' },
  { label: 'Noto Sans', value: 'NotoSans' },
  { label: 'Century Gothic', value: 'CenturyGothic' },
]

export const fontField = (
  props: Pick<SelectField, 'name' | 'label' | 'required' | 'defaultValue'>,
): SelectField => ({
  ...props,
  type: 'select',
  options: fonts.map(({ label, value }) => ({ label, value })),
})

/**
 * Eigenschaften für die SectionHeading-Komponente.
 * Beinhaltet das anzuzeigende Label.
 */
export type SectionHeadingProps = {
  label: string;
};

/**
 * Komponente zur Darstellung einer Abschnittsüberschrift mit einer Linie.
 * @param label Der anzuzeigende Text der Überschrift
 */
export const SectionHeading = ({label}: SectionHeadingProps) => (
  <div className='flex items-center'>
    <div className='mr-4 whitespace-nowrap font-bold'>{label}</div>
    <div className='h-px w-full border-0 bg-neutral-300' />
  </div>
);

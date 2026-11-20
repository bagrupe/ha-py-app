// Layout component for the filter row.
export interface FilterRowLayoutProps {
  children: React.ReactNode;
  className?: string;
}

export function FilterRowLayout({children, className}: FilterRowLayoutProps) {
  return (
    <div
      className={[
        'grid w-full grid-cols-2 items-center gap-x-4 gap-y-3',
        className,
      ]
        .filter(Boolean)
        .join(' ')}
    >
      {children}
    </div>
  );
}

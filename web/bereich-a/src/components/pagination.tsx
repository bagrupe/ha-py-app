import {ChevronLeftIcon, ChevronRightIcon} from '@radix-ui/react-icons';
import React, {Fragment, useEffect, useRef, useState} from 'react';
import {Link, useLocation} from 'react-router';
import {twMerge} from 'tailwind-merge';

/**
 * Typ für ein Element der Paginierung, das eine Seite, Navigation oder Auslassung repräsentiert.
 */
type PaginationItem =
  | {type: 'page'; page: number; isCurrent: boolean}
  | {type: 'prev'; page: number; disabled: boolean}
  | {type: 'next'; page: number; disabled: boolean}
  | {type: 'ellipsis'};

/**
 * Eigenschaften für die Basiskomponente der Paginierung.
 */
type PaginationBaseProps = {
  totalPages: number;
  currentPage: number;
  className?: string;
  itemWidth: number;
  render: (item: PaginationItem) => React.ReactNode;
};

/**
 * Basiskomponente zur Darstellung einer Paginierung mit dynamischer Seitenanzahl basierend auf Containerbreite.
 * @param totalPages Gesamtanzahl der Seiten
 * @param currentPage Aktuell ausgewählte Seite (0-basiert)
 * @param itemWidth Breite eines einzelnen Paginierungselements in Pixel
 * @param render Funktion zur Darstellung eines Paginierungselements
 * @param className optionale CSS-Klassen für den Container
 */
export const PaginationBase = ({
  totalPages,
  currentPage,
  itemWidth,
  render,
  className,
}: PaginationBaseProps) => {
  const containerRef = useRef<HTMLDivElement>(null);
  const [maxVisiblePages, setMaxVisiblePages] = useState<number>(5); // Fallback-Standardwert

  useEffect(() => {
    const container = containerRef.current;
    if (!container) return;

    const measure = () => {
      const width = container.offsetWidth;
      const count = Math.max(5, Math.floor(width / (itemWidth + 1)));
      setMaxVisiblePages(count);
    };

    const observer = new ResizeObserver(measure);
    observer.observe(container);

    measure();

    return () => observer.disconnect();
  }, [itemWidth]);

  /**
   * Ermittelt die anzuzeigenden Seiten-Elemente inklusive Navigation und Auslassungen.
   * @returns Array von PaginationItem-Objekten
   */
  const getPages = (): PaginationItem[] => {
    const items: PaginationItem[] = [
      {isCurrent: true, type: 'page', page: currentPage},
    ];
    for (let offset = 1; offset < maxVisiblePages; offset++) {
      const rhs = currentPage + offset;
      if (rhs < totalPages) {
        items.push({type: 'page', page: rhs, isCurrent: false});
      }
      if (items.length === maxVisiblePages) break;
      const lhs = currentPage - offset;
      if (lhs >= 0) {
        items.unshift({type: 'page', page: lhs, isCurrent: false});
      }
      if (items.length === maxVisiblePages) break;
    }

    (items[0] as {page: number}).page = 0;
    (items.at(-1) as {page: number}).page = totalPages - 1;

    if (
      items[1] &&
      (items[1] as {page: number}).page !==
        (items[0] as {page: number}).page + 1
    ) {
      items[1].type = 'ellipsis';
    }
    if (
      items.at(-2) &&
      (items.at(-2) as {page: number}).page !==
        (items.at(-1) as {page: number}).page - 1
    ) {
      items.at(-2)!.type = 'ellipsis';
    }
    return items;
  };

  const pages = getPages();

  return (
    <div className={twMerge('flex w-full gap-px', className)}>
      {render({
        type: 'prev',
        page: currentPage - 1,
        disabled: currentPage === 0,
      })}
      <div
        ref={containerRef}
        className='flex flex-1 justify-center gap-px overflow-hidden'
      >
        {pages.map((item, i) => (
          <Fragment key={i}>{render(item)}</Fragment>
        ))}
      </div>
      {render({
        type: 'next',
        page: currentPage + 1,
        disabled: currentPage >= totalPages - 1,
      })}
    </div>
  );
};

/**
 * Komponente zur Anzeige der Paginierung mit Seitenlinks und Navigation.
 * @param totalPages Gesamtanzahl der Seiten
 * @param className optionale CSS-Klassen für die Paginierung
 */
export const Pagination = ({
  totalPages,
  className,
}: {
  totalPages: number;
  className?: string;
}) => {
  const loc = useLocation();
  const currentPage = Math.min(usePage(), totalPages - 1);

  if (totalPages <= 1) return null;

  return (
    <PaginationBase
      totalPages={totalPages}
      className={className}
      currentPage={currentPage}
      itemWidth={32}
      render={(item) => {
        switch (item.type) {
          case 'page': {
            const search = new URLSearchParams(loc.search);
            search.set('page', `${item.page + 1}`);
            return (
              <Link
                className={twMerge(
                  'flex size-8 items-center justify-center rounded text-gray-400',
                  item.isCurrent
                    ? 'bg-primary text-white'
                    : 'hover:bg-primary-light hover:text-primary',
                )}
                to={{...loc, search: search.toString()}}
              >
                {item.page + 1}
              </Link>
            );
          }
          case 'ellipsis':
            return <div className='w-8 text-center'>...</div>;
          case 'prev':
          case 'next':
            return <PrevOrNext {...item} />;
        }
      }}
    />
  );
};

/**
 * Komponente für die Darstellung der vorherigen oder nächsten Navigationsschaltfläche.
 * @param type Typ der Navigation ('prev' oder 'next')
 * @param page Zielseite der Navigation (0-basiert)
 * @param disabled Gibt an, ob die Schaltfläche deaktiviert ist
 */
const PrevOrNext = ({
  type,
  page,
  disabled,
}: Extract<PaginationItem, {type: 'prev' | 'next'}>) => {
  const loc = useLocation();
  const search = new URLSearchParams(loc.search);
  search.set('page', `${page + 1}`);
  const className = twMerge(
    'flex w-8 flex-none items-center justify-center rounded',
  );
  const inner = type === 'prev' ? <ChevronLeftIcon /> : <ChevronRightIcon />;
  return disabled ? (
    <div className={twMerge(className, 'text-gray-400')}>{inner}</div>
  ) : (
    <Link
      className={twMerge(
        className,
        'hover:bg-primary-light hover:text-primary',
      )}
      to={{...loc, search: search.toString()}}
    >
      {inner}
    </Link>
  );
};

/**
 * Hook zur Ermittlung der aktuellen Seite aus der URL-Query.
 * @returns Aktuelle Seite (0-basiert), mindestens 0
 */
export const usePage = () => {
  const loc = useLocation();
  const search = new URLSearchParams(loc.search);
  let currentPage = parseInt(search.get('page') ?? '0') - 1;
  if (Number.isNaN(currentPage) || currentPage < 0) {
    currentPage = 0;
  }
  return currentPage;
};

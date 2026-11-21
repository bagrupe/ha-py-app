import {type FC} from 'react';
import {twMerge} from 'tailwind-merge';
import {LageGebietStatus, LageStatus} from '../../__generated__/graphql.ts';
import {type ButtonProps} from '../../components/ui/button';

export const lageStatusLabel: Record<LageStatus, string> = {
  [LageStatus.Created]: 'Angelegt',
  [LageStatus.Active]: 'Aktiv',
  [LageStatus.Closed]: 'Geschlossen',
};

export const lageGebietStatusLabel: Record<LageGebietStatus, string> = {
  [LageGebietStatus.Inactive]: 'Inaktiv',
  [LageGebietStatus.CalledOut]: 'Alarmiert',
  [LageGebietStatus.Ready]: 'Einsatzbereit',
  [LageGebietStatus.Live]: 'Live',
  [LageGebietStatus.Ended]: 'Beendet',
  [LageGebietStatus.Done]: 'Abgeschlossen',
};

const badgeColor: Record<LageStatus | LageGebietStatus, string> = {
  [LageStatus.Created]: 'bg-gray-200 text-gray-700',
  [LageStatus.Active]: 'bg-green-100 text-green-800',
  [LageStatus.Closed]: 'bg-gray-300 text-gray-700',
  [LageGebietStatus.Inactive]: 'bg-gray-200 text-gray-700',
  [LageGebietStatus.CalledOut]: 'bg-yellow-100 text-yellow-800',
  [LageGebietStatus.Ready]: 'bg-blue-100 text-blue-800',
  [LageGebietStatus.Live]: 'bg-green-100 text-green-800',
  [LageGebietStatus.Ended]: 'bg-gray-300 text-gray-700',
  [LageGebietStatus.Done]: 'bg-gray-100 text-gray-500',
};

export const StatusBadge: FC<{
  status: LageStatus | LageGebietStatus;
  className?: string;
}> = ({status, className}) => (
  <span
    className={twMerge(
      'inline-block rounded-full px-3 py-0.5 text-sm font-semibold',
      badgeColor[status],
      className,
    )}
  >
    {status in lageGebietStatusLabel
      ? lageGebietStatusLabel[status as LageGebietStatus]
      : lageStatusLabel[status as LageStatus]}
  </span>
);

export type GebietTransition = {
  status: LageGebietStatus;
  label: string;
  variant: ButtonProps['variant'];
};

/** Mirrors the transitions allowed by LageGebietStateMachine in the backend. */
export const gebietTransitions: Record<LageGebietStatus, GebietTransition[]> = {
  [LageGebietStatus.Inactive]: [
    {status: LageGebietStatus.CalledOut, label: 'Alarmieren', variant: 'solid'},
  ],
  [LageGebietStatus.CalledOut]: [
    {
      status: LageGebietStatus.Ready,
      label: 'Einsatzbereit melden',
      variant: 'solid',
    },
    {status: LageGebietStatus.Ended, label: 'Beenden', variant: 'outlined'},
  ],
  [LageGebietStatus.Ready]: [
    {status: LageGebietStatus.Live, label: 'Live schalten', variant: 'solid'},
    {status: LageGebietStatus.Ended, label: 'Beenden', variant: 'outlined'},
  ],
  [LageGebietStatus.Live]: [
    {status: LageGebietStatus.Ended, label: 'Beenden', variant: 'outlined'},
  ],
  [LageGebietStatus.Ended]: [
    {
      status: LageGebietStatus.Done,
      label: 'Abschließen',
      variant: 'outlined',
    },
  ],
  [LageGebietStatus.Done]: [],
};

/** Mirrors LageGebietStateMachine.IsOpen: only one open pass per Gebiet is allowed. */
export const isOpenGebietStatus = (status: LageGebietStatus) =>
  status === LageGebietStatus.Inactive ||
  status === LageGebietStatus.CalledOut ||
  status === LageGebietStatus.Ready ||
  status === LageGebietStatus.Live;

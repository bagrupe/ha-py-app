import {ZustaendigkeitArt} from 'src/__generated__/graphql.ts';
import {
  type IdFactory,
  type ProcessMetadata,
  type SchrittNode,
  type ZustaendigkeitRolle,
} from '../flow/flow.types.ts';

type SchrittData = SchrittNode['data']['schritt'];

const defaultCreateId: IdFactory = () => crypto.randomUUID();

/** Name is a process metadatum saved independently of versioning, so it never marks
 *  the version dirty (mirrors the store's `setName`). */
export const setName = (
  meta: ProcessMetadata,
  name: string,
): ProcessMetadata => ({...meta, name});

export const setStartId = (
  meta: ProcessMetadata,
  id: string | null,
): ProcessMetadata => ({...meta, startId: id, hasVersionChanges: true});

export const addRole = (
  meta: ProcessMetadata,
  name: string,
  options: {createId?: IdFactory} = {},
): ProcessMetadata => {
  const createId = options.createId ?? defaultCreateId;
  return {
    ...meta,
    rollen: [...meta.rollen, {id: createId(), name}],
    hasVersionChanges: true,
  };
};

export const updateRole = (
  meta: ProcessMetadata,
  id: string,
  patch: Partial<Omit<ZustaendigkeitRolle, 'id'>>,
): ProcessMetadata => ({
  ...meta,
  rollen: meta.rollen.map((rolle) =>
    rolle.id === id ? {...rolle, ...patch} : rolle,
  ),
  hasVersionChanges: true,
});

type StepWithResolvedRoleNames = SchrittData & {
  schreibtRolle: ZustaendigkeitRolle | null;
  sollZustaendigkeit: {liestRolle: ZustaendigkeitRolle | null};
};

const findRolle = (
  rollen: ZustaendigkeitRolle[],
  id: string | null | undefined,
): ZustaendigkeitRolle | null =>
  (id != null && rollen.find((r) => r.id === id)) || null;

export const resolveRoleRefs = (
  step: SchrittData,
  metadata: ProcessMetadata,
): StepWithResolvedRoleNames => {
  if (step.__typename === 'GhostSchritt') {
    return step as StepWithResolvedRoleNames;
  }

  const liestRolleId =
    step.sollZustaendigkeit.art === ZustaendigkeitArt.Dynamisch
      ? step.sollZustaendigkeit.liestRolleId
      : null;

  return {
    ...step,
    schreibtRolle: findRolle(metadata.rollen, step.schreibtRolleId),
    sollZustaendigkeit: {
      ...step.sollZustaendigkeit,
      liestRolle: findRolle(metadata.rollen, liestRolleId),
    },
  } as StepWithResolvedRoleNames;
};

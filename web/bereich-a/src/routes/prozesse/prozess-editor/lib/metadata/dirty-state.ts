import {type EdgeChange, type NodeChange} from '@xyflow/react';

/**
 * Classifies whether a raw React Flow change is a version change. React Flow emits
 * frequent view-only changes (selection, measured dimensions, in-flight drag) that must
 * not mark the version dirty. A position change is only dirty once the drag is committed
 * (`dragging === false`). Attach/detach, paste/duplicate and role/start changes are dirty
 * too, but they are driven by graph-op / metadata reducers rather than raw change events.
 */
export const isDirtyNodeChange = (change: NodeChange): boolean => {
  switch (change.type) {
    case 'add':
    case 'remove':
    case 'replace':
      return true;
    case 'position':
      return change.dragging === false;
    case 'select':
    case 'dimensions':
      return false;
  }
};

export const isDirtyEdgeChange = (change: EdgeChange): boolean => {
  switch (change.type) {
    case 'add':
    case 'remove':
    case 'replace':
      return true;
    case 'select':
      return false;
  }
};

export const hasDirtyChange = (
  nodeChanges: NodeChange[],
  edgeChanges: EdgeChange[],
): boolean =>
  nodeChanges.some(isDirtyNodeChange) || edgeChanges.some(isDirtyEdgeChange);

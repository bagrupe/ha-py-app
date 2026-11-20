import {
  Background,
  Controls,
  MiniMap,
  ReactFlow,
  type OnConnect,
  type OnConnectStart,
  type OnConnectEnd,
  type OnNodeDrag,
  type XYPosition,
  type ReactFlowInstance,
  type OnBeforeDelete,
  type OnReconnect,
  type SelectionDragHandler,
} from '@xyflow/react';
import {type FC, useCallback, useRef, useState} from 'react';

import '@xyflow/react/dist/style.css';
import './reactflow-style-overrides.css';
import {useConfirm} from 'src/components/modal/confirm-modal.tsx';
import {useCopyPaste} from '../lib/clipboard/use-copy-paste.ts';
import {type SchrittNode, type VerbindungEdge} from '../lib/flow/flow.types.ts';
import {useUndoRedo} from '../lib/history/use-undo-redo.ts';
import {type Action, getDeleteAction} from '../lib/node-helpers.ts';
import {useProzessEditorStore} from '../lib/store';
import {KommunalappProzessEdge} from './kommunalapp-prozess-edge.tsx';
import {KommunalappSchrittNode} from './kommunalapp-schritt-node.tsx';
import {
  NeuerSchrittSelect,
  newSchrittByType,
  type NeuerSchrittSelectProps,
} from './neuer-schritt.tsx';

const nodeTypes = {
  schritt: KommunalappSchrittNode,
};

const edgeTypes = {
  kommunalEdge: KommunalappProzessEdge,
};

type Instance = ReactFlowInstance<SchrittNode, VerbindungEdge>;

/**
 * React Flow shell of the Prozess-Editor. React Flow owns the live graph: `nodes` and
 * `edges` are the controlled store state, mutated through the pure graph operations and
 * the change handlers. No domain-to-flow rebuild and no filtered remove handlers exist
 * any more — deletion is gated by `onBeforeDelete`.
 */
export const EditorPane: FC = () => {
  const nodes = useProzessEditorStore((state) => state.nodes);
  const edges = useProzessEditorStore((state) => state.edges);

  const onNodesChange = useProzessEditorStore((state) => state.onNodesChange);
  const onEdgesChange = useProzessEditorStore((state) => state.onEdgesChange);
  const connect = useProzessEditorStore((state) => state.connect);
  const reconnect = useProzessEditorStore((state) => state.reconnect);
  const addConnectedStep = useProzessEditorStore(
    (state) => state.addConnectedStep,
  );
  const detachToGhost = useProzessEditorStore((state) => state.detachToGhost);
  const attachGhost = useProzessEditorStore((state) => state.attachGhost);
  const takeSnapshot = useProzessEditorStore((state) => state.takeSnapshot);
  const dropRedundantDragSnapshot = useProzessEditorStore(
    (state) => state.dropRedundantDragSnapshot,
  );
  const setIntersectionCause = useProzessEditorStore(
    (state) => state.setIntersectionCause,
  );

  useCopyPaste();
  useUndoRedo();

  const [neuerSchrittSelect, setNeuerSchrittSelect] = useState<
    | (Omit<NeuerSchrittSelectProps, 'onSelect' | 'onClickAway'> & {
        position: XYPosition;
      })
    | undefined
  >(undefined);

  const reactFlowRef = useRef<HTMLDivElement | null>(null);
  const reactFlowInstanceRef = useRef<Instance | null>(null);
  const connectingNodeId = useRef<string | null>(null);

  const confirm = useConfirm();

  const onConnect = useCallback<OnConnect>(
    ({source, target}) => {
      connectingNodeId.current = null;
      if (!source || !target) return;
      connect({source, target});
    },
    [connect],
  );

  const onConnectStart = useCallback<OnConnectStart>((_, {nodeId}) => {
    connectingNodeId.current = nodeId;
  }, []);

  /**
   * Opens the "neuer Schritt" popover at the cursor when a connection is dropped on the
   * empty pane.
   */
  const onConnectEnd = useCallback<OnConnectEnd>((event) => {
    if (
      !connectingNodeId.current ||
      !reactFlowRef.current ||
      !('clientX' in event)
    )
      return;

    const eventTarget = event.target as HTMLElement | null;
    const targetIsPane = eventTarget?.classList.contains('react-flow__pane');
    if (!targetIsPane) return;

    const pane = reactFlowRef.current.getBoundingClientRect();
    const offsetY = 200;
    const offsetX = 250;

    setNeuerSchrittSelect({
      position: {x: event.clientX, y: event.clientY},
      top:
        event.clientY < pane.bottom - offsetY
          ? event.clientY - pane.top
          : undefined,
      left:
        event.clientX < pane.right - offsetX
          ? event.clientX - pane.left
          : undefined,
      right:
        event.clientX >= pane.right - offsetX
          ? pane.width - event.clientX
          : undefined,
      bottom:
        event.clientY >= pane.bottom - offsetY
          ? pane.height - event.clientY + pane.top
          : undefined,
    });
  }, []);

  /** Snapshots the graph once when a drag begins so the whole move is a single undo step
   *  (position changes themselves stream through `onNodesChange` and are not snapshotted). */
  const onNodeDragStart = useCallback<OnNodeDrag<SchrittNode>>(() => {
    takeSnapshot();
  }, [takeSnapshot]);

  const onSelectionDragStart = useCallback<SelectionDragHandler>(() => {
    takeSnapshot();
  }, [takeSnapshot]);

  const onSelectionDragStop = useCallback<SelectionDragHandler>(() => {
    dropRedundantDragSnapshot();
  }, [dropRedundantDragSnapshot]);

  const onNodeDrag = useCallback<OnNodeDrag<SchrittNode>>(
    (_, node) => {
      if (node.data.schritt.__typename === 'GhostSchritt') return;
      const instance = reactFlowInstanceRef.current;
      if (!instance) return;
      if (edges.some((e) => e.source === node.id || e.target === node.id)) {
        return;
      }

      const intersections = instance
        .getIntersectingNodes(node, true)
        .map((n) => n.id);
      setIntersectionCause(intersections[0] ?? null, node.measured);
    },
    [edges, setIntersectionCause],
  );

  /** Commits a drag: position is already persisted via change events, so this only
   *  attaches the node when it was dropped onto a ghost and clears the highlight. */
  const onNodeDragStop = useCallback<OnNodeDrag<SchrittNode>>(
    (_, node) => {
      setIntersectionCause(null);
      // A drag that ended where it started left a no-op snapshot from onNodeDragStart.
      dropRedundantDragSnapshot();

      if (node.data.schritt.__typename === 'GhostSchritt') return;
      const instance = reactFlowInstanceRef.current;
      if (!instance) return;
      if (edges.some((e) => e.source === node.id || e.target === node.id)) {
        return;
      }

      const firstId = instance.getIntersectingNodes(node)[0]?.id;
      if (!firstId) return;

      const target = nodes.find((n) => n.id === firstId);
      if (target?.data.schritt.__typename !== 'GhostSchritt') return;

      attachGhost(node.id, firstId);
    },
    [
      attachGhost,
      dropRedundantDragSnapshot,
      edges,
      nodes,
      setIntersectionCause,
    ],
  );

  /**
   * Confirms before deletion. A connected normal step is detached (a ghost is inserted)
   * instead of deleted, so this handler cancels React Flow's own removal and performs the
   * detach; every other case lets React Flow remove the elements through the change
   * handlers.
   */
  const onBeforeDelete = useCallback<
    OnBeforeDelete<SchrittNode, VerbindungEdge>
  >(
    async ({nodes: toDelete, edges: incidentEdges}) => {
      const action = getDeleteAction({nodes: toDelete, edges: incidentEdges});

      // A multi-node selection is removed wholesale (nodes + incident edges); React Flow
      // already includes the incident edges in this payload, so confirming lets it through.
      if (action === 'delete-many') {
        const confirmed = await confirm({
          content: `Sind Sie sicher, dass Sie die ${toDelete.length} ausgewählten Schritte und deren Verbindungen löschen möchten?`,
          confirmText: 'Löschen',
          confirmVariant: 'destructive',
        });
        if (confirmed) takeSnapshot();
        return confirmed;
      }

      const messages: Record<Exclude<Action, 'delete-many'>, string> = {
        'delete-node':
          'Sind Sie sicher, dass Sie diesen Schritt löschen möchten?',
        'delete-ghost-node': `Sind Sie sicher, dass Sie diesen Platzhalter${
          incidentEdges.length > 0 ? ' und dessen Verbindungen' : ''
        } löschen möchten?`,
        'detach-node':
          'Sind Sie sicher, dass Sie diesen Schritt lösen möchten? Der Schritt wird nicht gelöscht und ein Platzhalter wird eingefügt.',
        'delete-edge':
          'Sind Sie sicher, dass Sie diese Verbindung löschen möchten?',
      };

      const isDelete = action !== 'detach-node';

      const confirmed = await confirm({
        content: messages[action],
        confirmText: isDelete ? 'Löschen' : 'Lösen',
        confirmVariant: isDelete ? 'destructive' : 'solid',
      });

      if (!confirmed) return false;

      if (action === 'detach-node') {
        detachToGhost(toDelete[0].id, toDelete[0].measured);
        return false;
      }

      // React Flow is about to remove the elements through the change handlers — snapshot
      // first so the deletion is undoable.
      takeSnapshot();
      return true;
    },
    [confirm, detachToGhost, takeSnapshot],
  );

  const onReconnect = useCallback<OnReconnect<VerbindungEdge>>(
    (edge, connection) => {
      reconnect(edge.id, connection);
    },
    [reconnect],
  );

  const onSchrittSelect: NeuerSchrittSelectProps['onSelect'] = (
    label,
    typeName,
  ) => {
    const vonId = connectingNodeId.current;
    const position = neuerSchrittSelect?.position
      ? reactFlowInstanceRef.current?.screenToFlowPosition(
          neuerSchrittSelect.position,
        ) ?? {x: 100, y: 100}
      : {x: 100, y: 100};
    setNeuerSchrittSelect(undefined);

    if (!vonId) return;
    const stepData = newSchrittByType({titel: label, __typename: typeName});
    addConnectedStep(vonId, stepData, position);
  };

  return (
    <div className='size-full bg-gray-100'>
      <ReactFlow
        onInit={(instance) => {
          reactFlowInstanceRef.current = instance;
        }}
        edgeTypes={edgeTypes}
        nodeTypes={nodeTypes}
        nodes={nodes}
        edges={edges}
        onNodesChange={onNodesChange}
        onEdgesChange={onEdgesChange}
        onNodeDragStart={onNodeDragStart}
        onNodeDragStop={onNodeDragStop}
        onNodeDrag={onNodeDrag}
        onSelectionDragStart={onSelectionDragStart}
        onSelectionDragStop={onSelectionDragStop}
        onBeforeDelete={onBeforeDelete}
        onReconnect={onReconnect}
        onConnect={onConnect}
        onConnectStart={onConnectStart}
        onConnectEnd={onConnectEnd}
        onPaneMouseEnter={() => setNeuerSchrittSelect(undefined)}
        edgesFocusable={false}
        multiSelectionKeyCode='Shift'
        selectionKeyCode={null}
        selectNodesOnDrag={false}
        nodeDragThreshold={1}
        snapGrid={[10, 10]}
        snapToGrid
        ref={reactFlowRef}
      >
        <Background gap={10} />
        <Controls />
        <MiniMap pannable zoomable zoomStep={1} />
        {neuerSchrittSelect && (
          <NeuerSchrittSelect
            onSelect={onSchrittSelect}
            onClickAway={() => setNeuerSchrittSelect(undefined)}
            {...neuerSchrittSelect}
          />
        )}
      </ReactFlow>
    </div>
  );
};

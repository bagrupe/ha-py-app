import {
  type KeyCode,
  type XYPosition,
  useKeyPress,
  useReactFlow,
  useStore,
} from '@xyflow/react';
import {useCallback, useEffect, useRef} from 'react';
import {useProzessEditorStore} from '../store';

/** Fallback paste offset when no cursor position is tracked (mouse off the pane). */
const PASTE_NUDGE: XYPosition = {x: 20, y: 20};

/**
 * Wires Cmd/Ctrl+C and Cmd/Ctrl+V to the store's copy/paste actions. Copy snapshots the
 * current selection; paste clones it offset so the pasted subgraph's top-left lands under
 * the cursor (or nudged when the cursor is off the pane). Must be called inside the
 * React Flow context (it reads the pane dom node and `screenToFlowPosition`).
 */
export const useCopyPaste = (): void => {
  const rfDomNode = useStore((state) => state.domNode);
  const {screenToFlowPosition} = useReactFlow();
  const mousePosRef = useRef<XYPosition | null>(null);

  const copy = useProzessEditorStore((state) => state.copy);
  const paste = useProzessEditorStore((state) => state.paste);

  useEffect(() => {
    if (!rfDomNode) return;
    const onMouseMove = (event: MouseEvent) => {
      mousePosRef.current = {x: event.clientX, y: event.clientY};
    };
    rfDomNode.addEventListener('mousemove', onMouseMove);
    return () => rfDomNode.removeEventListener('mousemove', onMouseMove);
  }, [rfDomNode]);

  const handlePaste = useCallback(() => {
    const {clipboard} = useProzessEditorStore.getState();
    if (!clipboard || clipboard.nodes.length === 0) return;

    const mouse = mousePosRef.current;
    if (!mouse) {
      paste(PASTE_NUDGE);
      return;
    }

    // Anchor the copied subgraph's top-left corner at the cursor (Pro paste behavior).
    const cursor = screenToFlowPosition(mouse);
    const minX = Math.min(...clipboard.nodes.map((node) => node.position.x));
    const minY = Math.min(...clipboard.nodes.map((node) => node.position.y));
    paste({x: cursor.x - minX, y: cursor.y - minY});
  }, [paste, screenToFlowPosition]);

  useShortcut(['Meta+c', 'Control+c'], copy, true);
  useShortcut(['Meta+v', 'Control+v'], handlePaste);
};

/**
 * Adapted from the React Flow Pro copy-paste template. `actInsideInputWithModifier: false`
 * keeps native copy/paste working inside form fields, and for copy the native browser copy
 * is preserved whenever text is selected on the page. The rising-edge guard uses a ref
 * (the Pro template uses state) so the key only fires once per press without re-rendering.
 */
function useShortcut(
  keyCode: KeyCode,
  callback: () => void,
  isCopyAction = false,
): void {
  const didRunRef = useRef(false);
  const shouldRun = useKeyPress(keyCode, {
    actInsideInputWithModifier: false,
    preventDefault: false,
  });

  useEffect(() => {
    const selection = window.getSelection()?.toString();
    const allowCopy = isCopyAction ? !selection : true;

    if (shouldRun && !didRunRef.current && allowCopy) {
      callback();
      didRunRef.current = true;
    } else {
      didRunRef.current = shouldRun;
    }
  }, [shouldRun, callback, isCopyAction]);
}
